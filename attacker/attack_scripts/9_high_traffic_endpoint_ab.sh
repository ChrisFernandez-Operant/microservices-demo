#!/bin/bash
ab -n 1000 -c 25 "${BASE_URL}/multi_method"
