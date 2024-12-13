from django.http import JsonResponse
from django.views.decorators.csrf import csrf_exempt
import json
import mysql.connector

@csrf_exempt
def execute_query(request):
    if request.method == "POST":
        try:
            # دریافت داده‌های ورودی
            data = json.loads(request.body)
            field1 = data.get("field1")
            field2 = data.get("field2")

            # تنظیمات دیتابیس
            connection = mysql.connector.connect(
                host="localhost",
                user="your_user",
                password="your_password",
                database="your_database"
            )
            cursor = connection.cursor()

            # اجرای دستور SQL
            query = "INSERT INTO your_table (field1, field2) VALUES (%s, %s)"
            cursor.execute(query, (field1, field2))
            connection.commit()

            # برگرداندن جدول‌ها
            cursor.execute("SHOW TABLES")
            tables = cursor.fetchall()

            return JsonResponse({"message": "Query executed!", "tables": [table[0] for table in tables]})

        except Exception as e:
            return JsonResponse({"error": str(e)}, status=400)

        finally:
            cursor.close()
            connection.close()
    else:
        return JsonResponse({"error": "Invalid method"}, status=405)
