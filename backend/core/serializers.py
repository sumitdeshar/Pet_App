from rest_framework import serializers
from django.contrib.auth.models import User
from .models import *

class UserRegistrationSerializer(serializers.Serializer):
    username = serializers.CharField()
    email = serializers.EmailField()
    password = serializers.CharField()
    password2 = serializers.CharField()

class LoginSerializer(serializers.Serializer):
    username = serializers.CharField()
    password = serializers.CharField()
    
    
class UserSerializer(serializers.Serializer):
    username = serializers.CharField()
    password = serializers.CharField()

class PetOwnerProfileSerializer(serializers.ModelSerializer):
    class Meta:
        model = PetOwnerProfile
        fields = ['user', 'phone_number', 'address', 'pet_info']