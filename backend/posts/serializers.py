from rest_framework import serializers
from posts.models import *

class CommunityIDSerializer(serializers.ModelSerializer):
    class Meta:
        model = CommunityProfile
        fields = ('id') 

class CreatePostSerializer(serializers.ModelSerializer):
    community = CommunityIDSerializer()
    class Meta:
        model = Post
        fields = ['community', 'content', 'photo']
        
class UserProfileSerializer(serializers.ModelSerializer):
    class Meta:
        model = User
        fields = ('id', 'username' ) 

class ViewPostSerializer(serializers.ModelSerializer):
    community = CommunityIDSerializer()
    author  = UserProfileSerializer()

    class Meta:
        model = Post
        fields = ('community', 'id', 'author', 'created_at', 'content', 'photo')
        
class EditPostSerializer(serializers.ModelSerializer):
    class Meta:
        model = Post
        fields = ('community', 'id', 'content', 'photo')

        
class CommentSerializer(serializers.ModelSerializer):
    class Meta:
        model = Comment
        fields = '__all__'