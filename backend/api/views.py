from django.http import JsonResponse
from django.views.decorators.csrf import csrf_exempt
import oracledb
import json

DB_USER = "neo"
DB_PASSWORD = "trinity123"
DB_DSN = "localhost:1521/THEMATRIX"  


def get_oracle_connection():
    return oracledb.connect(user=DB_USER, password=DB_PASSWORD, dsn=DB_DSN)


@csrf_exempt
def test_connection(request):
    try:
        
        input_data = request.body.decode('utf-8')
        try:
            parsed_data = json.loads(input_data)  
            print(parsed_data)
        except json.JSONDecodeError:
            parsed_data = input_data  

        
        connection = get_oracle_connection()
        cursor = connection.cursor()

        
        cursor.execute("""
        SELECT Cases.case_id, Cases.case_type, Appeal.appeal_date, Appeal.reason
        FROM Cases
        LEFT JOIN Appeal ON Cases.case_id = Appeal.case_id
        """)

        
        column_names = [col[0] for col in cursor.description]

        
        rows = cursor.fetchall()

        
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

        
        response = {
            "data": data_list if data_list else [],
            "message": "Query executed successfully" if data_list else "No data available"
        }
        return JsonResponse(response, safe=False)

    except Exception as e:
        return JsonResponse({'error': str(e)}, status=500)
