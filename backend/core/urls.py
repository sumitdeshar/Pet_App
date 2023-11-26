from django.urls import path
from . import views
  
app_name = 'core'

urlpatterns = [  
    path('', views.index, name = "home"),
    path('login', views.login, name = "login"),
    path('register', views.register, name='register'),
    path('logout', views.logout, name = "logout"),
    path('check', views.checkuser, name = "check"),
    path('owner_profile/<int:owner_id>/', views.owner_profile, name='owner_profile'),
    path('pet/<int:pet_id>/', views.pet_profile, name='pet_profile'),
    path('profile/', views.get_pet_owner_profile.as_view(), name='get_pet_owner_profile'),
]