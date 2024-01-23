import jwt
import os
import random

# utils.py
def get_user_id_from_token(auth_header):
    try:
        _, token = auth_header.split()
        secret_key = os.environ.get('SECRET_KEY')
        decoded_token = jwt.decode(token, key=secret_key, algorithms=['HS256'])
        user_id = decoded_token['user_id']
        return user_id
    except jwt.ExpiredSignatureError:
        return None
    except jwt.InvalidTokenError:
        return None
    
def random_id():
    return random.randint(1, 2147483647)


