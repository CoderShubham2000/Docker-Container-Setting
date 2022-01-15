FROM ubuntu

RUN apt-get update
RUN apt-get install vim
RUN apt-get -y update
RUN apt-get -y install git

RUN apt-get update && sudo apt-get -y upgrade
RUN apt-get -y install curl git vim build-essential

RUN apt-get install curl software-properties-common

RUN curl -sL https://deb.nodesource.com/setup_10.x | sudo bash -
RUN apt-get install nodejs

RUN npm install -g truffle
RUN npm install -g ganache-cli
RUN ganache-cli

# using node alpine as base image
FROM node:alpine

# working dir ./app
WORKDIR /app

# Install the prerequisites to install the web3 and other ethereum npm packages
RUN apk update && apk upgrade && apk add --no-cache bash git openssh
RUN apk add --update python krb5 krb5-libs gcc make g++ krb5-dev

# Copy the package.json
COPY ./package.json .

# Install the dependencies
RUN npm install

# Copy the server and ethereum module
COPY . .

# using node alpine as base image
FROM node:alpine

# working dir ./app
WORKDIR /app

# Install the prerequisites to install the web3 and other ethereum npm packages
RUN apk update && apk upgrade && apk add --no-cache bash git openssh
RUN apk add --update python krb5 krb5-libs gcc make g++ krb5-dev

# Copy the package.json
COPY ./package.json .

# Install the dependencies
RUN npm install

# Copy the server and ethereum module
COPY . .

# set the default command
CMD ["npm","start"]