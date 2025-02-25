# Start attacks
kubectl create -f attacker-deployment.yaml

# Stop attacks (destructive)
kubectl delete deployment attacker

# Temporary pause (preserves logs)
kubectl scale deployment attacker --replicas=0

# View logs
kubectl logs deployment/attacker -f
