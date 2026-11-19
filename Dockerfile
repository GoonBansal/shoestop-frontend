FROM node:20-alpine AS build
WORKDIR /app
COPY package*.json ./
RUN npm install --legacy-peer-deps
COPY . .
RUN npm run build
RUN mkdir -p /app/out && (cp -r /app/build/* /app/out/ 2>/dev/null || cp -r /app/dist/* /app/out/)

FROM nginx:alpine
COPY --from=build /app/out /usr/share/nginx/html
RUN printf 'server {\n listen 80;\n location / {\n root /usr/share/nginx/html;\n index index.html index.htm;\n try_files $uri $uri/ /index.html;\n }\n}\n' > /etc/nginx/conf.d/default.conf
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
