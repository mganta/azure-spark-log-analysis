#!/bin/bash
sudo blobfuse ~/dbrickslogs --tmp-path=/mnt/resource/blobfusetmp  --config-file=/home/ubuntu/fuse_connection.cfg -o attr_timeout=240 -o entry_timeout=240 -o negative_timeout=120 -o allow_other
