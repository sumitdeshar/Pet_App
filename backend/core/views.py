from django.shortcuts import render, redirect
from django.contrib.auth.models import User, auth
from django.contrib import messages
from django.views.decorators.csrf import csrf_exempt
from django.http import JsonResponse
from rest_framework import status
from rest_framework import generics
from rest_framework.response import Response
from rest_framework.decorators import api_view, authentication_classes, permission_classes
from rest_framework.renderers import JSONRenderer
from rest_framework.authentication import SessionAuthentication, BasicAuthentication
from rest_framework.permissions import IsAuthenticated
from rest_framework_simplejwt.authentication import JWTAuthentication
from rest_framework_simplejwt.tokens import RefreshToken
from .models import *
from .serializers import *


# Create your views here.
def index(request):
    return render(request, 'index.html')


    
@api_view(['GET'])
def check_user(request, pk):
    try:
        user_profile = Profile.objects.get(user=pk)
        profile_serializer = PetOwnerProfileSerializer(user_profile)
        return Response(profile_serializer.data, status=status.HTTP_200_OK)
    except Profile.DoesNotExist:
        return Response(
            {"message": "User profile not found for user with ID: {}".format(pk)},
            status=status.HTTP_404_NOT_FOUND
        )

@csrf_exempt
@api_view(["POST"])
@authentication_classes([SessionAuthentication, BasicAuthentication])
def login(request):
    if request.method == 'POST':
        jsondata = request.data
        serializer = LoginSerializer(data=jsondata)

        if serializer.is_valid():
            username = serializer.validated_data['username']
            password = serializer.validated_data['password']
            
            user = auth.authenticate(username=username, password=password)
            
            if user is not None:
        
                refresh = RefreshToken.for_user(user)
                return JsonResponse({
                    'refresh': str(refresh),
                    'access': str(refresh.access_token),
                    'status': 200
                })
            else:
                return JsonResponse({'error': 'Credentials Invalid', 'status':status.HTTP_401_UNAUTHORIZED})
        else:
            return JsonResponse({'error': 'Invalid data', 'status':status.HTTP_400_BAD_REQUEST})


@api_view(['GET'])
@authentication_classes([JWTAuthentication])
@permission_classes([IsAuthenticated])
def get_pet_owner_profile(request):
    if request.method == 'GET':
        try:
            user_id = request.user.id
            user_profile = Profile.objects.get(user=user_id)
            profile_serializer = PetOwnerProfileSerializer(user_profile)
            print(profile_serializer.data)
            return Response(profile_serializer.data)
        except Profile.DoesNotExist:
            return Response({"message": "Authenticated user with ID: {}".format(user_id)}, status=status.HTTP_404_NOT_FOUND)
        
@csrf_exempt
@api_view(["POST"])
def register(request):
    if request.method == 'POST':
        
        jsondata = request.data
        serializer = UserRegistrationSerializer(data=jsondata)
        
        if serializer.is_valid():
            username = serializer.validated_data.get("username")
            email = serializer.validated_data.get("email")
            password = serializer.validated_data.get("password")
            password2 = serializer.validated_data.get("password2")
            
            if password == password2:
                if User.objects.filter(email=email).exists():
                    return JsonResponse({'error': 'Email Already Used'}, status=status.HTTP_400_BAD_REQUEST)
                elif User.objects.filter(username=username).exists():
                    return JsonResponse({'error': 'Username Already Used'}, status=status.HTTP_400_BAD_REQUEST)
                else:
                    user = User.objects.create_user(username=username, email=email, password=password)
                    user.save()
                    return JsonResponse({'message': 'Registration successful'}, status=status.HTTP_200_OK)
            else:
                return JsonResponse({'error': 'Password did not match'}, status=status.HTTP_400_BAD_REQUEST)
        else:
            return JsonResponse({'error_messages': serializer.errors}, status=status.HTTP_400_BAD_REQUEST)

    return JsonResponse({'error': 'Invalid request method'}, status=status.HTTP_400_BAD_REQUEST)


    
# def logout(request):
#     auth.logout(request)
#     return redirect('/')


