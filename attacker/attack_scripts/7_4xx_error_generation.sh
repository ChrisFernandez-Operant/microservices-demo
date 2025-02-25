#!/bin/sh
curl -H "Content-Type: application/json" "${BASE_URL}/profile"
curl -X PUT "${BASE_URL}/multi_method"
