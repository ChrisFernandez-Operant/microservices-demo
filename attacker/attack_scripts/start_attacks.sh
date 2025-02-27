#!/bin/bash
set -eo pipefail

echo "=== STARTING ATTACKS ==="
echo "BASE_URL: http://${TARGET_HOST}:${TARGET_PORT}${BASE_PATH}"
echo $BASE_URL

sleep 60 # to give time to container to setup since is timing out getting the frontend

# Run attacks with proper job control
(
  echo "1. Credential Stuffing"
  ./1_credential_stuffing.sh

  echo "2. Password Reset Abuse"
  ./2_password_reset_abuse.sh

  echo "3. Auth Endpoint Errors"
  ./3_auth_endpoint_errors.sh

  echo "4. Rate Limit Abuse (background)"
  ./4_rate_limit_abuse.sh &

  echo "5. HTTP Protocol Misconfig"
  ./5_http_protocol_misconfig.sh

  echo "6. High Traffic Endpoint"
  ./6_high_traffic_endpoint.sh

  echo "7. 4XX Error Generation"
  ./7_4xx_error_generation.sh

  echo "8. Method Enumeration"
  ./8_method_enumeration.sh

  echo "9. High Traffic Endpoint with Apache2 utils AB"
  ./9_high_traffic_endpoint_ab.sh

  wait  # Wait for background jobs
) || {
  echo "!!! ATTACK FAILED !!!"
  exit 1
}

echo "=== ATTACKS COMPLETED ==="
touch /tmp/attack-complete

# Keep container alive until timeout
echo "Waiting for timeout..."
sleep 1800  # 30 minutes
