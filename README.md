# Monitoring VM

This project is an example VM defined using [`Terraform`](https://www.terraform.io/) in [CSC's](https://csc.fi/) [Pouta](https://pouta.csc.fi/) service.
[Pouta](https://pouta.csc.fi/) uses [openstack](https://www.openstack.org/) on the backend, therefore, this example uses [openstack provider](https://registry.terraform.io/providers/terraform-provider-openstack/openstack/latest/docs) for `Terraform`.

## Requirements

- [`Terraform`](https://www.terraform.io/)
- git-crypt if you are the lucky one to actually deploy everything in this repository

## Installation

To actually use everything included here, after cloning the repository unlock the secrets with

    -> git-crypt unlock

If you are not a collaborator but want to test things:

- replace `secrets/setup.sh` with a script you want to run after deployment (or an empty file for a clean test).
- replace `secrets/public_keys` with a file containing you public ssh key, or an empty file if `~/.ssh/id_rsa.pub` is the only key you want to use.

For clean environment on the backend, instance name is defined using an included script `set-name.sh`.
`Swift` backend doesn't allow to just use variables for the backend file name, that is why we need to define it before executing `Terraform`.

    -> ./set-name.sh kitten
    Call: terraform init [-reconfigure] -backend-config=tf-backend.tfvars
    -> terraform init -reconfigure -backend-config=tf-backend.tfvars

    Initializing the backend...

    Successfully configured the backend "swift"! Terraform will automatically
    use this backend unless the backend configuration changes.

    Initializing provider plugins...
    - Reusing previous version of hashicorp/null from the dependency lock file
    - Reusing previous version of terraform-provider-openstack/openstack from the dependency lock file
    - Using previously-installed hashicorp/null v3.1.0
    - Using previously-installed terraform-provider-openstack/openstack v1.35.0

    Terraform has been successfully initialized!

    You may now begin working with Terraform. Try running "terraform plan" to see
    any changes that are required for your infrastructure. All Terraform commands
    should now work.

    If you ever set or change modules or backend configuration for Terraform,
    rerun this command to reinitialize your working directory. If you forget, other
    commands will detect it and remind you to do so if necessary.
    -> terraform apply

At the end you should see the address of your new VM like this

    Outputs:

    address = "128.214.254.127"
