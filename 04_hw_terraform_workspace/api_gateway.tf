# locals {
#   microservice_index_map = {
#     for index, name in var.microservices_list : name => index
#   }
# }

# # Create API Gateway
resource "aws_api_gateway_rest_api" "microservices_rest_api" {
  name        = "api-gateway-lambda"
  description = "api-gateway-lambda"
}

# # Create API Gateway resources for each microservice
# resource "aws_api_gateway_resource" "api_resource" {
#   count       = length(var.microservices_list)
#   rest_api_id = aws_api_gateway_rest_api.microservices_rest_api.id
#   parent_id   = aws_api_gateway_rest_api.microservices_rest_api.root_resource_id
#   path_part   = var.microservices_list[count.index]
# }


# # Create GET method for each API resource
# resource "aws_api_gateway_method" "api_get_method" {
#   count         = length(var.microservices_list)
#   rest_api_id   = aws_api_gateway_rest_api.microservices_rest_api.id
#   resource_id   = element(aws_api_gateway_resource.api_resource[*].id, count.index)
#   http_method   = "GET"
#   authorization = "NONE"

#   request_parameters = {
#     "method.request.header.Content-Type" = true
#   }
# }

# # Create Lambda integration for each API method
# resource "aws_api_gateway_integration" "api_integration" {
#   count                   = length(var.microservices_list)
#   rest_api_id             = aws_api_gateway_rest_api.microservices_rest_api.id
#   resource_id             = element(aws_api_gateway_resource.api_resource[*].id, count.index)
#   http_method             = aws_api_gateway_method.api_get_method[count.index].http_method
#   credentials             = aws_iam_role.lambda_role.arn
#   integration_http_method = "POST"
#   passthrough_behavior    = "WHEN_NO_MATCH"

#   request_parameters = {
#     "integration.request.header.Content-Type" = "method.request.header.Content-Type"
#   }

#   uri  = aws_lambda_function.microservices_function_api[count.index].invoke_arn
#   type = "AWS"
# }

# # Define Method and Integration Responses:
# resource "aws_api_gateway_method_response" "api_method_response_200" {
#   count       = length(var.microservices_list)
#   rest_api_id = aws_api_gateway_rest_api.microservices_rest_api.id
#   resource_id = element(aws_api_gateway_resource.api_resource[*].id, count.index)
#   http_method = "GET"
#   status_code = "200"

#   response_parameters = {
#     "method.response.header.Content-Type"              = true
#     "method.response.header.Strict-Transport-Security" = true
#   }

#   response_models = {
#     "application/json" = "Empty"
#   }
# }

# resource "aws_api_gateway_integration_response" "api_integration_response_200" {
#   count       = length(var.microservices_list)
#   rest_api_id = aws_api_gateway_rest_api.microservices_rest_api.id
#   resource_id = element(aws_api_gateway_resource.api_resource[*].id, count.index)
#   http_method = "GET"
#   status_code = aws_api_gateway_method_response.api_method_response_200[count.index].status_code

#   response_templates = {
#     "application/json" = ""
#   }

#   response_parameters = {
#     "method.response.header.Content-Type"              = "'integration.response.header.Content-Type'"
#     "method.response.header.Strict-Transport-Security" = "'max-age=63072000; includeSubDomains; preload'"
#   }
# }


# # Deployment Output
# resource "aws_api_gateway_deployment" "microservices_deployment" {
#   depends_on = [
#     aws_api_gateway_method_response.api_method_response_200,
#     aws_api_gateway_integration_response.api_integration_response_200,
#     # Add similar dependencies for each microservice
#   ]
#   rest_api_id       = aws_api_gateway_rest_api.microservices_rest_api.id
#   stage_name        = "dev"
#   stage_description = "Development Stage"
# }

# output "invoke_url" {
#   value = aws_api_gateway_deployment.microservices_deployment.invoke_url
# }


# Create API Gateway resources for each microservice
resource "aws_api_gateway_resource" "api_resource" {
  count       = length(var.microservices_list)
  rest_api_id = aws_api_gateway_rest_api.microservices_rest_api.id
  parent_id   = aws_api_gateway_rest_api.microservices_rest_api.root_resource_id
  path_part   = var.microservices_list[count.index]
}

# Create GET method for each API resource
resource "aws_api_gateway_method" "api_get_method" {
  count         = length(var.microservices_list)
  rest_api_id   = aws_api_gateway_rest_api.microservices_rest_api.id
  resource_id   = aws_api_gateway_resource.api_resource[count.index].id
  http_method   = "GET"
  authorization = "NONE"

  request_parameters = {
    "method.request.header.Content-Type" = true
  }
}

# Create Lambda integration for each API method
resource "aws_api_gateway_integration" "api_integration" {
  count                   = length(var.microservices_list)
  rest_api_id             = aws_api_gateway_rest_api.microservices_rest_api.id
  resource_id             = aws_api_gateway_resource.api_resource[count.index].id
  http_method             = aws_api_gateway_method.api_get_method[count.index].http_method
  credentials             = aws_iam_role.ecs_task_execution_role.arn
  integration_http_method = "POST"
  passthrough_behavior    = "WHEN_NO_MATCH"

  request_parameters = {
    "integration.request.header.Content-Type" = "method.request.header.Content-Type"
  }

  uri  = aws_lambda_function.microservices_function_api[count.index].invoke_arn
  type = "AWS"
}

# Define Method and Integration Responses:
resource "aws_api_gateway_method_response" "api_method_response_200" {
  count       = length(var.microservices_list)
  rest_api_id = aws_api_gateway_rest_api.microservices_rest_api.id
  resource_id = aws_api_gateway_resource.api_resource[count.index].id
  http_method = "GET"
  status_code = "200"

  response_parameters = {
    "method.response.header.Content-Type"              = true
    "method.response.header.Strict-Transport-Security" = true
  }

  response_models = {
    "application/json" = "Empty"
  }
}

resource "aws_api_gateway_integration_response" "api_integration_response_200" {
  count       = length(var.microservices_list)
  rest_api_id = aws_api_gateway_rest_api.microservices_rest_api.id
  resource_id = aws_api_gateway_resource.api_resource[count.index].id
  http_method = aws_api_gateway_method.api_get_method[count.index].http_method
  status_code = aws_api_gateway_method_response.api_method_response_200[count.index].status_code

  response_templates = {
    "application/json" = ""
  }

  response_parameters = {
    "method.response.header.Content-Type"              = "'integration.response.header.Content-Type'"
    "method.response.header.Strict-Transport-Security" = "'max-age=63072000; includeSubDomains; preload'"
  }
}

