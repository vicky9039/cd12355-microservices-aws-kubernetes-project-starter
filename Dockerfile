# Use official Python slim image
FROM python:3.9-slim

# Set working directory
WORKDIR /app

# Update local package index and install required packages
RUN apt update && apt install -y build-essential libpq-dev

# Install Postgres and configure a username + password
USER root

ARG DB_USERNAME=$DB_USERNAME
ARG DB_PASSWORD=$DB_PASSWORD

RUN apt update -y && apt install postgresql postgresql-contrib -y

USER postgres
WORKDIR /db
COPY ./db .

RUN service postgresql start && \
psql -c "CREATE USER $DB_USERNAME PASSWORD $DB_PASSWORD " && \
psql < db/1_create_tables.sql && \
psql < db/2_seed_users.sql && \
psql < db/3_seed_tokens.sql && \
psql -c "GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO $DB_USERNAME;" && \
psql -c "GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO $DB_USERNAME"

# -- End database setup

# Copy requirements file
COPY /analytics/requirements.txt .

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
CMD service postgresql start && python app.py
