from django.shortcuts import render, redirect, HttpResponse
from .models import *
from django.contrib.auth.models import User, auth
from django.contrib import messages
from rest_framework import status
from rest_framework.response import Response
from django.views.decorators.csrf import csrf_exempt
from rest_framework.decorators import api_view
from .serializers import *
from django.http import JsonResponse
from rest_framework import generics

# Create your views here.
def index(request):
    return render(request, 'index.html')

class get_pet_owner_profile(generics.ListCreateAPIView):
    queryset = PetOwnerProfile.objects.all()
    serializer_class = PetOwnerProfileSerializer

# @api_view(['GET'])
# def get_pet_owner_profile(request):
#         if request.method == 'GET':
#             data = PetOwnerProfile.objects.get()
#             serializer = PetOwnerProfileSerializer(data)
#             return Response(serializer.data)

# @api_view(["GET", "POST"])
def register(request):
    if request.method == 'POST':
        serializer = UserRegistrationSerializer(data=request.POST)
        if serializer.is_valid():
            username = serializer.validated_data.get("username")
            email = serializer.validated_data.get("email")
            password = serializer.validated_data.get("password")
            password2 = serializer.validated_data.get("password2")

            if password==password2:
                if User.objects.filter(email=email).exists():
                    messages.info(request, "Email Already Used")
                    return redirect('core:register')
                elif User.objects.filter(username=username).exists():
                    messages.info(request, "Username Already Used")
                    return redirect('core:register')
                else:
                    user = User.objects.create_user(username=username, email=email, password=password)
                    user.save()
                    return redirect('core:login')
            else:
                messages.info(request, "Password did not match")
                return redirect('core:register')
        else:
            # Handle serializer validation errors
            error_messages = serializer.errors
            return render(request, 'register.html', {'error_messages': error_messages})

    return render(request, 'register.html')

@api_view(["GET", "POST"])
def login(request):

    if request.method == 'POST':
        # Create a serializer from the form data
        jsondata = request.data
        serializer = LoginSerializer(data=jsondata)
        
        if serializer.is_valid():
            username = serializer.validated_data['username']
            password = serializer.validated_data['password']
            
            user = auth.authenticate(username=username, password=password)
            
            if user is not None:
                auth.login(request, user)
                print(request.user.id)
                owner = PetOwnerProfile.objects.get(id=request.user.id)
                print(owner.address)
                return redirect('/home')
            else:
                messages.info(request, "Credentials Invalid")
                return redirect('/')
        else:
            return redirect('/')
    if request.method == 'GET':
        return render(request, 'login.html')
    
def logout(request):
    auth.logout(request)
    return redirect('/')

def owner_profile(request, owner_id):
    print(owner_id)
    print(PetOwnerProfile)
    pet_owner = PetOwnerProfile.objects.get(id=owner_id)

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


def checkuser(request):
    if request.method == "GET":
        
        stu_obj = User.objects.all()
        stu_seri = UserSerializer(stu_obj, many=True)
        return render(stu_seri.data)
