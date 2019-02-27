#!/bin/bash
/usr/share/logstash/bin/logstash -f /home/ubuntu/spark_logstash.conf --path.data /tmp/logstash.data
