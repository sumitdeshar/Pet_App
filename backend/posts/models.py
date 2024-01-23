from django.db import models
from core.utlis import random_id
from core.models import User
from community.models import CommunityProfile


# Create your models here.
class Post(models.Model):
    id = models.AutoField(primary_key=True, default=random_id, editable=False)
    community = models.ForeignKey(CommunityProfile, related_name='posts', on_delete=models.CASCADE)
    author = models.ForeignKey(User, on_delete=models.CASCADE)
    created_at = models.DateTimeField(auto_now_add=True)
    content = models.TextField()
    photo = models.ImageField(upload_to='post_photos/', blank=True, null=True)
    # video = models.ImageField(upload_to='videos/', blank=True, null=True, storage=VideoMediaCloudinaryStorage(),
    #                           validators=[validate_video])
    updated_at = models.DateTimeField(auto_now=True)

    def __str__(self):
        return f"Post by {self.author.username} in {self.community.community_name}"


class Comment(models.Model):
    id = models.AutoField(primary_key=True, default=random_id, editable=False)
    post = models.ForeignKey(Post, related_name='comments', on_delete=models.CASCADE)
    parent_comment = models.ForeignKey('self', null=True, blank=True, related_name='replies', on_delete=models.CASCADE)
    content = models.TextField()
    author = models.ForeignKey(User, on_delete=models.CASCADE)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    def __str__(self):
        return f"Comment by {self.author.username} on {self.post}"

    def get_replies(self):
        return Comment.objects.filter(parent_comment=self)


class Upvote(models.Model):
    id = models.AutoField(primary_key=True, default=random_id, editable=False)
    user = models.ForeignKey(User, on_delete=models.CASCADE)
    post = models.ForeignKey(Post, related_name='upvotes', null=True, blank=True, on_delete=models.CASCADE)
    comment = models.ForeignKey(Comment, related_name='upvotes', null=True, blank=True, on_delete=models.CASCADE)
    created_at = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        if self.post:
            return f"{self.user.username} upvoted post in {self.post.community.name}"
        elif self.comment:
            return f"{self.user.username} upvoted comment by {self.comment.author.username}"