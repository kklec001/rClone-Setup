#!/bin/bash
for i in {1..5}; do \
rclone mount FrydmanLabGDrive: ~/rClone/.rClone_FrydmanLabGDrive --vfs-cache-mode full --vfs-cache-max-size 25G && \
rclone mount StanfordGDrive: ~/rClone/.rClone_StanfordGDrive --vfs-cache-mode full --vfs-cache-max-size 25G && \
break || sleep 5; done
