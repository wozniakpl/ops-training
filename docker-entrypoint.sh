#!/bin/bash

arg=$1
echo 

case $arg in
    dev)
        exec flask run --host=0.0.0.0 --port=80
        ;;
    prod)
        exec gunicorn --workers=4 --bind=0.0.0.0:80 'app:app'
        ;;
    *)
        echo "Unrecognized argument: $arg"
        exit 1
        ;;
esac
