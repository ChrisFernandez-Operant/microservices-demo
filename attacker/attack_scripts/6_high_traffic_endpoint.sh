#!/bin/sh
siege -b -t1M -c 25 "${BASE_URL}/multi_method"
