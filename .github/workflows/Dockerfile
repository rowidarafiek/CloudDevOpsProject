FROM python:3.10

WORKDIR /app

COPY . .

RUN pip install flask

# Variables inside the image
ENV APP_MODE=production
ENV APP_REGION=canada-west

EXPOSE 8080

CMD ["python", "app.py"]