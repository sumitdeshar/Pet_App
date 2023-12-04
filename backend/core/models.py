from django.db import models
from django.contrib.auth.models import User

#create your models
class Profile(models.Model):
    user = models.OneToOneField(User, on_delete=models.CASCADE)
    phone_number = models.CharField(max_length=15)
    address = models.TextField()
    pet_info = models.ManyToManyField('Pet', blank=True)
    photo = models.ImageField(upload_to='media/profile_photos/', blank=True, null=True)

    def __str__(self):
        return self.user.username

class Pet(models.Model):
    name = models.CharField(max_length=100)
    species = models.CharField(max_length=50)
    breed = models.CharField(max_length=50)
    age = models.PositiveIntegerField()
    owner = models.ForeignKey('Profile', on_delete=models.CASCADE, related_name='pets')

    def __str__(self):
        return self.name



# class Community(models.Model):
#     name = models.CharField(max_length=100)
#     description = models.TextField()
#     members = models.ManyToManyField(User, related_name='communities', through='CommunityMembership')

#     def __str__(self):
#         return self.name

# class CommunityMembership(models.Model):
#     user = models.ForeignKey(User, on_delete=models.CASCADE)
#     community = models.ForeignKey(Community, on_delete=models.CASCADE)
#     is_admin = models.BooleanField(default=False)

# class Post(models.Model):
#     title = models.CharField(max_length=200)
#     content = models.TextField()
#     created_at = models.DateTimeField(auto_now_add=True)
#     author = models.ForeignKey(User, on_delete=models.CASCADE)
#     community = models.ForeignKey(Community, on_delete=models.CASCADE)
#     upvotes = models.PositiveIntegerField(default=0)

#     def __str__(self):
#         return self.title

# class Comment(models.Model):
#     content = models.TextField()
#     created_at = models.DateTimeField(auto_now_add=True)
#     author = models.ForeignKey(User, on_delete=models.CASCADE)
#     post = models.ForeignKey(Post, on_delete=models.CASCADE)
#     upvotes = models.PositiveIntegerField(default=0)

#     def __str__(self):
#         return self.content

# class SpecialNotice(models.Model):
#     title = models.CharField(max_length=200)
#     content = models.TextField()
#     created_at = models.DateTimeField(auto_now_add=True)
#     author = models.ForeignKey(User, on_delete=models.CASCADE)
#     community = models.ForeignKey(Community, on_delete=models.CASCADE)

#     def __str__(self):
#         return self.title