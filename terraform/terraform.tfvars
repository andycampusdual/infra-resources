# Asignación de valores a las variables

aws_region    = "eu-west-3"                             # Región (puede ser configurada también en variables.tf si es fija)###
//bucket_name   = "proyect-1-stb-devops-bucket-terraform-prueba" # Nombre del bucket S3 (asegúrate de que sea único)
#ami_id        = "ami-0574a94188d1b84a1"  
#ami_id= "ami-07db896e164bc4476"               # Aquí pones la AMI de ubuntu 
ami_id= "ami-07db896e164bc4476"
instance_type = "t2.micro"                              # Tipo de instancia, si deseas cambiarlo
acl           =  "public-read"
db_username   = "admin"
db_password   = "adminnoadminhou"
create_replica= false
rds_replicas  = 1
vpc_cidr = "10.17.0.0/16"
private_key_path = "~/.ssh/id_rsa" # Ruta al archivo .pem de la clave privada
tag_value="agd"
public_key_path="~/.ssh/id_rsa.pub"
module_path="../modules/wordpress/"
