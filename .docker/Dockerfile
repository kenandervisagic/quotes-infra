# Use the official NGINX image as the base image
FROM nginx:latest

# Copy your custom nginx.conf file from the local directory to the container
COPY nginx/nginx.conf /etc/nginx/nginx.conf

# Expose the port NGINX will run on
EXPOSE 80
EXPOSE 443

# Start NGINX when the container starts
CMD ["nginx", "-g", "daemon off;"]

