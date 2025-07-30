FROM httpd:latest

# Note: no leading slash in source path
WORKDIR   /usr/local/apache2/htdocs/mywebsite

EXPOSE 80
