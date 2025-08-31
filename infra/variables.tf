variable "project"  { description = "Nom court du projet"; type = string; default = "demo" }
variable "location" { description = "Région Azure";       type = string; default = "westeurope" }
variable "tags"     { description = "Tags communs";       type = map(string); default = { env = "dev", owner = "gha-terraform" } }
