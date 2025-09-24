FROM scratch
COPY package.json /app/
WORKDIR /app
CMD ["echo", "Hello from Docker!"]