from django.http import JsonResponse
from django.views.decorators.csrf import csrf_exempt
import json
import mysql.connector

@csrf_exempt
def learning_api(request):
    return JsonResponse({"message": """SELECT users.id, users.name, orders.amount
FROM users 
JOIN orders ON users.id = orders.user_id
WHERE orders.amount > 100
ORDER BY orders.amount DESC
LIMIT 10;""",
  "data": [
    {
      "id": 1,
      "name": "Person A",
      "amount": 150
    },
    {
      "id": 2,
      "name": "Person B",
      "amount": 200
    },
    {
      "id": 3,
      "name": "Person C",
      "amount": 180
    },
    {
      "id": 4,
      "name": "Person A",
      "amount": 150
    },
    {
      "id": 5,
      "name": "Person B",
      "amount": 200
    },
    {
      "id": 6,
      "name": "Person C",
      "amount": 180
    }
  ]
})


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