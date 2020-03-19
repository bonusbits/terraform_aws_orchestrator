# Mapped
variable common {type = map(string)}
variable bastion {type = map(string)}
variable whitelists {type = map(map(string))}

# NOT USED (This Just to Stops Warnings)
variable alma_instances {type = map(map(string))}
variable backend_cache {type = map(string)}
variable backend_queue {type = map(string)}
variable backend_queue_secrets {type = map(string)}
variable bitbucket_secrets {type = map(string)}
variable certificates {type = map(map(string))}
variable file_template_secrets {type = map(string)}
variable frontend_cache {type = map(string)}
variable mongodb {type = map(string)}
variable mongodb_secrets {type = map(string)}
variable network {type = map(string)}
variable reporting_secrets {type = map(string)}
variable security_groups {type = map(string)}
