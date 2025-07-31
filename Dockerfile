# Use Python slim image as base
FROM python:3.11-slim

# Set working directory
WORKDIR /docs

# Install system dependencies
RUN apt-get update && apt-get install -y \
    git \
    && rm -rf /var/lib/apt/lists/*

# Copy requirements and install dependencies
COPY requirements.txt /tmp/requirements.txt
RUN pip install --no-cache-dir -r /tmp/requirements.txt

# Copy documentation files
COPY . /docs

# Expose port 8000 for development server
EXPOSE 8000

# Default command to serve docs
CMD ["mkdocs", "serve", "--dev-addr=0.0.0.0:8000"]