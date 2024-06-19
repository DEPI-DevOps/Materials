# app_python

## Initialization

```bash
python -m venv venv
source venv/bin/activate
pip install flask
pip install gunicorn
```

## Development

```bash
python -m venv venv
source venv/bin/activate
pip install -r requirements.txt
```

## Jenkins server initialization

```bash
# Installing jenkins and dependencies
sudo apt-get update && sudo apt-get install -y fontconfig openjdk-17-jre
sudo wget -O /usr/share/keyrings/jenkins-keyring.asc   https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key
echo "deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc]"   https://pkg.jenkins.io/debian-stable binary/ | sudo tee   /etc/apt/sources.list.d/jenkins.list > /dev/null
sudo apt-get update && sudo apt-get install -y jenkins

# Verify installation
sudo systemctl status jenkins

# Get admin password
sudo cat /var/lib/jenkins/secrets/initialAdminPassword
   
# Install Python dependencies
sudo apt-get update && sudo apt-get install python3 python3-pip python3-venv
```
