from django.urls import path
from .import views

urlpatterns=[
    path('',views.index,name="acucrm_website")
]