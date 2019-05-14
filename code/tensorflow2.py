#!/usr/bin/env python3
# -*- coding: utf-8 -*-
# filename: tensorflow2.py

from logbook import Logger, StreamHandler
import sys

import tensorflow as tf
from tensorflow.keras import layers

log = Logger("Tensorflow")
handler = StreamHandler(sys.stdout)
handler.push_application()

log.info(tf.__version__)
log.info(tf.keras.__version__)
