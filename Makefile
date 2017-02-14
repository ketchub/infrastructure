TERRAFORM_RELEASE = terraform_0.8.0_darwin_amd64.zip
TERRAFORM_DOWNLOAD_URL = "https://releases.hashicorp.com/terraform/0.8.0/$(TERRAFORM_RELEASE)"

TERRAFORM_EXEC = "./terraform"
TERRAFORM_ENV = "env-dev"
TERRAFORM_STATE_PATH = "./$(TERRAFORM_ENV)/terraform.tfstate"

SHELL = /bin/bash

export TF_VAR_digital_ocean_token ?= ""

.PHONY: install-terraform
install-terraform:
ifneq ($(wildcard ./terraform),)
	@echo "Terraform installed and ready..."
else
	wget $(TERRAFORM_DOWNLOAD_URL)
	unzip $(PWD)/$(TERRAFORM_RELEASE) -d $(PWD)
	rm ./$(TERRAFORM_RELEASE)
endif

.PHONY: ensure-modules
ensure-modules:
	@echo "Ensuring modules synced..."
	@$(TERRAFORM_EXEC) get $(TERRAFORM_ENV)

.PHONY: setup
setup: install-terraform ensure-modules
	@echo "Setup OK"

.PHONY: apply
apply: setup
	@$(TERRAFORM_EXEC) apply \
	-state=$(TERRAFORM_STATE_PATH) \
	$(TERRAFORM_ENV)

.PHONY: validate
validate: setup
	@$(TERRAFORM_EXEC) validate $(TERRAFORM_ENV); true
	@echo "Validation complete"

.PHONY: plan
plan: setup
	@$(TERRAFORM_EXEC) plan \
	-state=$(TERRAFORM_STATE_PATH) \
	$(TERRAFORM_ENV)

.PHONY: murder
murder: setup
	@$(TERRAFORM_EXEC) destroy \
	-state=$(TERRAFORM_STATE_PATH) \
	$(TERRAFORM_ENV)
