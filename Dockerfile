FROM ubuntu

# Update and install Apache
RUN apt update && apt-get install -y apache2

# Set the working directory (optional but recommended)
WORKDIR /var/www/html

# Copy your website files into the container
ADD ./var/www/html /var/www/html

# Keep Apache running in the foreground
ENTRYPOINT ["apachectl", "-D", "FOREGROUND"]
