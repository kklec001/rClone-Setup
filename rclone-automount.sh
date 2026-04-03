#!/bin/bash
for i in {1..5}; do \
rclone mount FrydmanLabGDrive: ~/rClone/.rClone_FrydmanLabGDrive && \
rclone mount StanfordGDrive: ~/rClone/.rClone_StanfordGDrive && \
break || sleep 5; done
