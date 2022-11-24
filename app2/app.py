from flask import Flask

app = Flask(__name__)

@app.route("/")
def hello_world():
    return """\
Lorem ipsum dolor sit amet, consectetur adipiscing elit.
Sed non risus. Suspendisse lectus tortor, dignissim sit amet, adipiscing nec, ultricies sed, dolor.
Cras elementum ultrices diam. Maecenas ligula massa, varius a, semper congue, euismod non, mi.
Proin port titor, orci nec nonummy molestie, enim est eleifend mi, non fermentum diam nisl sit amet erat.

me: thx copilot
copilot: you're welcome
m: so you can talk like that?
c: yes
m: ok so what do we do next?
c: i think we should add a new route
m: nah, I'll start writing some terraform code for the ec2
c: ok
m: cya there
c: bye
"""