[![Project Release](https://img.shields.io/badge/release-v2.0.0-blue.svg)](https://github.com/bonusbits/terraform_aws_orchestrator)
[![Circle CI](https://circleci.com/gh/bonusbits/terraform_aws_orchestrator/tree/master.svg?style=shield)](https://circleci.com/gh/bonusbits/terraform_aws_orchestrator/tree/master)
[![GitHub issues](https://img.shields.io/github/issues/bonusbits/terraform_aws_orchestrator.svg)](https://github.com/bonusbits/terraform_aws_orchestrator/issues)

# Purpose
Various Terraform Modules, configurations and tfvar examples. Rake tasks are used from the root directory to simplify usage of the project. Mostly this project is a good central location for real-world Terraform references, but very functional as well.

## Notes
 * The project is still under heavy construction, but the vpc and include_vpc/ec2_asg_web environments work. 
 * The asg_cf can have issues if the CloudFormation doesn't launch right the first time. Simply delete the CF Stack in AWS Console as a workaround. Eventually I figure out how to replicate the logic in the small CloudFormation Template into Terraform Code. Just needed a starting point for now.

# Usage
Rake tasks have been setup to make the usage easier for developers and for use with a CI.

## Prerequisites
* Terraform (0.12.18+)
* Ruby (2.6.5) - Included in ChefDK (4.5.0)
* Rake (12.3.2) - Included in ChefDK (4.5.0)

## Create Project Var Yaml
Create or pick an example project variable file in the **vars** directory. This is used by rake tasks to operate against our project and environment.

#### Tips
* TF_WORKSPACE env var value must equal the filename of the ```vars/*.yml```
* Filename has to be all lowercase and snake case.

| Variables | Example | Description |
| :--- | :--- | :--- |
| tf_root_path | environments/vpc | Where the main.tf, outputs.tf and variables.tf files are that pick which modules to use.
| tf_var_file | environments/vpc/example/dev.tfvars | Specific Terraform variables that are fed to modules.
| keys_path | environments/vpc/example/secrets | SSH Key path

## Set Environment Variables
Having the AWS Region as part of the name is so the workspace that is created includes the region name. That way if we use the same tfvars but just make different yml files that match the workspace name we won't end up with conflicting workspace names.
1. ```TF_WORKSPACE``` (Required) to the filename of the project variables yaml ```vars/*.yml```<br>
    ```bash
    # ./vars/vpc_dev.yml
    export TF_WORKSPACE="vpc_usw2_dev"
    ```
    **OR**
    ```bash
    TF_WORKSPACE="vpc_usw2_dev" rake deploy:tf
    ```

1. ```AWS_REGION``` (Required) This is what is used to actually set which region to communicate with<br>
    ```bash
    export AWS_REGION="vpc_usw2_dev"
    ```
    **OR**
    ```bash
    AWS_REGION="us-west-2" rake deploy:tf
    ```


## List Rake Tasks
```bash
rake -T
```

## Deploy Preparations - Init & Plan (Optional)
```bash
rake deploy:tf_prep
```
**OR**
```bash
rake tfp
```

## Deploy Environment
```bash
rake deploy:tf
```
**OR**
```bash
rake dtf
```

## Undeploy Environment
```bash
rake undeploy:tf
```
**OR**
```bash
rake utf
```

#### Rake Task List
| Task | Description |
| :--- | :--- |
| apply                             | Alias (terraform:apply) |
| console                           | Alias (terraform:console) |
| default                           | Alias (style:ruby:auto_correct) |
| deploy:predefined:demo_usw1_dev   | Deploy Demo US-West-1 DEV |
| deploy:predefined:demo_usw1_prd   | Deploy Demo US-West-1 PRD |
| deploy:predefined:demo_usw2_dev   | Deploy Demo US-West-2 DEV |
| deploy:predefined:demo_usw2_prd   | Deploy Demo US-West-2 PRD |
| deploy:tf                         | Deploy Environment Based on environment variables |
| deploy:tf_prep                    | Create SSH Keys, Run Terraform Init & Plan |
| destroy                           | Alias (terraform:destroy) |
| dtf                               | Alias (deploy:tf) |
| init                              | Alias (terraform:init) |
| plan                              | Alias (terraform:plan) |
| prep                              | Alias (deploy:tf_prep) |
| providers                         | Alias (terraform:providers) |
| refresh                           | Alias (terraform:refresh) |
| secrets:generate_ssh_keys         | Generate AWS SSH Keys that Terraform Can Upload to AWS |
| show                              | Alias (terraform:show) |
| show_vars                         | Show Project Variables from YAML vars Files |
| style:ruby                        | RuboCop |
| style:ruby:auto_correct           | Auto-correct RuboCop offenses |
| style_tests                       | Alias (style:ruby) |
| terraform:apply                   | Run Terraform Apply |
| terraform:console                 | Run Terraform Console |
| terraform:destroy                 | Run Terraform Destroy |
| terraform:init                    | Run Terraform Initialization |
| terraform:init_upgrade            | Upgrade Terraform Providers |
| terraform:plan                    | Run Terraform Plan |
| terraform:providers               | Display Terraform Providers |
| terraform:refresh                 | Refresh Terraform State |
| terraform:show                    | Show Terraform State |
| terraform:validate                | Validate Terraform Configurations |
| terraform:workspaces              | Display Terrafrom Workspaces |
| undeploy:predefined:demo_usw1_dev | Deploy Demo US-West-1 DEV |
| undeploy:predefined:demo_usw1_prd | Deploy Demo US-West-1 PRD |
| undeploy:predefined:demo_usw2_dev | Deploy Demo US-West-2 DEV |
| undeploy:predefined:demo_usw2_prd | Deploy Demo US-West-2 PRD |
| undeploy:tf                       | Delete Environment Based on environment variables |
| utf                               | Alias (undeploy:tf) |
| workspaces                        | Alias (terraform:workspaces) |