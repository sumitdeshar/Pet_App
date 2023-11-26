from django.contrib import admin
from .models import PetOwnerProfile,Pet

# Register your models here.
admin.site.register(PetOwnerProfile)
admin.site.register(Pet)
