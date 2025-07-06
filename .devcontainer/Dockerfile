FROM python:3.13-slim

# Install system dependencies and create vscode user
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    openjdk-17-jre-headless \
    libpq-dev \
    gcc \
    curl && \
    groupadd -g 1000 vscode && \
    useradd -u 1000 -g vscode -m -s /bin/bash vscode && \
    rm -rf /var/lib/apt/lists/*

# Set environment variables
ENV JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64 \
    PYSPARK_PYTHON=/usr/local/bin/python \
    PYSPARK_DRIVER_PYTHON=/usr/local/bin/python \
    PATH="/home/vscode/.local/bin:${PATH}"

# Copy requirements first for better caching
COPY requirements.txt /tmp/requirements.txt

# Install Python dependencies
RUN pip install --no-cache-dir --user -r /tmp/requirements.txt && \
    rm /tmp/requirements.txt

# Set working directory and user
WORKDIR /workspace
RUN chown -R vscode:vscode /workspace
USER vscode