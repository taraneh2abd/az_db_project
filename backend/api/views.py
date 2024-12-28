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


def get_oracle_connection():
    return oracledb.connect(user=DB_USER, password=DB_PASSWORD, dsn=DB_DSN)



@csrf_exempt
def test_connection(request):
    try:
        
        connection = get_oracle_connection()
        cursor = connection.cursor()

        
        cursor.execute("SELECT * FROM INVOLVED_PARTY")

        
        column_names = [col[0] for col in cursor.description]

        
        rows = cursor.fetchall()

        
        data_list = []
        for row in rows:
            row_dict = {}
            for index, value in enumerate(row):
                
                if isinstance(value, oracledb.LOB):
                    row_dict[column_names[index]] = value.read() if value else None
                else:
                    row_dict[column_names[index]] = value
            data_list.append(row_dict)

        
        cursor.close()
        connection.close()

        
        response = {
            "data": data_list,
            "message": """SELECT
  *
FROM
  INVOLVED_PARTY;
"""
        }
        return JsonResponse(response, safe=False)

    except Exception as e:
        return JsonResponse({'error': str(e)}, status=500)