FROM node:carbon

# Create app directory
WORKDIR /usr/src/app

# Install app dependencies
COPY package-lock.json package.json ./

RUN npm install

COPY . .

EXPOSE 3000

CMD [ "npm", "start" ]


