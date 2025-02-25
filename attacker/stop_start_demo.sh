# Start attacks
kubectl create -f attacker-deployment.yaml

# Stop attacks (destructive)
kubectl delete deployment attacker
kubectl delete job attacker 2>/dev/null

# Temporary pause (preserves logs)
kubectl scale deployment attacker --replicas=0

# View logs
kubectl logs deployment/attacker -f
