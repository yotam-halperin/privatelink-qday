##################
# Endpoint-Service
################## 

resource "aws_vpc_endpoint_service" "privatelink" {
  acceptance_required        = false
  network_load_balancer_arns = [aws_lb.this.arn]
  tags                           = {
      "Name" = "yotam-endpoint-service-privatelink"
  }
  # allowed_principals = 
}

output "endpoint_service_name" {
  value       = aws_vpc_endpoint_service.privatelink.service_name
}
