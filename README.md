# Stirling-PDF Docker Deployment 🚀

Welcome to the **Stirling-PDF Docker Deployment** repository! This project provides a Docker Compose setup and an automated bash script to deploy [Stirling-PDF](https://github.com/Frooodle/Stirling-PDF), a powerful, open-source PDF manipulation tool. With this setup, you can easily run Stirling-PDF in a containerized environment with HTTPS support, persistent storage, and secure configurations.

**Author**: Lalatendu Swain | [GitHub](https://github.com/Lalatenduswain) | [Website](https://blog.lalatendu.info/)

---

## 📌 Features

- 🐳 **Dockerized Deployment**: Run Stirling-PDF using Docker Compose for easy setup and management.
- 🔒 **Secure Configuration**: Supports authentication and HTTPS via an Nginx reverse proxy.
- 📁 **Persistent Storage**: Maintains OCR data, logs, custom files, and pipeline jobs across container restarts.
- 🌐 **Customizable UI**: Configurable application name and locale for a personalized experience.
- 🛠️ **Automated Setup**: Includes a bash script (`setup-stirling-pdf.sh`) to automate directory creation, permissions, and service startup.
- ⏰ **Health Checks**: Built-in health checks ensure the application is running correctly.
- 📜 **Structured Logging**: JSON-based logging with rotation for easy monitoring.
- ⚙️ **Resource Management**: Configurable CPU and memory limits for efficient resource usage.
- 🌍 **Timezone Support**: Configured for `Asia/Kolkata` (customizable via environment file).

---

## 📖 Installation Guide

Follow these steps to set up and run Stirling-PDF using this repository.

### Prerequisites

- **Docker**: Container runtime for running Stirling-PDF.
- **Docker Compose**: Tool for managing multi-container setups.
- **Git**: To clone the repository.
- **OpenSSL** (optional): For generating self-signed SSL certificates (for testing).
- **sudo**: Required for setting directory permissions (if not running as root).

#### Install Prerequisites (Ubuntu/Debian)
```bash
sudo apt-get update
sudo apt-get install -y docker.io docker-compose git openssl
sudo systemctl start docker
sudo systemctl enable docker
```

#### Verify Installation
```bash
docker --version
docker-compose --version
git --version
openssl version
```

### Step-by-Step Installation

1. **Clone the Repository**
   ```bash
   git clone https://github.com/Lalatenduswain/setup-stirling-pdf.git
   cd setup-stirling-pdf
   ```

2. **Make the Script Executable**
   ```bash
   chmod +x setup-stirling-pdf.sh
   ```

3. **Run the Setup Script**
   ```bash
   ./setup-stirling-pdf.sh
   ```
   The script will:
   - Check for prerequisites (Docker, Docker Compose, OpenSSL).
   - Create necessary directories (`StirlingPDF/trainingData`, `extraConfigs`, etc.).
   - Set permissions for directories.
   - Create an environment file (`stirling-pdf.env`) with default configurations.
   - Generate a default Nginx configuration (`nginx.conf`) for HTTPS.
   - Create self-signed SSL certificates for testing (in `certs/`).
   - Start the Docker Compose services.

4. **Access Stirling-PDF**
   - Open your browser and navigate to:
     - `http://localhost:8080` (direct access to Stirling-PDF).
     - `https://localhost` (if using Nginx for HTTPS).
   - **Note**: For production, replace self-signed certificates with valid ones (e.g., from Let's Encrypt).

5. **Customize Configuration** (Optional)
   - Edit `stirling-pdf.env` to adjust settings (e.g., `TZ`, `LANGS`, `UI_APP_NAME`).
   - Modify `nginx.conf` for advanced proxy settings.
   - Add valid SSL certificates to the `certs/` directory for production.

6. **Manage Services**
   - Stop services:
     ```bash
     docker-compose down
     ```
   - View logs:
     ```bash
     docker-compose logs
     ```
   - Restart services:
     ```bash
     docker-compose up -d
     ```

### Directory Structure
After running the script, your repository will have the following structure:
```
setup-stirling-pdf/
├── docker-compose.yml        # Docker Compose configuration
├── stirling-pdf.env         # Environment variables for Stirling-PDF
├── setup-stirling-pdf.sh    # Setup script
├── nginx.conf               # Nginx configuration for HTTPS
├── certs/                   # SSL certificates (self-signed or custom)
│   ├── fullchain.pem
│   └── privkey.pem
├── StirlingPDF/             # Persistent storage directories
│   ├── trainingData/
│   ├── extraConfigs/
│   ├── customFiles/
│   ├── logs/
│   └── pipeline/
```

---

## 📜 Disclaimer | Running the Script

**Author**: Lalatendu Swain | [GitHub](https://github.com/Lalatenduswain) | [Website](https://blog.lalatendu.info/)

This script and Docker Compose configuration are provided as-is and may require modifications based on your specific environment and requirements. Use them at your own risk. The author is not liable for any damages or issues caused by their usage.

### Running the Script
- Ensure you have the prerequisites installed.
- Run the script as a user with `sudo` privileges for setting directory permissions:
  ```bash
  sudo ./setup-stirling-pdf.sh
  ```
- For production, secure the environment by:
  - Using valid SSL certificates instead of self-signed ones.
  - Removing or securing any sensitive data in `stirling-pdf.env`.
  - Regularly backing up the `StirlingPDF/` directory.

---

## 💖 Support & Donations

### Support
Encountering issues? Don't hesitate to submit an issue on our [GitHub Issues page](https://github.com/Lalatenduswain/setup-stirling-pdf/issues).

### Donations
If you find this project useful and want to show your appreciation, consider supporting me via [Buy Me a Coffee](https://www.buymeacoffee.com/lalatendu.swain).

---

## 🛠️ Contributing

Contributions are welcome! To contribute:
1. Fork the repository.
2. Create a new branch (`git checkout -b feature/your-feature`).
3. Make your changes and commit (`git commit -m "Add your feature"`).
4. Push to your branch (`git push origin feature/your-feature`).
5. Open a pull request.

Please ensure your changes are well-documented and tested.

---

## 📄 License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

---

**Happy PDF processing with Stirling-PDF!** 📚
