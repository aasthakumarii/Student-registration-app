FROM nginx:alpine

ENV BACKEND_HOST=127.0.0.1

# Copy the frontend files to nginx
COPY . /usr/share/nginx/html/

# Copy custom nginx config template
COPY nginx.conf /etc/nginx/templates/default.conf.template

# Expose port
EXPOSE 80

# Start nginx
CMD ["nginx", "-g", "daemon off;"]
