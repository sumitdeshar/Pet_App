from django.views.decorators.csrf import csrf_exempt
from django.shortcuts import get_object_or_404
from rest_framework.decorators import api_view, permission_classes, authentication_classes
from rest_framework.response import Response
from rest_framework.parsers import JSONParser
from rest_framework import status
from rest_framework.permissions import IsAuthenticated
from rest_framework_simplejwt.authentication import JWTAuthentication
from posts.models import *
from posts.serializers import *
from core.utlis import get_user_id_from_token



@api_view(['GET'])
def display_posts(request):
    # if request.method == 'GET':
    #     posts = Post.objects.all()
    #     serializer = PostSerializer(posts, many=True)
    #     return Response(serializer.data)
    post = get_object_or_404(Post)
    serializer = ViewPostSerializer(post)
    print(serializer.data)
    return Response(serializer.data)

@api_view(['GET', 'POST'])
def post_create(request):

    auth_header = request.headers.get('Authorization')
    user_id = get_user_id_from_token(auth_header)
    # user_id = 1
    if user_id is None:
        return Response({'error': 'Invalid or expired token'}, status=status.HTTP_401_UNAUTHORIZED)
    
    if request.method == 'POST':
        serializer = CreatePostSerializer(data=request.data)
        if serializer.is_valid():
            serializer.save(author=user_id)
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

# @api_view(['GET', 'PUT'])
# @permission_classes([IsAuthenticated])
# def post_edit(request, pk):
#     post = get_object_or_404(Post, pk=pk)

#     if request.method == 'GET':
#         serializer = PostSerializer(post)
#         return Response(serializer.data)

#     elif request.method == 'PUT':
#         # Ensure that the user updating the post is the original author
#         if request.user != post.author:
#             return Response({'status': 'error', 'message': 'You do not have permission to edit this post'},
#                             status=status.HTTP_403_FORBIDDEN)

#         serializer = PostSerializer(post, data=request.data)
#         if serializer.is_valid():
#             serializer.save()
#             return Response(serializer.data, status=status.HTTP_200_OK)
#         return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

@api_view(['GET'])
def post_list(request, pk):
    post = get_object_or_404(Post, pk=pk)
    serializer = ViewPostSerializer(post)
    return Response(serializer.data)

@api_view(['GET', 'POST'])
def comment_create(request, post_pk):
    post = get_object_or_404(Post, pk=post_pk)

    if request.method == 'GET':
        comments = Comment.objects.filter(post=post)
        serializer = CommentSerializer(comments, many=True)
        return Response(serializer.data)

    elif request.method == 'POST':
        serializer = CommentSerializer(data=request.data)
        if serializer.is_valid():
            serializer.save(author=request.user, post=post)
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

@api_view(['POST'])
@permission_classes([IsAuthenticated])
def upvote_create(request, post_pk):
    post = get_object_or_404(Post, pk=post_pk)
    upvote, created = Upvote.objects.get_or_create(user=request.user, post=post)
    if created:
        return Response({'status': 'success', 'message': 'Upvoted successfully'}, status=status.HTTP_201_CREATED)
    return Response({'status': 'error', 'message': 'Already upvoted'}, status=status.HTTP_400_BAD_REQUEST)

@api_view(['POST'])
@permission_classes([IsAuthenticated])
def comment_upvote_create(request, comment_pk):
    comment = get_object_or_404(Comment, pk=comment_pk)
    upvote, created = Upvote.objects.get_or_create(user=request.user, comment=comment)
    if created:
        return Response({'status': 'success', 'message': 'Upvoted successfully'}, status=status.HTTP_201_CREATED)
    return Response({'status': 'error', 'message': 'Already upvoted'}, status=status.HTTP_400_BAD_REQUEST)