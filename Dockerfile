FROM haoli1/freediameter:latest

# Create directory for configuration files
RUN mkdir -p /conf

RUN openssl req -new -batch -x509 -days 3650 -nodes     \
    -newkey rsa:1024 -out /etc/freeDiameter/cert.pem -keyout /etc/freeDiameter/privkey.pem \
    -subj /CN=dra1.left.side
RUN openssl req -new -batch -x509 -days 3650 -nodes     \
    -newkey rsa:1024 -out /etc/freeDiameter/cert11.pem -keyout /etc/freeDiameter/privkey11.pem \
    -subj /CN=peer11.left.side
RUN openssl req -new -batch -x509 -days 3650 -nodes     \
    -newkey rsa:1024 -out /etc/freeDiameter/cert12.pem -keyout /etc/freeDiameter/privkey12.pem \
    -subj /CN=peer12.left.side
RUN openssl req -new -batch -x509 -days 3650 -nodes     \
    -newkey rsa:1024 -out /etc/freeDiameter/cert2.pem -keyout /etc/freeDiameter/privkey2.pem \
    -subj /CN=dra2.right.side
RUN openssl req -new -batch -x509 -days 3650 -nodes     \
    -newkey rsa:1024 -out /etc/freeDiameter/cert22.pem -keyout /etc/freeDiameter/privkey22.pem \
    -subj /CN=peer2.right.side    
RUN openssl dhparam -out /etc/freeDiameter/dh.pem 1024

# Copy all configuration files to the image
COPY conf/* /conf/

# Add entrypoint script
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Set entrypoint
ENTRYPOINT ["/entrypoint.sh"]
