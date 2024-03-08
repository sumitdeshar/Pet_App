from django.db.models import Max
from random import choice
from .models import Post

def get_latest_post_id(user_id=None):
    if user_id:
        latest_post_id = Post.objects.filter(author__id=user_id).aggregate(Max('post_id'))['post_id__max']

        if latest_post_id is not None:
            return latest_post_id

    all_post_ids = Post.objects.values_list('post_id', flat=True)
    return choice(all_post_ids) if all_post_ids else None
