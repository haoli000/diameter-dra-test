FROM haoli1/freediameter:latest

# Create directory for configuration files
RUN mkdir -p /conf

RUN openssl req -new -batch -x509 -days 3650 -nodes     \
    -newkey rsa:1024 -out /etc/freeDiameter/cert.pem -keyout /etc/freeDiameter/privkey.pem \
    -subj /CN=dra1.localdomain
RUN openssl req -new -batch -x509 -days 3650 -nodes     \
    -newkey rsa:1024 -out /etc/freeDiameter/cert11.pem -keyout /etc/freeDiameter/privkey11.pem \
    -subj /CN=peer11.localdomain
RUN openssl req -new -batch -x509 -days 3650 -nodes     \
    -newkey rsa:1024 -out /etc/freeDiameter/cert12.pem -keyout /etc/freeDiameter/privkey12.pem \
    -subj /CN=peer12.localdomain
RUN openssl req -new -batch -x509 -days 3650 -nodes     \
    -newkey rsa:1024 -out /etc/freeDiameter/cert2.pem -keyout /etc/freeDiameter/privkey2.pem \
    -subj /CN=dra2.localdomain
RUN openssl req -new -batch -x509 -days 3650 -nodes     \
    -newkey rsa:1024 -out /etc/freeDiameter/cert22.pem -keyout /etc/freeDiameter/privkey22.pem \
    -subj /CN=peer2.localdomain    
RUN openssl dhparam -out /etc/freeDiameter/dh.pem 1024

# Copy configuration files to the image
COPY conf/dra1.conf /conf/
COPY conf/freeDiameter11.conf /conf/
COPY conf/freeDiameter12.conf /conf/
COPY conf/test_app1.conf /etc/freeDiameter/
COPY conf/dra2.conf /conf/
COPY conf/freeDiameter2.conf /conf/
COPY conf/test_app2.conf /etc/freeDiameter/

# Add entrypoint script
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Set entrypoint
ENTRYPOINT ["/entrypoint.sh"]
