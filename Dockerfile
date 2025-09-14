#build stage
FROM node:18-alpine AS build
# set work directory
WORKDIR /app

# copy package file
COPY package*.json ./

# install all dependencies
RUN npm ci

# copy source code 
COPY . .

# build the appliction
RUN npm run build

# prodiction stage
FROM nginx:alpine

# remove default nginx static file 
RUN rm -rf /usr/share/nginx/html/*

# copy built assects from the build stage
COPY  --from=build /app/dist /usr/share/nginx/html

# expose port 80
EXPOSE 80

# start the server
CMD ["nginx","-g","daemon off;"]
