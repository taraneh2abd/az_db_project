from django.http import JsonResponse
from django.views.decorators.csrf import csrf_exempt
import oracledb
import json

DB_USER = "neo"
DB_PASSWORD = "trinity123"
DB_DSN = "localhost:1521/THEMATRIX"


def get_oracle_connection():
    return oracledb.connect(user=DB_USER, password=DB_PASSWORD, dsn=DB_DSN)


QUERY_MAP = {
    1: """
        SELECT Cases.case_id, Cases.case_type, Case.description, Appeal.appeal_date, Appeal.reason
        FROM Cases
        LEFT JOIN Appeal ON Cases.case_id = Appeal.case_id;

    """,
    2: """
        SELECT Cases.case_id, Cases.case_type, Cases.description, Appeal.appeal_date, Appeal.reason
        FROM Cases
        LEFT JOIN Appeal ON Cases.case_id = Appeal.case_id
    """,
    3: """
        SELECT Appeal.case_id, Appeal.appeal_date, Appeal.reason, Cases.case_type
        FROM Appeal
        RIGHT JOIN Cases ON Appeal.case_id = Cases.case_id
    """,
    4: """
        SELECT p1.first_name AS party_1_first_name, p1.last_name AS party_1_last_name,
               p2.first_name AS party_2_first_name, p2.last_name AS party_2_last_name, 
               c.case_id, c.case_type
        FROM Involved_Party p1
        INNER JOIN Role_Assignment r1 ON p1.party_id = r1.party_id
        INNER JOIN Cases c ON r1.case_id = c.case_id
        INNER JOIN Role_Assignment r2 ON c.case_id = r2.case_id
        INNER JOIN Involved_Party p2 ON r2.party_id = p2.party_id
        WHERE p1.party_id != p2.party_id
    """,
    5: """
        SELECT Involved_Party.first_name, Involved_Party.last_name, Role_Assignment.role, Role_Assignment.case_id
        FROM Involved_Party
        LEFT JOIN Role_Assignment ON Involved_Party.party_id = Role_Assignment.party_id
    """
}


@csrf_exempt
def test_connection(request):
    try:
        # دریافت داده‌های ورودی از فرانت
        input_data = request.body.decode('utf-8')
        parsed_data = json.loads(input_data)

        # استخراج buttonIndex از ورودی
        button_index = parsed_data.get("buttonIndex", None)
        if button_index not in QUERY_MAP:
            return JsonResponse({"error": "Invalid buttonIndex provided."}, status=400)

        query = QUERY_MAP[button_index]

        # اتصال به دیتابیس
        connection = get_oracle_connection()
        cursor = connection.cursor()

        # اجرای کوئری
        cursor.execute(query)
        column_names = [col[0] for col in cursor.description]
        rows = cursor.fetchall()

        # تبدیل نتایج به فرمت JSON
        data_list = []
        for row in rows:
            row_dict = {}
            for index, value in enumerate(row):
                if isinstance(value, oracledb.LOB):
                    row_dict[column_names[index]] = value.read() if value else "N/A"
                else:
                    row_dict[column_names[index]] = value if value is not None else "N/A"
            data_list.append(row_dict)

        cursor.close()
        connection.close()

        # پاسخ با داده‌ها و متن کوئری
        response = {
            "data": data_list if data_list else [],
            "message": query.strip()
        }
        return JsonResponse(response, safe=False)

    except Exception as e:
        return JsonResponse({'error': str(e)}, status=500)
