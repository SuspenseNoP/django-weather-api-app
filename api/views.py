from rest_framework.decorators import api_view
from rest_framework.response import Response
from django.conf import settings
import requests


@api_view(['Get', 'POST'])
def weather_api(request):

    api_key = settings.WEATHER_API_KEY
    base_url = settings.BASE_URL

    if request.method == 'GET':
        # GET-параметры передаются в URL: /api/weather/?city=City&lang=lang
        city = request.query_params.get('city')
        lang = request.query_params.get('lang', 'en')
    else:
        city = request.data.get('city')
        lang = request.data.get('land', 'en') 

    if not city:
        return Response({'error': 'City name is required'}, status=400)
    
    params = {
        'q' : city,
        'appid' : api_key,
        'units' : 'metric',
        'lang' : lang
    }

    response = requests.get(base_url, params=params)
    data = response.json()

    if response.status_code != 200:
        return Response({'error': data.get('message', 'Request error')}, status=400)
    
    weather_data = {
        'city': data['name'],
        'temperature': data['main']['temp'],
        'description': data['weather'][0]['description'],
        'humidity': data['main']['humidity'],
        'pressure': data['main']['pressure'],
    }

    return Response(weather_data)