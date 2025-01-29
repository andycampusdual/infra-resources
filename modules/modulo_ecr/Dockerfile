# Use an official image from Docker Hub as the base image
FROM python:3.8-slim
 
# Set the working directory in the container
WORKDIR /app
 
# Copy your application code to the container
COPY . /app
 
EXPOSE 5000
 
# Set the default command to run your app
CMD ["python", "app.py"]