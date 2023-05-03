#!/bin/bash

url="http://your-staging-server.example.com"
concurrency=100
total_requests=1000
requests_per_process=$((total_requests / concurrency))

for ((i = 1; i <= concurrency; i++)); do
  (
    for ((j = 1; j <= requests_per_process; j++)); do
      curl -s -o /dev/null -w "Response latency: %{time_total}s\n" "$url"
    done
  ) &
done

# Wait for all background processes to complete
wait
