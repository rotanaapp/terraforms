## 💥💥💥💥💥💥💥💥💥💥💥💥💥💥💥💥💥💥💥💥💥💥💥💥💥 ##
## This file is maintained in the `terraform` ##
## repo, any changes *will* be overwritten!!  ##
## 💥💥💥💥💥💥💥💥💥💥💥💥💥💥💥💥💥💥💥💥💥💥💥💥💥 ##

# From StackOverflow: https://stackoverflow.com/a/20566812
UNAME:= $(shell uname)
ifeq ($(UNAME),Darwin)
		OS_X  := true
		SHELL := /bin/bash
else
		OS_DEB  := true
		SHELL := /bin/bash
endif

TERRAFORM:= $(shell command -v terraform 2> /dev/null)
TERRAFORM_VERSION:= "1.9.1"

ifeq ($(OS_X),true)
		TERRAFORM_MD5:= $(shell md5 -q `which terraform`)
		TERRAFORM_REQUIRED_MD5:= 6d531d45246ce7ccf62f5730194e98b2
else
		TERRAFORM_MD5:= $(shell md5sum - < `which terraform` | tr -d ' -')
		TERRAFORM_REQUIRED_MD5:= 07a8b1577a46abc4f2ce51a4d1119c03
endif

default:
	@echo "Creates a Terraform system from a template."
	@echo "The following commands are available:"
	@echo " - plan               : runs terraform plan for an environment"
	@echo " - apply              : runs terraform apply for an environment"
	@echo " - destroy            : will delete the entire project's infrastructure"

check:
	@echo "Checking Terraform version... expecting md5 of [${TERRAFORM_REQUIRED_MD5}], found [${TERRAFORM_MD5}]"
	@if [ "${TERRAFORM_MD5}" != "${TERRAFORM_REQUIRED_MD5}" ]; then echo "Please ensure you are running terraform ${TERRAFORM_VERSION}."; exit 1; fi
	@if [[ -d ".terraform" ]]; then rm -r .terraform; fi
	@if [[ -f ".terraform.lock.hcl" ]]; then rm .terraform.lock.hcl; fi

plan: check
	$(call check_defined, ENV, Please set the ENV to plan for. Values should be dev, sit, uat or prod)
	@terraform fmt

	@echo "Pulling the required modules..."
	@terraform get

	@terraform init  \
          	  -backend-config="hcl/$(value BACKEND).hcl"

	@echo 'Switching to the [$(value ENV)] environment ...'
	@terraform workspace select $(value ENV)

	@terraform plan  \
  	  -var-file="env_vars/$(value ENV).tfvars" \
  	  	-out plans/$(value ENV).plan

apply: check
	$(call check_defined, ENV, Please set the ENV to apply. Values should be dev, test, uat or prod)

	@echo 'Switching to the [$(value ENV)] environment ...'
	@terraform workspace select $(value ENV)

	@echo "Will be applying the following to [$(value ENV)] environment:"
	@terraform show -no-color plans/$(value ENV).plan

	@terraform apply plans/$(value ENV).plan
	@rm plans/$(value ENV).plan


destroy: check
	@echo "Switching to the [$(value ENV)] environment ..."
	@terraform workspace select $(value ENV)

	@echo "## 💥💥💥💥💥💥💥💥💥💥💥💥💥💥💥💥💥💥💥💥💥💥💥💥💥💥💥💥💥💥💥💥💥💥💥💥💥💥💥 ##"
	@echo "Are you really sure you want to completely destroy [$(value ENV)] environment ?"
	@echo "## 💥💥💥💥💥💥💥💥💥💥💥💥💥💥💥💥💥💥💥💥💥💥💥💥💥💥💥💥💥💥💥💥💥💥💥💥💥💥💥 ##"
	@read -p "Press enter to continue"
	@terraform destroy \
		-var-file="env_vars/$(value ENV).tfvars"


# Check that given variables are set and all have non-empty values,
# die with an error otherwise.
#
# Params:
#   1. Variable name(s) to sit.
#   2. (optional) Error message to print.
check_defined = \
    $(strip $(foreach 1,$1, \
        $(call __check_defined,$1,$(strip $(value 2)))))
__check_defined = \
    $(if $(value $1),, \
      $(error Undefined $1$(if $2, ($2))))
