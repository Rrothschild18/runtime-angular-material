FROM node:20-alpine as build

COPY . /app

WORKDIR /app/

RUN npm install
RUN npx run build 
RUN ls -l

FROM nginx:alpine
COPY --from=build /app/dist/runtime-angular-material /usr/share/nginx/html

RUN true

COPY ./nginx.conf etc/nginx/conf.d/default.conf

RUN true

EXPOSE 4200

CMD ["nginx", "-g", "daemon off;"]
