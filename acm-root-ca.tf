# Our CA
locals {
    domain = "test.local"
}
resource "aws_acmpca_certificate_authority_certificate" "rootCA" {
  certificate_authority_arn = aws_acmpca_certificate_authority.rootCA.arn

  certificate       = aws_acmpca_certificate.rootCA.certificate
  certificate_chain = aws_acmpca_certificate.rootCA.certificate_chain
}

resource "aws_acmpca_certificate" "rootCA" {
  certificate_authority_arn   = aws_acmpca_certificate_authority.rootCA.arn
  certificate_signing_request = aws_acmpca_certificate_authority.rootCA.certificate_signing_request
  signing_algorithm           = "SHA512WITHRSA"

  template_arn = "arn:${data.aws_partition.current.partition}:acm-pca:::template/RootCACertificate/V1"

  validity {
    type  = "YEARS"
    value = 20
  }
}

resource "aws_acmpca_certificate_authority" "rootCA" {
  type = "ROOT"

  certificate_authority_configuration {
    key_algorithm     = "RSA_4096"
    signing_algorithm = "SHA512WITHRSA"

    subject {
      common_name = local.domain
    }
  }
}

data "aws_partition" "current" {}


