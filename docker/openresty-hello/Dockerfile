FROM openresty/openresty:1.21.4.3-1-bullseye

COPY default.conf /etc/nginx/conf.d/
CMD ["/usr/bin/taskset", "-c", "1", "/usr/bin/openresty", "-g", "daemon off; master_process off;"]
