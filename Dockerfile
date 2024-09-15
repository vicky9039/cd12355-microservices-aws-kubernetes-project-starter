# Use official Python slim image
FROM python:3.9-slim

# Set working directory
WORKDIR /app

# Update local package index and install required packages
RUN apt update && apt install -y build-essential libpq-dev

# Copy requirements file
COPY requirements.txt .

# Install Python dependencies
RUN pip install --upgrade pip setuptools wheel && pip install -r requirements.txt

# Set environment variables
ENV DB_USERNAME=myuser
ENV DB_PASSWORD=mypassword
ENV DB_HOST=127.0.0.1
ENV DB_PORT=5433
ENV DB_NAME=mydatabase

# Copy application code
COPY . .

# Command to run the application
CMD ["python", "app.py"]
