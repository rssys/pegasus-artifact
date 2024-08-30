FROM nginx:1.25.3

COPY nginx.conf /etc/nginx/
COPY test_file2 /usr/share/nginx/html/

ENTRYPOINT ["/usr/sbin/nginx"]

