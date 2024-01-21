# posts/urls.py
from django.urls import path
from posts.views import *

urlpatterns = [
    path('', display_posts, name='community-list'),
    path('create', post_create, name='create post'),
]