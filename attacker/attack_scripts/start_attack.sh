#!/bin/sh
# Set base URL from environment variables
export BASE_URL="http://${TARGET_HOST}:${TARGET_PORT}${BASE_PATH}"

# Run attacks sequentially
./1_credential_stuffing.sh
sleep 5
./2_password_reset_abuse.sh
sleep 5
./3_auth_endpoint_errors.sh
sleep 5
./4_rate_limit_abuse.sh &
./5_http_protocol_misconfig.sh
./6_high_traffic_endpoint.sh
./7_4xx_error_generation.sh
./8_method_enumeration.sh
wait
