# community/serializers.py
from rest_framework import serializers
from .models import *

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
        
class PostSerializer(serializers.ModelSerializer):
    class Meta:
        model = Post
        fields = ['id', 'content', 'author', 'community', 'photo', 'created_at', 'updated_at']

class CommentSerializer(serializers.ModelSerializer):
    class Meta:
        model = Comment
        fields = ['id', 'post', 'content', 'author', 'created_at', 'updated_at']

class UpvoteSerializer(serializers.ModelSerializer):
    class Meta:
        model = Upvote
        fields = ['id', 'user', 'post', 'comment', 'created_at']