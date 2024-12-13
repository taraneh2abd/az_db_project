from django.urls import path
from .views import execute_query,learning_api

urlpatterns = [
    path('execute_query/', execute_query, name='execute_query'),
    path('learning_api/', learning_api, name='learning_api'),
]
