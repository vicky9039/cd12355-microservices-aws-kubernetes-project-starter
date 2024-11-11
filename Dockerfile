FROM public.ecr.aws/docker/library/python:3.10-slim-buster

# Set the working directory in the container

WORKDIR /src

COPY ./analytics/requirements.txt requirements.txt

COPY . .

# Install dependencies

# Update the local package index with the latest packages from the repositories

RUN apt-get update -y && \

apt-get install -y build-essential libpq-dev && \

apt-get clean

# Copy the current directory contents into the container at /app

COPY ./analytics/app.py app.py

COPY ./analytics/config.py config.py

# Upgrade pip, setuptools, and wheel

RUN pip install --upgrade pip setuptools wheel

# Install any needed packages specified in requirements.txt

RUN pip install -r requirements.txt

# Expose port 5153 for the app

EXPOSE 5153

# Run app.py when the container launches

CMD ["python3", "app.py"]
