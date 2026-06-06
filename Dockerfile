#Building stage
FROM node:20 AS build

WORKDIR /mailVas

COPY package*.json ./
RUN npm i

COPY . .
RUN npm run build

#production stage
FROM nginx:alpine

COPY --from=build /mailVas/dist /usr/share/nginx/html


EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]