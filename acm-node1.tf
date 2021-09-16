# Host certificates:

resource "tls_private_key" "host1_key" {
  algorithm = "RSA"
}

resource "tls_cert_request" "host1_csr" {
  key_algorithm   = "RSA"
  private_key_pem = tls_private_key.host1_key.private_key_pem

  subject {
    common_name = "host1.sub.${local.domain}"
  }
}

resource "aws_acmpca_certificate" "host1_crt" {
  certificate_authority_arn   = aws_acmpca_certificate_authority.subordinate.arn
  certificate_signing_request = tls_cert_request.host1_csr.cert_request_pem
  signing_algorithm           = "SHA256WITHRSA"
  validity {
    type  = "YEARS"
    value = 1
  }
}

resource "local_file" "host1_crt" {
    content     = aws_acmpca_certificate.host1_crt.certificate
    filename = "output/node.pem"
}

resource "local_file" "host1_chain" {
    content     = aws_acmpca_certificate.host1_crt.certificate_chain
    filename = "output/node.chain"
}