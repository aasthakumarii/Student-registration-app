FROM nginx:alpine

# Copy the frontend files to nginx
COPY . /usr/share/nginx/html/

# Expose port
EXPOSE 80

# Start nginx
CMD ["nginx", "-g", "daemon off;"]
