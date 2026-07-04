# Use an official Python image from the Docker Hub
FROM python:3.12-slim

# Set the working directory in the container
WORKDIR /app

# Copy the requirements file into the container
COPY requirements.txt requirments.txt

# Install the dependencies specified in the requirements file
# --no-cache-dir - Prevents pip from caching the packages, reducing the size of the image
RUN pip install --no-cache-dir -r requirments.txt

# Copy the rest of the application code into the container
COPY . .

# Set environment variables for Flask
ENV FLASK_APP=app.py
ENV FLASK_RUN_HOST=0.0.0.0

# Expose the port that the Flask app will run on
EXPOSE 5000

# Start the Flask application
CMD ["flask","run"]