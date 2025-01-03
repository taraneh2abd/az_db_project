from django.http import JsonResponse
from django.views.decorators.csrf import csrf_exempt
import oracledb
import json

# اطلاعات اتصال به دیتابیس
DB_USER = "neo"
DB_PASSWORD = "trinity123"
DB_DSN = "localhost:1521/THEMATRIX"

# اتصال به دیتابیس اوراکل
def get_oracle_connection():
    return oracledb.connect(user=DB_USER, password=DB_PASSWORD, dsn=DB_DSN)

# دیکشنری کوئری‌ها بر اساس دکمه فشرده شده
QUERY_MAP = {
    1: """
        SELECT 
            i.party_id AS involved_party_id,
            i.first_name AS involved_party_first_name,
            i.last_name AS involved_party_last_name,
            c.case_id,
            c.case_type,
            c.description,
            a.appeal_date,
            a.reason
        FROM 
            Involved_Party i
        INNER JOIN 
            Writes w ON i.party_id = w.writer_id
        INNER JOIN 
            Appeal a ON w.case_id = a.case_id AND w.appeal_date = a.appeal_date
        RIGHT JOIN 
            Cases c ON w.case_id = c.case_id
        {join_condition}
    """,
    2: """
        SELECT 
            i.party_id AS involved_party_id,
            i.first_name AS involved_party_first_name,
            i.last_name AS involved_party_last_name,
            c.case_id,
            c.case_type,
            c.description,
            a.appeal_date,
            a.reason,
            w.writer_id
        FROM 
            Involved_Party i
        INNER JOIN 
            Writes w ON i.party_id = w.writer_id
        INNER JOIN 
            Appeal a ON w.case_id = a.case_id AND w.appeal_date = a.appeal_date
        INNER JOIN 
            Cases c ON w.case_id = c.case_id
    """,
    3: """
SELECT 
    ip.party_id AS involved_party_id,
    ip.first_name AS involved_party_first_name,
    ip.last_name AS involved_party_last_name,
    c.case_id,
    c.case_type,
    c.description,
    v.date_issued AS verdict_date,
    v.verdict_type,
    v.summary AS verdict_summary
FROM 
    Involved_Party ip
INNER JOIN 
    Role_Assignment ra ON ip.party_id = ra.party_id
INNER JOIN 
    Cases c ON ra.case_id = c.case_id
LEFT JOIN 
    Verdict v ON c.case_id = v.case_id
    """,
    4: """
        SELECT 
            i.party_id AS involved_party_id,
            i.first_name AS involved_party_first_name,
            i.last_name AS involved_party_last_name,
            c.case_id,
            c.case_type
        FROM 
            Involved_Party i
        INNER JOIN 
            Role_Assignment r1 ON i.party_id = r1.party_id
        INNER JOIN 
            Cases c ON r1.case_id = c.case_id
        INNER JOIN 
            Role_Assignment r2 ON c.case_id = r2.case_id
        INNER JOIN 
            Involved_Party p2 ON r2.party_id = p2.party_id
        WHERE 
            i.party_id != p2.party_id
    """,
    5: """
        SELECT 
            i.party_id AS involved_party_id,
            i.first_name AS involved_party_first_name,
            i.last_name AS involved_party_last_name,
            r.role,
            r.case_id
        FROM 
            Involved_Party i
        LEFT JOIN 
            Role_Assignment r ON i.party_id = r.party_id
    """
}

@csrf_exempt
def test_connection(request):
    try:
        # دریافت داده‌های ورودی از فرانت
        input_data = request.body.decode('utf-8')
        parsed_data = json.loads(input_data)
        print("Received input from front-end:", parsed_data)  # چاپ ورودی دریافت شده

        button_index = parsed_data.get("buttonIndex", None)
        person_id = parsed_data.get("person-id", None)  # مطمئن می‌شویم که کلید درست است

        # بررسی که person_id داده شده باشد و تبدیل به عدد
        if person_id:
            try:
                person_id = int(person_id)  # تبدیل person_id به عدد
            except ValueError:
                return JsonResponse({"error": "Invalid person_id format. It must be an integer."}, status=400)
        else:
            person_id = None  # اگر person_id خالی باشد، به None تبدیل می‌شود

        # بررسی اینکه آیا buttonIndex معتبر است
        if button_index not in QUERY_MAP:
            return JsonResponse({"error": "Invalid buttonIndex provided."}, status=400)

        # انتخاب کوئری مناسب بر اساس buttonIndex
        query = QUERY_MAP[button_index]

        # بررسی اینکه آیا کوئری شامل {join_condition} است
        if "{join_condition}" in query:
            if person_id:
                join_condition = f"WHERE ip.party_id = {person_id}"
            else:
                join_condition = ""  # شرط خالی
            query = query.format(join_condition=join_condition)

        # اگر {join_condition} وجود ندارد، مستقیماً از کوئری استفاده کنید


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

        # بستن اتصال به دیتابیس
        cursor.close()
        connection.close()

        # پاسخ با داده‌ها و متن کوئری
        response = {
            "data": data_list if data_list else [],
            "message": query.strip()  # پیام حاوی کوئری اجرا شده
        }
        return JsonResponse(response, safe=False)

    except Exception as e:
        return JsonResponse({'error': str(e)}, status=500)
