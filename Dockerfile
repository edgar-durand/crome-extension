FROM node:14.17-alpine@sha256:b8d48b515e3049d4b7e9ced6cedbe223c3bc4a3d0fd02332448f3cdb000faee1 as builder
WORKDIR /usr/home

COPY . .

RUN npm i
RUN /usr/home/node_modules/@angular/cli/bin/ng build



FROM joinnus/nginx-node
ENV NODE_ENV production

# Stream the nginx logs to stdout and stderr
RUN ln -sf /dev/stdout /var/log/nginx/access.log && \
    ln -sf /dev/stderr /var/log/nginx/error.log

# copies generated javascript, node_modules and .env from build stage
COPY --from=builder /usr/home/dist/angularExtension/ /usr/share/nginx/html
COPY ./nginx/default.conf /etc/nginx/conf.d/default.conf
EXPOSE 80
