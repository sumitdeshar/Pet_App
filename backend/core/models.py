from django.db import models
from django.contrib.auth.models import User
from cloudinary_storage.storage import MediaCloudinaryStorage

#create your models
class Profile(models.Model):
    user = models.OneToOneField(User, on_delete=models.CASCADE)
    bio = models.TextField(blank=True)
    phone_number = models.CharField(max_length=15)
    address = models.TextField()
    dob = models.DateField(auto_now_add=True)
    pet_info = models.ManyToManyField('Pet', blank=True)
    photo = models.ImageField(upload_to='profile_photos/', blank=True, null=True)
    cover_photo = models.ImageField(
        upload_to='profile_covers/',
        blank=True,
        null=True,
        storage=MediaCloudinaryStorage()
    )


    def __str__(self):
        return self.user.username

class Pet(models.Model):
    name = models.CharField(max_length=100)
    species = models.CharField(max_length=50)
    breed = models.CharField(max_length=50)
    age = models.PositiveIntegerField()
    owner = models.ForeignKey('Profile', on_delete=models.CASCADE, related_name='pets')
    petphoto = models.ImageField(upload_to='pet_photos/', blank=True, null=True)

    def __str__(self):
        return self.name
