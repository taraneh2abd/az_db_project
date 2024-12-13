# python manage.py createsuperuser --username admin --email admin@gmail.com --user_type basic --password !ADMIN00admin


from django.contrib import admin
from django.urls import path, include

urlpatterns = [
    path('admin/', admin.site.urls),
    path('api/', include('api.urls')),  # مسیر اپلیکیشن API
]
