# app_nodejs

## Initialization

```bash
npm init -y
npm install express
npm install -D nodemon
nano package.json # modify start script to run 'nodemon index.js'
npm run start
```

## Development

```bash
nvm install
nvm use
npm i
npm start
```

## Production

```bash
# Set some variables. Use the equivalent syntax for your OS
export DOCKERHUB_ID=<YOUR_DOCKERHUB_ID>
export APP_NAME=app_python

# Build app image
docker build -t $DOCKERHUB_ID/$APP_NAME .

# Testing the built image locally using its exposed port
docker run -p8080:8080 $DOCKERHUB_ID/$APP_NAME

# Tag image with last commit SHA (and/or use semantic versioning)
docker tag $DOCKERHUB_ID/$APP_NAME $DOCKERHUB_ID/$APP_NAME:$(git rev-parse --short HEAD)

# Login and push image to dockerhub
docker login -u $DOCKERHUB_ID # Enter password/token when prompted
docker push $DOCKERHUB_ID/$APP_NAME --all-tags
```
