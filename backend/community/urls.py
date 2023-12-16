# community/urls.py
from django.urls import path
from community.views import *

urlpatterns = [
    path('', community_profile_list, name='community-list'),
    path('<int:pk>', community_profile_detail, name='community-detail'),
    path('<int:community_id>/make_admin/<int:user_id>', make_community_admin, name='make_community_admin'),

]
