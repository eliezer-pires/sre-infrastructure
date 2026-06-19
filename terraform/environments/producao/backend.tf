terraform {
  # State remoto no MinIO (S3 compatível), com versionamento de bucket.
  # Lock via PostgreSQL (database terraform_locks).
  # Valores reais são fornecidos via -backend-config (não versionados).
  backend "s3" {
    bucket = "terraform-state"
    key    = "producao/terraform.tfstate"
    region = "us-east-1" # MinIO ignora, mas o provider exige

    # endpoint do MinIO interno (exemplo)
    endpoints = {
      s3 = "https://minio.intranet.local:9000"
    }

    # Flags necessárias para backend S3 apontando para MinIO
    skip_credentials_validation = true
    skip_metadata_api_check     = true
    skip_region_validation      = true
    force_path_style            = true

    # Credenciais NUNCA em código — passar via:
    #   terraform init -backend-config=backend.secret.hcl
    # ou variáveis de ambiente AWS_ACCESS_KEY_ID / AWS_SECRET_ACCESS_KEY
    # (idealmente obtidas do Vault no pipeline)
  }
}
