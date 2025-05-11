FROM node:16-alpine AS build
WORKDIR /app
COPY package*.json ./
RUN npm install --force
COPY . .
RUN npm run build
FROM nginx:alpine
RUN rm /etc/nginx/conf.d/default.conf  # opcional
COPY default.conf /etc/nginx/conf.d/default.conf  
COPY --from=build /app/dist /usr/share/nginx/html 
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
