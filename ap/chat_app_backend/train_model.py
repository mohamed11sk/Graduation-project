import json
import numpy as np
import tensorflow as tf
import pickle
from tensorflow.keras.preprocessing.text import Tokenizer
from tensorflow.keras.preprocessing.sequence import pad_sequences
from sklearn.preprocessing import LabelEncoder
from tensorflow.keras.models import Sequential
from tensorflow.keras.layers import Embedding, LSTM, Dense, Dropout

with open("chat_data.json", "r", encoding="utf-8") as file:
    data = json.load(file)

all_patterns = []
all_tags = []

for intent in data["intents"]:
    tag = intent["tag"]
    for pattern in intent["patterns"]:
        all_patterns.append(pattern)
        all_tags.append(tag)

tokenizer = Tokenizer()
tokenizer.fit_on_texts(all_patterns)

X_sequences = tokenizer.texts_to_sequences(all_patterns)
max_len = max(len(seq) for seq in X_sequences)  

X_padded = pad_sequences(X_sequences, maxlen=max_len, padding="post")

label_encoder = LabelEncoder()
y_encoded = label_encoder.fit_transform(all_tags)

vocab_size = len(tokenizer.word_index) + 1  

model = Sequential([
    Embedding(input_dim=vocab_size, output_dim=128, input_length=max_len),
    LSTM(128, return_sequences=True),
    Dropout(0.2),
    LSTM(128),
    Dropout(0.2),
    Dense(128, activation="relu"),
    Dense(len(label_encoder.classes_), activation="softmax")
])

model.compile(loss="sparse_categorical_crossentropy", optimizer="adam", metrics=["accuracy"])

model.fit(X_padded, np.array(y_encoded), epochs=100, batch_size=16)

model.save("chat_model.h5")

with open("tokenizer.pkl", "wb") as f:
    pickle.dump(tokenizer, f)

with open("label_encoder.pkl", "wb") as f:
    pickle.dump(label_encoder, f)

print("✅ Model trained and saved successfully!")
