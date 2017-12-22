#!/bin/bash

# Create environment file to hold PORT and DB_URL
echo "PORT=3000" > .env
echo "DB_URL='mongodb://0.0.0.0:27017/database'" >> .env

# Create Dockerfile for UserManager App
touch Dockerfile.appx
df=$"FROM node:carbon\n\n# Create app directory\nWORKDIR /usr/src/app\n\n# Install app dependencies\nCOPY package*.json ./\n\nRUN npm install\n\nCOPY . .\n\nEXPOSE 3000\nCMD [ \"npm\", \"start\" ]"
echo -e $df > Dockerfile.appx

# Create Dockerfile for MongoDB Container
touch Dockerfile.db
mdf=$"# Pull base image.\nFROM ubuntu:latest\n\n# Install MongoDB.\nRUN \\ \n  apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 7F0CEB10 && \\ \n  echo 'deb http://downloads-distro.mongodb.org/repo/ubuntu-upstart dist 10gen' > /etc/apt/sources.list.d/mongodb.list && \\ \n  apt-get update && \\ \n  apt-get install -y mongodb-org && \\\n  rm -rf /var/lib/apt/lists/*\n\n# Define mountable directories.\nVOLUME [\"/data/db\"]\n\n# Define working directory.\nWORKDIR /data\n\n# Define default command.\nCMD [\"mongod\"]\n\n# Expose ports.\n#   - 27017: process\n#   - 28017: http\nEXPOSE 27017\nEXPOSE 28017"
echo -e $mdf > Dockerfile.db

# Create dockerignore file
touch .dockerignore
echo -e "node_modules\nnpm-debug.log" > .dockerignore

#Build Application Image
docker build -f Dockerfile.appx -t user/usermanager .

#Build MongoDB Image
docker build -f Dockerfile.db -t user/mongodb .

#Run Application and Database Images as seperate detatched containers
docker run -p 3000:3000 -d user/usermanager
docker run -p 27017:27017 -d user/mongodb

