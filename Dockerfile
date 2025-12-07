FROM ubuntu:22.04

# Install Apache
RUN apt-get update && \
    apt-get install -y apache2 && \
    apt-get clean

# Copy website files into container
COPY ./ /var/www/html/

# Expose port 80
EXPOSE 80

# Start Apache in the foreground
ENTRYPOINT ["apachectl", "-D", "FOREGROUND"]
