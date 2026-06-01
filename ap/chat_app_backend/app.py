from flask import Flask, request, jsonify
import tensorflow as tf
import numpy as np
import pickle
import requests
import socket
from tensorflow.keras.preprocessing.sequence import pad_sequences
import json
import random

app = Flask(__name__)

# Load model and associated data
model = tf.keras.models.load_model("chat_model.h5")

with open("tokenizer.pkl", "rb") as f:
    tokenizer = pickle.load(f)

with open("label_encoder.pkl", "rb") as f:
    label_encoder = pickle.load(f)

with open("chat_data.json", "r", encoding="utf-8") as f:
    chat_data = json.load(f)

max_len = model.input_shape[1]

# Get local IP address
def get_local_ip():
    try:
        s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
        s.connect(("8.8.8.8", 80))  # Connect to get the local IP
        ip = s.getsockname()[0]
        s.close()
        return ip
    except Exception:
        return "0.0.0.0"

# Send 'ipai' to Firebase without changing existing 'ip'
def update_ip_to_firebase(ip):
    firebase_url = "https://lotfy-5bd82-default-rtdb.firebaseio.com/EspData.json"
    data = {"ipai": ip}  # This adds 'ipai' field only
    response = requests.patch(firebase_url, json=data)
    print("Firebase update status:", response.status_code, response.text)

# Update IP at server start
ip_address = get_local_ip()
update_ip_to_firebase(ip_address)

@app.route('/chat', methods=['POST'])
def chat():
    data = request.get_json()
    user_input = data.get('question', '').strip()

    if not user_input:
        return jsonify({'response': 'Please enter a valid message.'})

    sequence = tokenizer.texts_to_sequences([user_input])
    padded_sequence = pad_sequences(sequence, maxlen=max_len, padding='post')

    prediction = model.predict(padded_sequence)
    predicted_class_index = np.argmax(prediction)
    predicted_tag = label_encoder.inverse_transform([predicted_class_index])[0]

    response_list = []
    for intent in chat_data["intents"]:
        if intent["tag"] == predicted_tag:
            response_list = intent["responses"]
            break

    response = random.choice(response_list) if response_list else "I'm not sure how to respond to that."
    return jsonify({'response': response})

if __name__ == '__main__':
    app.run(host='0.0.0.0', debug=True)
