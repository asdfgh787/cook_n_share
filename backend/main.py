import cv2
from flask import Flask, send_file, jsonify, request, send_from_directory
from flask_cors import CORS
import json
import io
import os
import PIL.Image as Image
import numpy as np
import matplotlib.pyplot as plt
from werkzeug.serving import WSGIRequestHandler

app = Flask(__name__)
CORS(app)

@app.route('/returnImage', methods=['GET', 'POST'])
def returnImage():
    global input_image
    global output_image
    content = request.get_json()
    resposta = content
    print(resposta)

    encoded_image = cv2.imread("im1.png")  # input Model

    content2 = np.concatenate(encoded_image, axis=0)

    dict1 = {}
    dict1['imatge'] = content2.tolist()
    dict1['nom'] = 'Pizza'
    dict1['user'] = '@p'
    dict1['ingredients'] = ['F', 'W']
    dict1['likes'] = 12
    dict1['steps'] = ['s1', 's2']
    dict1['allergens'] = ['a1', 'a2']

    # Enviem com a resposta un JSON amb l'imatge codificada
    response = jsonify(image1=dict1)

    response.headers.add("Access-Control-Allow-Origin", "*")
    return response

if __name__ == '__main__':
    WSGIRequestHandler.protocol_version = "HTTP/1.1"  # s'utilitza per poder tenir una connexió de tipus Keep-Alive
    app.run()
