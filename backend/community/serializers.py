# community/serializers.py
from rest_framework import serializers
from community.models import *

class CommunityProfileSerializer(serializers.ModelSerializer):
    class Meta:
        model = CommunityProfile
        fields = '__all__'
        
class CommunityApplicationSerializer(serializers.ModelSerializer):
    class Meta:
        model = CommunityApplication
        fields = '__all__'
        
class CommunityMembershipSerializer(serializers.ModelSerializer):
    class Meta:
        model = CommunityMembership
        fields = ['user', 'community', 'is_admin']
        