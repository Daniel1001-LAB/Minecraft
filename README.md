# Minecraft

## Recursos necesarios para el despligue del servidor

Es necesario que dispongas de los siguientes recursos:
- Linux
- Terraform
- Ansible
- Docker (opcional)
- Terraform Cloud (opcional)

## Pasos a seguir

Para desplegar la infraestructura y aprovisionar el servidor, es necesario exportar previamente las siguientes variables de entorno:

# Terraform

## Terraform Cloud
Para guardar el estado en el que se encuentra el despliegue, puedes utilizar **Terraform Cloud**. Para ello, debes crear un fichero en *terraform/credentials.tfrc* con el siguiente contenido:

```
credentials "app.terraform.io" {
  token = "<TERRAFORM-CLOUD-TOKEN>"
}
```

Para que al inicializar terraform lea este fichero, debes exportar la siguiente variable de entorno:

```
export TF_CLI_CONFIG_FILE="credentials.tfrc"
```

Y también elegir un workspace (en caso de tenerlo ya creado):

```
export TF_WORKSPACE="<TERRAFORM-CLOUD-WORKSTATION>"
```

Si no quieres utilizar Terraform Cloud, no es necesario realizar ninguno de estos pasos, pero has de eliminar el fichero *terraform/00_workspace.tf*.

## Cloud (Hetzner)

### Conectar con la API de Hetzner

```
export TF_VAR_hcloud_token="<HETZNER-TOKEN>"
```

## Claves SSH pública y privada para la instancia

### Importar clave pública

```
export TF_VAR_ssh_private_key="<SSH-PRIVATE-PATH>"
```

### Importar clave privada

Se puede hacer de dos formas:

1- Utilizando el agente ssh:

```
eval $(ssh-agent)
ssh-add ~/.ssh/mineway.pk
```

2- Utilizando la clave privada:

```
export TF_VAR_ssh_public_key="<SSH-PUBLIC-PATH>"
```

## DDNS (Dynu)

### Usuario, contraseña y host (previamente creado) de Dynu

```
export TF_VAR_ddns_username="<DYNU-USERNAME>"

export TF_VAR_ddns_password="<DYNU-PASSWORD>"

export TF_VAR_ddns_hostname="<DYNU-URL>"
```

## Instancia

### Hostname de la instancia

```
export TF_VAR_hostname="<SERVER-NAME>"
```

# Ansible

## Clave SSH privada para conectarse a la instancia

Se puede hacer de dos formas:

1- Utilizando el agente ssh:

```
eval $(ssh-agent)
ssh-add <SSH-PRIVATE-PATH>
```

2- Modificando el fichero *ansible/variables.yml*

```
ansible_ssh_private_key_file: <SSH-PRIVATE-PATH>
```

## Variables de entorno

Para modificar las opciones del servidor de Minecraft, hay que modificar las variables de entorno que se encuentran del fichero *ansible/variables.yml* en el apartado de **Minecraft variables**.

# Minecraft

## Mods
Si quieres añadir mods a tu servidor de Minecraft, debes haber configurado previamente el tipo de servidor a *forge* y añadir los ficheros *.jar* en la variable de diccionario de ansible en *ansible/variables.yml*

*En este caso, se añade por defecto un fichero de configuración extra para el mod de voz*

Para utilizar los mods en tu cliente debes tener instalado el cliente **forge** y añadir **los mismos** ficheros *.jar* en el directorio *%APPDATA%/.minecraft/mods* de tu equipo.

# Docker

Si quieres probar el servidor en tu equipo local, puedes utilizar el contenedor de Docker que se encuentra en el directorio *docker/minecraft*.

Copia el fichero .env.example del directorio *deployments* a .env y modifica las variables de entorno que se encuentran en el fichero.

```
cp docker/.env.example docker/.env
```

Una vez tengas todas las variables de entorno correctamente, puedes ejecutar el contenedor de Docker:

```
cd docker
docker-compose up -d
```

## Mods

Para añadir mods en tu servidor local, al igual que en el servidor, debes añadir los ficheros *.jar* a la carpeta *mods* en el directorio *docker/data/mods* y reiniciar el contenedor.

```
cd docker
docker-compose restart
```
o
```
docker restart minecraft
```

## Desplegar infraestructura

Una vez hayas realizado todos lo pasos previos, puedes ejecutar el script de despliegue de la infraestructura con el siguiente comando:

Para comprobar como quedará la infraestructura una vez desplegada:
```
cd terraform
terraform plan
```

Y si queremos desplegarla:
```
cd terraform
terraform apply
```

También podemos guardar el plan en un fichero para ejecutarlo y que siempre mantenga el estado de la infraestructura:
```
cd terraform
terraform plan -out <nombre-fichero>
terraform apply <nombre-fichero>
```
