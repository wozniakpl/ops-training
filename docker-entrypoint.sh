#!/bin/bash

exec flask run --host=0.0.0.0 --port=80

# TODO:
# if dev, flask
# if prod, gunicorn or smth