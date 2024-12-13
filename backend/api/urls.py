from django.urls import path
from .views import execute_query

urlpatterns = [
    path('execute_query/', execute_query, name='execute_query'),
]
