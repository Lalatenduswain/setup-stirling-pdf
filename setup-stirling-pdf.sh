#!/bin/bash

# setup-stirling-pdf.sh
# Author: Lalatendu Swain
# Purpose: Automate the setup and deployment of Stirling-PDF using Docker Compose

# Exit on error
set -e

# Define variables
REPO_DIR="$PWD"
STIRLING_DIR="$REPO_DIR/StirlingPDF"
ENV_FILE="$REPO_DIR/stirling-pdf.env"
COMPOSE_FILE="$REPO_DIR/docker-compose.yml"
NGINX_CONF="$REPO_DIR/nginx.conf"
CERTS_DIR="$REPO_DIR/certs"

# Check for prerequisites
echo "📋 Checking prerequisites..."
if ! command -v docker &> /dev/null; then
    echo "❌ Docker is not installed. Please install Docker first."
    exit 1
fi

if ! command -v docker-compose &> /dev/null; then
    echo "❌ Docker Compose is not installed. Please install Docker Compose first."
    exit 1
fi

if ! command -v openssl &> /dev/null; then
    echo "⚠️ OpenSSL is not installed. It is required for generating self-signed certificates."
    echo "You can install it with: sudo apt-get install openssl (Ubuntu/Debian) or equivalent."
fi

# Create necessary directories
echo "📁 Creating directories for Stirling-PDF..."
mkdir -p "$STIRLING_DIR"/{trainingData,extraConfigs,customFiles,logs,pipeline}
mkdir -p "$CERTS_DIR"

# Set permissions for Stirling-PDF directories
echo "🔒 Setting permissions for Stirling-PDF directories..."
sudo chown -R 1000:1000 "$STIRLING_DIR"
sudo chmod -R 755 "$STIRLING_DIR"

# Create environment file
echo "📝 Creating environment file ($ENV_FILE)..."
cat > "$ENV_FILE" << EOL
TZ=Asia/Kolkata
DISABLE_ADDITIONAL_FEATURES=false
LANGS=en_GB
DOCKER_ENABLE_SECURITY=true
SECURITY_ENABLE_LOGIN=true
UI_APP_NAME=Stirling-PDF-Custom
SYSTEM_DEFAULTLOCALE=en_GB
EOL

# Create basic Nginx configuration (if not exists)
if [ ! -f "$NGINX_CONF" ]; then
    echo "🌐 Creating default Nginx configuration ($NGINX_CONF)..."
    cat > "$NGINX_CONF" << EOL
events {}
http {
    server {
        listen 80;
        listen [::]:80;
        server_name localhost;

        # Redirect HTTP to HTTPS
        return 301 https://\$host\$request_uri;
    }

    server {
        listen 443 ssl;
        listen [::]:443 ssl;
        server_name localhost;

        ssl_certificate /etc/nginx/certs/fullchain.pem;
        ssl_certificate_key /etc/nginx/certs/privkey.pem;

        location / {
            proxy_pass http://stirling-pdf:8080;
            proxy_set_header Host \$host;
            proxy_set_header X-Real-IP \$remote_addr;
            proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
            proxy_set_header X-Forwarded-Proto \$scheme;
        }
    }
}
EOL
fi

# Generate self-signed certificates for testing (if not exists)
if [ ! -f "$CERTS_DIR/fullchain.pem" ] || [ ! -f "$CERTS_DIR/privkey.pem" ]; then
    echo "🔑 Generating self-signed SSL certificates for testing..."
    openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
        -keyout "$CERTS_DIR/privkey.pem" \
        -out "$CERTS_DIR/fullchain.pem" \
        -subj "/CN=localhost"
fi

# Start Docker Compose services
echo "🚀 Starting Stirling-PDF services with Docker Compose..."
docker-compose -f "$COMPOSE_FILE" up -d

echo "✅ Setup complete! Stirling-PDF is running."
echo "🌐 Access it at http://localhost:8080 (or https://localhost if using Nginx)."
echo "📢 Note: For production, replace self-signed certificates with valid ones."
