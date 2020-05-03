# base image
FROM node:latest as builder

COPY . ./app
WORKDIR /app

RUN npm install
RUN npm run build --prod

FROM nginx:alpine
COPY --from=builder /app/dist/app/ /usr/share/nginx/html/
