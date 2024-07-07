$ terraform init
>> Terraform has been successfully initialized!

$ terraform validate
>> Success! The configuration is valid.

$ terraform plan
>> Plan: 2 to add, 0 to change, 0 to destroy.

$ terraform aplly

or with specific version:
$ terraform apply -var "image=rotanakh:v1.0.0"  

$ terraform destory





*** Dockers======================================= 
docker build -t rotanakh:v1.0.0 

or

docker-compose up --build