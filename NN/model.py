import tensorflow as tf
from PIL import Image
import numpy as np

device = 'cpu'


class PneumoniaModel:

    def __init__(self, path_to_model, tr=0.9):
        self.load_model(path_to_model)
        self.tr = tr

    def threshold(self, pred):
        if pred > self.tr:
            return 1
        else:
            return 0

    def load_model(self, path_to_model):
        self.model = tf.keras.models.load_model(path_to_model)

    def predict(self, img_path):
        pil_img = Image.open(img_path).convert('RGB')

        img_array = np.array(pil_img)
        img_array = img_array / 255.

        img_tensor = tf.convert_to_tensor(img_array)
        img_tensor = tf.image.resize(img_tensor, [150, 150])
        img_tensor1 = tf.expand_dims(img_tensor, axis=0)

        pred = self.threshold(self.model(img_tensor1).numpy())

        return pred



