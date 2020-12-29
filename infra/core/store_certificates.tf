# Create certificate and store in kubernetes 

resource "tls_private_key" "tls_pk_gtwy" {
  algorithm = "RSA"
}

resource "tls_self_signed_cert" "tls_cert_gtwy" {
  key_algorithm   = tls_private_key.tls_pk_gtwy.algorithm
  private_key_pem = tls_private_key.tls_pk_gtwy.private_key_pem

  // certificate expires after 1 year
  validity_period_hours = 8760

  // generate new certificate if terraform executed within 30 days of
  // expiration period
  early_renewal_hours = 720

  allowed_uses = [
    "key_encipherment",
    "digital_signature",
    "server_auth",
  ]

  ip_addresses = [azurerm_public_ip.ip_gtwy.ip_address]

  subject {
    common_name = "${var.app}-${var.env}-${var.location_suffix}.com"
  }
}

resource "kubernetes_secret" "k8s_secret_tls_cert_gtwy" {
  metadata {
    // using the same secretName as ESHOP as this will have be referenced
    // in the k8s ingress resource config for eshop
    name      = "eshop-certificate"
    namespace = kubernetes_namespace.eshop.metadata.0.name
  }

  data = {
    "tls.crt" = tls_self_signed_cert.tls_cert_gtwy.cert_pem
    "tls.key" = tls_private_key.tls_pk_gtwy.private_key_pem
  }

  type = "kubernetes.io/tls"
}