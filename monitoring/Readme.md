
---

### **Monitoring Setup Guide**

#### **1. Create a namespace for monitoring**
```bash
kubectl create namespace monitoring
```

#### **2. Add Helm repositories for Prometheus and Grafana**
```bash
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo add grafana https://grafana.github.io/helm-charts
helm repo update
```

#### **3. Install kube-prometheus-stack using Helm**
```bash
helm install kube-prom prometheus-community/kube-prometheus-stack \
  --namespace monitoring
```

#### **4. Get Grafana admin password**
```bash
kubectl get secret kube-prom-grafana -n monitoring \
  -o jsonpath="{.data.admin-password}" | base64 --decode
```

#### **5. Expose Grafana using LoadBalancer**
```bash
kubectl patch svc kube-prom-grafana -n monitoring \
  -p '{"spec": {"type": "LoadBalancer"}}'
```

---

### **6. Dashboard Setup**
- Open Grafana
- Go to **Dashboards → Import**
- Upload or paste the JSON file for the desired dashboard

---
