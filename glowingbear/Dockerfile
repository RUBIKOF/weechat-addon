FROM alpine:3.19

RUN apk add --no-cache nginx

RUN mkdir -p /run/nginx

COPY nginx.conf /etc/nginx/nginx.conf

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
