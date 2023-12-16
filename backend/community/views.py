from django.views.decorators.csrf import csrf_exempt
from django.shortcuts import get_object_or_404
from rest_framework.decorators import api_view, permission_classes
from rest_framework.response import Response
from rest_framework.parsers import JSONParser
from rest_framework import status
from rest_framework.permissions import IsAuthenticated
from .models import *
from .serializers import *

@api_view(['GET'])
def community_profile_list(request):
    communities = CommunityProfile.objects.all()
    serializer = CommunityProfileSerializer(communities, many=True)
    return Response(data={'data': serializer.data}, status=status.HTTP_200_OK)

@api_view(['GET'])
def community_profile_detail(request, pk):
    try:
        community = CommunityProfile.objects.get(pk=pk)
    except CommunityProfile.DoesNotExist:
        return Response(data={'error': 'Community not found'}, status=status.HTTP_404_NOT_FOUND)

    serializer = CommunityProfileSerializer(community)
    return Response(data={'data': serializer.data}, status=status.HTTP_200_OK)


@csrf_exempt
@api_view(['POST'])
def community_application(request):
    if request.method == 'POST':
       
        data = JSONParser().parse(request)
        serializer = CommunityApplicationSerializer(data=data)
        
        if serializer.is_valid():
            application = serializer.save(status='Pending')

            return Response(data={'data': serializer.data}, status=status.HTTP_201_CREATED)

        errors = serializer.errors
        return Response(data={'errors': errors}, status=status.HTTP_400_BAD_REQUEST)

    return Response(data={'message': 'Invalid request method'}, status=status.HTTP_400_BAD_REQUEST)

@csrf_exempt
@api_view(['GET', 'PATCH'])
def community_admin_view(request):
    if request.method == 'GET':
        # Retrieve pending forms
        pending_applications = CommunityApplication.objects.filter(status='Pending')
        serializer = CommunityApplicationSerializer(pending_applications, many=True)
        return Response(data={'status': 'success', 'data': serializer.data}, status=status.HTTP_200_OK)

    elif request.method == 'PATCH':
        # Parse JSON data from the request
        data = JSONParser().parse(request)

        try:
            # Retrieve the application
            application = CommunityApplication.objects.get(id=data.get('id'), status='Pending')
        except CommunityApplication.DoesNotExist:
            return Response(data={'status': 'error', 'message': 'Application not found or already processed'}, status=status.HTTP_404_NOT_FOUND)

        # Update the application status based on the action
        if data.get('action') == 'approve':
            application.status = 'Approved'
        elif data.get('action') == 'reject':
            application.status = 'Rejected'
        else:
            return Response(data={'status': 'error', 'message': 'Invalid action'}, status=status.HTTP_400_BAD_REQUEST)

        application.save()

        # Return the updated application data
        serializer = CommunityApplicationSerializer(application)
        return Response(data={'status': 'success', 'data': serializer.data}, status=status.HTTP_200_OK)

    return Response(data={'status': 'error', 'message': 'Invalid request method'}, status=status.HTTP_400_BAD_REQUEST)

# @csrf_exempt
# def make_community_admin(request, community_id, user_id):
#     if request.method == 'PATCH':
#         print(1)
#         try:
#             # Ensure the user making the request is an admin of the community
#             community_membership = CommunityMembership.objects.get(
#                 user=request.user,
#                 community_id=community_id,
#                 is_admin=True
#             )
#         except CommunityMembership.DoesNotExist:
#             return Response(data={'status': 'error', 'message': 'You do not have permission to make someone an admin'}, status=status.HTTP_403_FORBIDDEN)

#         try:
#             # Find the membership for the user to be made an admin
#             target_user_membership = CommunityMembership.objects.get(user_id=user_id, community_id=community_id)
#             target_user_membership.is_admin = True
#             target_user_membership.save()
#             print(target_user_membership)
#             serializer = CommunityMembershipSerializer(target_user_membership)
#             return Response(data={'data': serializer.data}, status=status.HTTP_200_OK)

#         except CommunityMembership.DoesNotExist:
#             return Response(data={'message': 'User not found in the community'}, status=status.HTTP_404_NOT_FOUND)

#     return Response(data={'message': 'Invalid request method'}, status=status.HTTP_400_BAD_REQUEST)

@csrf_exempt
def make_community_admin(request, community_id, user_id):
    try:
        target_user_membership = CommunityMembership.objects.get(user_id=user_id, community_id=community_id)
        print(target_user_membership)
        return Response(data={'data': target_user_membership}, status=status.HTTP_200_OK)
    except:
        return Response(data={'message': 'User not found in the community'}, status=status.HTTP_404_NOT_FOUND)
    
    
    
# def post(request):
#     if request.method == 'GET':
#         queryset = Post.objects.all()
#         serializer = PostSerializer(queryset)
#         return Response(data={'data': serializer.data}, status=status.HTTP_200_OK)
#     if request.method == 'POST':
#         data = JSONParser().parse(request)
#         serializer = PostSerializer(data=data)
#         if serializer.is_valid():
#             serializer.save()
#             return Response({
#                 'message': 'Post has been created',
#                 'data': serializer.data
#             },status=status.HTTP_200_OK)
#         else:
#             return Response(data={'message': 'Post has not been created try again'}, status=status.HTTP_404_NOT_FOUND)
#     if request.method == 'PATCH':
#         pass
    

@api_view(['GET', 'POST'])
def post_create(request):
    if request.method == 'GET':
        posts = Post.objects.all()
        serializer = PostSerializer(posts, many=True)
        return Response(serializer.data)

    elif request.method == 'POST':
        serializer = PostSerializer(data=request.data)
        if serializer.is_valid():
            serializer.save(author=request.user)
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

@api_view(['GET', 'PUT'])
@permission_classes([IsAuthenticated])
def post_edit(request, pk):
    post = get_object_or_404(Post, pk=pk)

    if request.method == 'GET':
        serializer = PostSerializer(post)
        return Response(serializer.data)

    elif request.method == 'PUT':
        # Ensure that the user updating the post is the original author
        if request.user != post.author:
            return Response({'status': 'error', 'message': 'You do not have permission to edit this post'},
                            status=status.HTTP_403_FORBIDDEN)

        serializer = PostSerializer(post, data=request.data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status=status.HTTP_200_OK)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

@api_view(['GET'])
def post_list(request, pk):
    post = get_object_or_404(Post, pk=pk)
    serializer = PostSerializer(post)
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



