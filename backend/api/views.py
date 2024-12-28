from django.http import JsonResponse
from django.views.decorators.csrf import csrf_exempt
import oracledb
import json


DB_USER = "neo"
DB_PASSWORD = "trinity123"
DB_DSN = "localhost:1521/THEMATRIX"  


import json
import oracledb
from django.http import JsonResponse
from django.views.decorators.csrf import csrf_exempt

# اتصال به Oracle Database
def get_oracle_connection():
    return oracledb.connect(user=DB_USER, password=DB_PASSWORD, dsn=DB_DSN)

# API برای تست اتصال و تبدیل داده‌ها به JSON
@csrf_exempt
def test_connection(request):
    try:
        # اتصال به دیتابیس
        connection = get_oracle_connection()
        cursor = connection.cursor()

        # اجرای دستور SQL برای دریافت کل داده‌های جدول
        cursor.execute("SELECT * FROM INVOLVED_PARTY")

        # گرفتن نام ستون‌ها
        column_names = [col[0] for col in cursor.description]

        # گرفتن تمام ردیف‌ها
        rows = cursor.fetchall()

        # تبدیل هر ردیف به یک دیکشنری
        data_list = []
        for row in rows:
            row_dict = {}
            for index, value in enumerate(row):
                # بررسی داده‌های CLOB و BLOB
                if isinstance(value, oracledb.LOB):
                    row_dict[column_names[index]] = value.read() if value else None
                else:
                    row_dict[column_names[index]] = value
            data_list.append(row_dict)

        # تبدیل به JSON
        json_data = json.dumps(data_list, ensure_ascii=False)

        # بستن ارتباط با دیتابیس
        cursor.close()
        connection.close()

        return JsonResponse(json.loads(json_data), safe=False)

    except Exception as e:
        return JsonResponse({'error': str(e)}, status=500)
