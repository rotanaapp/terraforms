# Create zip file
data "archive_file" "lambda_zip" {
  count       = length(var.microservices_list)
  type        = "zip"
  source_dir  = "${path.module}/microservices/${var.microservices_list[count.index]}/"
  output_path = "${path.module}/microservices/zip/${var.microservices_list[count.index]}.zip"
}

# Create lambda function and upload zip file into the lambda func
resource "aws_lambda_function" "microservices_function_api" {
  count            = length(var.microservices_list)
  filename         = data.archive_file.lambda_zip[count.index].output_path
  function_name    = "microservices_function_api_${var.microservices_list[count.index]}"
  role             = aws_iam_role.lambda_role.arn
  handler          = "main.lambda_handler"
  source_code_hash = data.archive_file.lambda_zip[count.index].output_base64sha256
  runtime          = "python3.8"
  timeout          = "600"
}