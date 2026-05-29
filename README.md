\# 🛠️ Sistema de Despliegue de Servicios Telemáticos



\## 📝 Descripción

Este proyecto consiste en un servicio telemático automatizado a nivel de producción. Emplea \*\*Terraform\*\* para levantar la arquitectura de red y cómputo en \*\*AWS\*\*, y utiliza \*\*Docker Compose\*\* para el empaquetamiento y persistencia continua de una aplicación web en Python.



\## 🚀 Guía de Despliegue



\### Paso 1: Inicializar Infraestructura (Localmente)

Ejecute los siguientes comandos en su computadora con sus credenciales de AWS activas:

```bash

terraform init

terraform plan

terraform apply -auto-approve

