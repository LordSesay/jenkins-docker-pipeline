FROM ubuntu:20.04
RUN apt-get update && apt-get install -y nodejs npm && rm -rf /var/lib/apt/lists/*
WORKDIR /app
COPY package*.json ./
RUN npm install --only=production
COPY . .
EXPOSE 3000
RUN useradd -m appuser
USER appuser
CMD ["npm", "start"]