
#!/bin/bash
yum update -y
# Install Docker
amazon-linux-extras install docker -y
service docker start
usermod -a -G docker ec2-user
# Create simple Docker app
cat > /home/ec2-user/app.py <<'PY'
from http.server import BaseHTTPRequestHandler, HTTPServer
class Handler(BaseHTTPRequestHandler):
    def do_GET(self):
        self.send_response(200)
        self.send_header('Content-type','text/plain')
        self.end_headers()
        if '/ec2-docker1' in self.path or '/ec2-docker2' in self.path:
            self.wfile.write(b'Namaste from Container')
        else:
            self.wfile.write(b'Hello from Instance')
if __name__ == '__main__':
    server = HTTPServer(('0.0.0.0', 8080), Handler)
    server.serve_forever()
PY
# Build docker image
cd /home/ec2-user
cat > Dockerfile <<'DOCKER'
FROM python:3.11-alpine
COPY app.py /app.py
CMD ["python", "/app.py"]
DOCKER
docker build -t namaste-app .
# Run container
docker run -d --name namaste -p 8080:8080 namaste-app
# Install NGINX
yum install -y nginx
cat > /etc/nginx/conf.d/interview.conf <<'NG'
server {
    listen 80;
    server_name _;

    location /ec2-instance1 {
        return 200 'Hello from Instance';
    }
    location /ec2-instance2 {
        return 200 'Hello from Instance';
    }
    location /ec2-docker1 {
        proxy_pass http://127.0.0.1:8080/ec2-docker1;
        proxy_set_header Host $host;
    }
    location /ec2-docker2 {
        proxy_pass http://127.0.0.1:8080/ec2-docker2;
        proxy_set_header Host $host;
    }
}
NG
systemctl enable nginx
systemctl start nginx
