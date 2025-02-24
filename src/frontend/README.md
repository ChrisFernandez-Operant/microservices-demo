# frontend

Run the following command to restore dependencies to `vendor/` directory:

    dep ensure --vendor-only

# New Endpoints for OWASP top 10 test
## Original Endpoints

| Path                          | Methods                          | Description |
|-------------------------------|----------------------------------|-------------|
| `/`                           | GET, HEAD                        | Home page |
| `/product/{id}`               | GET, HEAD                        | Product details |
| `/cart`                       | GET, HEAD                        | View cart |
| `/cart`                       | POST                             | Add to cart |
| `/cart/empty`                 | POST                             | Empty cart |
| `/setCurrency`                | POST                             | Set currency |
| `/logout`                     | GET                              | Logout |
| `/cart/checkout`              | POST                             | Checkout |
| `/assistant`                  | GET                              | Shopping assistant |
| `/static/` (prefix)           | GET                              | Static assets |
| `/robots.txt`                 | GET                              | Robots.txt |
| `/_healthz`                   | GET                              | Health check |
| `/product-meta/{ids}`         | GET                              | Get product metadata |
| `/bot`                        | POST                             | Chat bot endpoint |

## New Endpoints Added

| Path                          | Methods                          | Description |
|-------------------------------|----------------------------------|-------------|
| `/reset_password`             | GET, POST                        | Password reset |
| `/create_password`            | GET, POST                        | Create password |
| `/signin`                     | GET, POST                        | User sign-in |
| `/signup`                     | GET, POST                        | User sign-up |
| `/auth`                       | GET, POST                        | Authentication |
| `/authenticate`               | GET, POST                        | Authentication flow |
| `/token`                      | GET, POST                        | Token handling |
| `/oauth`                      | GET, POST                        | OAuth flow |
| `/session/renew`              | GET, POST                        | Session renewal |
| `/profile`                    | GET, POST                        | User profile |
| `/multi_method`               | GET, POST, PUT, DELETE           | Multi-method endpoint |

## Summary
- **Original endpoints**: 14
- **New endpoints added**: 11
- **Total endpoints**: 25
