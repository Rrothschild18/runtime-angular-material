FROM node:18-alpine as build
WORKDIR /app/
COPY . .
RUN npm install 
RUN npm run build


FROM nginx:alpine
COPY --from=build /app/dist/run-time-angular-material/browser /usr/share/nginx/html
RUN true
COPY ./nginx.conf /etc/nginx/conf.d/default.conf
RUN true
EXPOSE 4200
CMD ["nginx", "-g", "daemon off;"]