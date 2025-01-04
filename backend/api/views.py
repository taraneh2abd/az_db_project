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
SELECT *
FROM Court_Session
WHERE 
  session_date BETWEEN {start_date} AND {end_date}
  AND court_name = '{court_name}'

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
    p1.first_name AS party_1_first_name,
    p1.last_name AS party_1_last_name,
    r1.role AS party_1_role,
    p2.first_name AS party_2_first_name,
    p2.last_name AS party_2_last_name,
    r2.role AS party_2_role,
    c.case_id, c.case_type
FROM 
    Involved_Party p1
INNER JOIN 
    Role_Assignment r1 ON p1.party_id = r1.party_id
INNER JOIN 
    Cases c ON r1.case_id = c.case_id
INNER JOIN 
    Role_Assignment r2 ON c.case_id = r2.case_id
INNER JOIN 
    Involved_Party p2 ON r2.party_id = p2.party_id
WHERE 
    p1.party_id != p2.party_id
    """,
    5: """
SELECT 
    p1.first_name AS party_1_first_name,
    p1.last_name AS party_1_last_name,
    p2.first_name AS party_2_first_name,
    p2.last_name AS party_2_last_name,
    COUNT(c.case_id) AS case_count
FROM 
    Involved_Party p1
INNER JOIN 
    Role_Assignment r1 ON p1.party_id = r1.party_id
INNER JOIN 
    Cases c ON r1.case_id = c.case_id
INNER JOIN 
    Role_Assignment r2 ON c.case_id = r2.case_id
INNER JOIN 
    Involved_Party p2 ON r2.party_id = p2.party_id
WHERE 
    p1.party_id != p2.party_id
GROUP BY 
    p1.first_name, p1.last_name, p2.first_name, p2.last_name
    """,
    6: """
SELECT *
    -- Evidence.case_id, 
    -- Evidence.description, 
    -- Evidence.evidence_type, 
    -- Evidence.date_submitted, 
    -- Involved_Party.first_name,
    -- Involved_Party.last_name
FROM Evidence
 FULL OUTER JOIN Person_Evidence_Relation ON Evidence.case_id = Person_Evidence_Relation.evidence_id
 FULL OUTER JOIN Involved_Party ON Person_Evidence_Relation.person_id = Involved_Party.party_id
    """,
    7:"""
SELECT 
    r1.client_id AS plaintiff_client_id, 
    r2.client_id AS defendant_client_id, 
    r1.lawyer_id, Involved_Party.first_name AS lawyer_first_name,
    Involved_Party.last_name AS lawyer_last_name
FROM Representation r1
INNER JOIN Representation r2 ON r1.lawyer_id = r2.lawyer_id
INNER JOIN Involved_Party ON r1.lawyer_id = Involved_Party.party_id
WHERE r1.client_id != r2.client_id
""",
8:"""
SELECT 
    Involved_Party.first_name,
    Involved_Party.last_name, 
    Role_Assignment.role, 
    Role_Assignment.case_id
FROM Involved_Party
LEFT JOIN Role_Assignment ON Involved_Party.party_id = Role_Assignment.party_id
""",
9:"""
SELECT 
    c1.case_id AS referring_case_id,
    c1.case_type AS referring_case_type,
    c1.status AS referring_case_status,
    c2.case_id AS referred_case_id,
    c2.case_type AS referred_case_type,
    c2.status AS referred_case_status,
    cr.referral_date
FROM 
    Case_Referral cr
INNER JOIN 
    Cases c1 ON cr.referring_case_id = c1.case_id
INNER JOIN 
    Cases c2 ON cr.referred_case_id = c2.case_id
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
        # اگر person_id داده شده باشد، به کوئری شرط INNER JOIN اضافه می‌کنیم
        if person_id:
            join_condition = f"""
                WHERE i.party_id = {person_id} 
            """
            query = query.format(join_condition=join_condition)
        else:
            query = query.format(join_condition="")  # اگر person_id وجود ندارد، شرط را خالی می‌کنیم
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
