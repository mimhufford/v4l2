#!/bin/bash

set -xe

cc -o webcam webcam.c -lv4l2 -lm