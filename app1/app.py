import datetime
from flask import Flask, request

app = Flask(__name__)

@app.route("/")
def page():
    date = datetime.datetime.now()
    return {
        "host": request.host,
        "remote_addr": request.remote_addr,
        "date": date
    }