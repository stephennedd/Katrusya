# Use Node.js v18 as the base image
FROM node:18

# Set the working directory to /app
WORKDIR /app

# Copy the package.json and package-lock.json files to the container
COPY package*.json ./

RUN npm install --arch=x64 --platform=linux --target=14.18.0 bcrypt
# Download and install wait-for-it.sh script
RUN curl -LJO https://raw.githubusercontent.com/vishnubob/wait-for-it/master/wait-for-it.sh
RUN chmod +x wait-for-it.sh

# Install dependencies
RUN npm install

# Copy the rest of the application files to the container
COPY . .

COPY .env .

# Expose port 3000 for the application
EXPOSE 3000

# CMD ["npm", "run", "start:dev"]