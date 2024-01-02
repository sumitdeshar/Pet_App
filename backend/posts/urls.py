# posts/urls.py
from django.urls import path
from posts.views import *

urlpatterns = [
    path('', display_posts, name='community-list'),
]