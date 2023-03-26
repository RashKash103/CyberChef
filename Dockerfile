FROM node:18 as build

WORKDIR /usr/src/app
COPY --chown=1000:1000 ./CyberChef /usr/src/app

# Install node modules
RUN npm install

# Builds the application
RUN npx grunt prod

# Generates sitemap
RUN npx grunt exec:sitemap

# Removes the packages zip file because that's not needed
RUN rm /usr/src/app/build/prod/*.zip


FROM nginx

LABEL org.opencontainers.image.source=https://github.com/RashKash103/CyberChef
LABEL org.opencontainers.image.description="CyberChef"
LABEL org.opencontainers.image.licenses=Apache-2.0

# Copy the build files from the build stage
COPY --from=build /usr/src/app/build/prod /usr/share/nginx/html

# Expose the port
EXPOSE 80