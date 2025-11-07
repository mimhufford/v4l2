#!/bin/bash

set -xe

cc -o webcam webcam.c -Iraylib/include raylib/lib/libraylib.a -lv4l2 -lm