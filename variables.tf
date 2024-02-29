# Step 8 - Add variables
variable "instance_type" {
  default     = "t2.micro"
  description = "Type of the instance"
  type        = string
}

# Step 8 - Add variables
variable "default_tags" {
  default = {
    "Owner" = "jona"
    "App"   = "Web"
  }
  type        = map(any)
  description = "Default tags to be appliad to all AWS resources"
}

# Step 8 - Add variables
variable "prefix" {
  default     = "clo835"
  type        = string
  description = "Name prefix"
}
