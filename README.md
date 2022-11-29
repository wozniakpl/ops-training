# How to

## Local

To see the app running locally, run:

```sh
docker-compose up
```

Then open your browser at [page 1](http://localhost:9001) or [page 2](http://localhost:9002).

## Cloud

To deploy the app production-like, do:

```sh
# Build the images
docker build --target app1 -t wozniakpl/dev:app1 .
docker build --target app2 -t wozniakpl/dev:app2 .
docker build -t wozniakpl/dev:app-proxy ./ops

# Push the images
docker push wozniakpl/dev:app1
docker push wozniakpl/dev:app2
docker push wozniakpl/dev:app-proxy

# Deploy the app with terraform

# Start the services on the server
docker-compose up -d
```
