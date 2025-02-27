#!/bin/bash
curl -I "${BASE_URL}/profile"
curl -X POST "${BASE_URL}/token"
