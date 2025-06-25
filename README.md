## Simple Django Weather API

This is a simple Django-based REST API that fetches current weather data for a given city using an external weather API (such as OpenWeatherMap).  
The project is containerized with Docker and configurable via `.env` file.

---

### Features

- `GET /api/weather/?city=London&lang=en` – Get current weather for a city.
- `POST /api/weather/` – Submit a city and language in the body to get weather (e.g. via Postman or frontend).
- Language support: `en`, `ru`
- API key and config loaded from `.env`
- Ready for containerized deployment with Gunicorn

---

### Project Structure

```
.
├── api/                  # Django app (views, urls)
├── config/               # Project configuration (settings, wsgi)
├── Dockerfile            # Docker build instructions
├── docker-compose.yml    # Compose definition
├── .env                  # Environment variables (excluded from Git)
├── manage.py             # Django CLI
└── requirements.txt      # Python dependencies
```

---

### Environment Variables (`.env`)

Example `.env` file:

```env
DEBUG=False
SECRET_KEY=your-django-secret-key
WEATHER_API_KEY=your-openweathermap-api-key
DJANGO_ALLOWED_HOSTS=127.0.0.1,localhost
BASE_URL=url-of-openweathermap-api
```

> Do **not** commit `.env` to version control.

---

### Running the App with Docker

#### 1. Build the image

```bash
docker compose build
```

#### 2. Start the container

```bash
docker compose up -d
```

API will be available at:  
`http://localhost:8000/api/weather/`

---

### API Usage

#### GET request

```
GET /api/weather/?city=Berlin&lang=en
```

Query parameters:

| Parameter | Required | Description             |
|-----------|----------|-------------------------|
| `city`    | Yes      | City name               |
| `lang`    | No       | Language: `en` or `ru`  |

---

#### POST request

```
POST /api/weather/
Content-Type: application/json
```

Request body example:

```json
{
  "city": "Paris",
  "lang": "en"
}
```

Same logic as the GET endpoint. You can use this with Postman, curl, or frontend forms.

---

### Tech Stack

- Python 3.13 (slim image)
- Django 5.2
- Gunicorn WSGI server
- Docker & Docker Compose
- External Weather API

---

### Security & Best Practices

- Secrets and API keys stored in `.env` file
- Docker container runs as unprivileged user (`djangouser`)
- `DEBUG=False` in production
- `.env` is excluded via `.gitignore`

---

### Example Request (curl)

```bash
curl "http://localhost:8000/api/weather/?city=Rome&lang=ru"
```

Or for POST:
```bash
curl -X POST http://localhost:8000/api/weather/ \
  -H "Content-Type: application/json" \
  -d '{"city": "Rome", "lang": "ru"}'
```

