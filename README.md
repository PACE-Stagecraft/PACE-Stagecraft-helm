# agora-helm

Helm charts for deploying [aGorA](https://github.com/aGora-Ops) on EKS.
Image tags are updated automatically by the `helm-update.yml` reusable workflow in [agora-workflows](https://github.com/aGora-Ops/agora-workflows).

**Kubernetes namespace**: `agora`

## Charts

| Chart | Port | Description |
|-------|------|-------------|
| `agora-api` | 8000 | FastAPI backend |
| `agora-webhook` | 8001 | GitHub webhook receiver |
| `agora-worker` | — | Celery worker + SQS consumer (2 Deployments) |
| `agora-frontend` | 3000 | Next.js 14 dashboard |

## Secrets strategy

Secrets are pulled from **AWS Secrets Manager** at runtime via [External Secrets Operator](https://external-secrets.io/).
No secrets are stored in this repo or passed via `--set` at deploy time.

Each chart has an `externalsecret.yaml` template pointing to a path like `agora/{env}/{service}`.
Create the secret in Secrets Manager before deploying:

```bash
aws secretsmanager create-secret \
  --name agora/dev/api \
  --secret-string '{
    "DATABASE_URL": "...",
    "SECRET_KEY": "...",
    "GITHUB_CLIENT_ID": "...",
    "GITHUB_CLIENT_SECRET": "...",
    "GITHUB_WEBHOOK_SECRET": "...",
    "SQS_QUEUE_URL": "...",
    "TOKEN_ENCRYPTION_KEY": "..."
  }'
```

## Deploy manually

```bash
# Deploy to dev
helm upgrade --install agora-api charts/agora-api \
  --namespace agora --create-namespace \
  -f charts/agora-api/values.yaml \
  -f charts/agora-api/values.dev.yaml \
  --set image.repository=ACCOUNT.dkr.ecr.us-east-1.amazonaws.com/agora-api \
  --set image.tag=v0.1.0 \
  --set serviceAccount.annotations."eks\.amazonaws\.com/role-arn"=arn:aws:iam::ACCOUNT:role/agora-dev-agora-api
```

## CI

`helm lint` and `helm template` run on every PR via [`.github/workflows/lint.yml`](.github/workflows/lint.yml).
