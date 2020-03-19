## CHANGE LOG

## 2.0.0 - 00/00/2020 - Levon Becker
* Replaced VPC module with custom
* Moved rake variables to vars/rake
* Moved secrets to vars/secrets
* Moved all tfvars to vars/tf (Centralizing all variables into vars)
* Improved a lot of logic in rake tasks
    * A workaround to terraform conflicts is to cd to the role folder for init

## 1.0.0 - 01/30/2020 - Levon Becker
* Initial Commit