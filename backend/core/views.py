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
from rest_framework_simplejwt.tokens import RefreshToken
from rest_framework_simplejwt.views import TokenObtainPairView
from .models import *
from .serializers import *


# Create your views here.
def index(request):
    return render(request, 'index.html')

class MyTokenObtainPairView(TokenObtainPairView):
    serializer_class = MyTokenObtainPairSerializer
    
def check_user(request, pk):
    try:
        queryset = User.objects.get(id=pk)
    except User.DoesNotExist:
        return Response({'error': 'User not found', 'status':'HTTP_404_NOT_FOUND'})

    serializer = UserSerializer(queryset)

    response = Response(serializer.data, status=status.HTTP_200_OK)
    response.accepted_renderer = JSONRenderer()
    response.accepted_media_type = 'application/json'
    response.renderer_context = {}
    return response


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
                    })
            else:
                return JsonResponse({'error': 'Credentials Invalid', 'status':401})
        else:
            return JsonResponse({'error': 'Invalid data', 'status':400})


# class get_pet_owner_profile(generics.ListCreateAPIView):
#     queryset = PetOwnerProfile.objects.all()
#     print('18')
#     serializer_class = PetOwnerProfileSerializer

@api_view(['GET'])
def get_pet_owner_profile(request):
        if request.method == 'GET':
            data = Profile.objects.get(user=1)
            serializer = ProfileSerializer(data)
            print('18')
            return Response(serializer.data)

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
                    return JsonResponse({'error': 'Email Already Used'}, status=400)
                elif User.objects.filter(username=username).exists():
                    return JsonResponse({'error': 'Username Already Used'}, status=400)
                else:
                    user = User.objects.create_user(username=username, email=email, password=password)
                    user.save()
                    return JsonResponse({'message': 'Registration successful'}, status=200)
            else:
                return JsonResponse({'error': 'Password did not match'}, status=400)
        else:
            # Handle serializer validation errors
            return JsonResponse({'error_messages': serializer.errors}, status=400)

    return JsonResponse({'error': 'Invalid request method'}, status=400)


    
def logout(request):
    auth.logout(request)
    return redirect('/')

def owner_profile(request, owner_id):
    print(owner_id)
    print(Profile)
    pet_owner = Profile.objects.get(id=owner_id)

    return render(request, 'owner_profile.html', {'pet_owner': pet_owner})

# def ownerprofile(request):
#     if request.method == 'GET':
#         owner = PetOwnerProfile.objects.get(owner=request.user)
#         return render(request, 'ownerprofile.html')
    
#     if request.method == 'POST':
#         pass

def pet_profile(request, pet_id):
    # Retrieve the Pet object
    pet = Pet.objects.get(pk=pet_id)

    # Render the HTML template with the pet object
    return render(request, 'pet_profile.html', {'pet': pet})
# def petprofile(request):
#     if request.method == 'GET':
#         pet = Pet.objects.get(owner=request.user)
#         return render(request, 'ownerprofile.html')
    
#     if request.method == 'POST':
#         pass

@api_view(["GET", "POST"])
def checkuser(request):
    if request.method == "GET":
        jsondata = User.objects.get(id=request.id)
        return jsondata


