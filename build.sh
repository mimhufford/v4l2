#!/bin/bash

set -xe

cc -O3 -o webcam webcam.c -Iraylib/include raylib/lib/libraylib.a -lv4l2 -lm