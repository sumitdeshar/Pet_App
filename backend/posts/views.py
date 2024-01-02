from django.views.decorators.csrf import csrf_exempt
from django.shortcuts import get_object_or_404
from rest_framework.decorators import api_view, permission_classes, authentication_classes
from rest_framework.response import Response
from rest_framework.parsers import JSONParser
from rest_framework import status
from rest_framework.permissions import IsAuthenticated
from rest_framework_simplejwt.authentication import JWTAuthentication
from .models import *
from .serializers import *
from core.utlis import get_user_id_from_token



@api_view(['GET'])
def display_posts(request):
    pass
    # return Response(data={'data': serializer.data}, status=status.HTTP_200_OK)

def create_posts(request):
    pass