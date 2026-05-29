# proyecto-final-telematica
Ian Isaza Bermudez_000260757 
Proyecto Final: Servicio Telemático de Producción
Descripción del Proyecto
Este proyecto consiste en el despliegue de una aplicación web basada en Flask dentro de una instancia de AWS EC2, utilizando Docker para la contenedorización y orquestación del servicio. El objetivo principal fue asegurar la disponibilidad de la aplicación mediante la configuración correcta de la infraestructura de red en la nube (Security Groups) y la gestión de procesos de Docker.

Arquitectura de la Solución
El servicio sigue un flujo de tráfico directo:

Cliente: Accede a través de la IP pública de AWS (3.83.105.229) por el puerto 5000.

AWS Security Group: Configurado para permitir tráfico entrante TCP en el puerto 5000 (Anywhere-IPv4).

Docker Engine: Ejecuta un contenedor con una imagen de Python 3.10, la cual sirve la aplicación Flask en el puerto interno 5000, mapeado directamente al puerto 5000 del host.

Pasos Realizados (Bitácora de Despliegue)
Para lograr el despliegue exitoso, se ejecutaron las siguientes etapas:

Configuración de Infraestructura: Ajuste de las reglas de entrada (Inbound Rules) en el Security Group de AWS para habilitar el acceso al puerto 5000.

Corrección de Código: Depuración de errores de sintaxis en el archivo principal app.py que impedían el arranque del intérprete de Python.

Contenedorización:

Creación de un Dockerfile optimizado utilizando la imagen python:3.10-slim.

Instalación de dependencias (flask) y configuración del punto de entrada para el servicio.

Orquestación y Despliegue:

Resolución de conflictos de nombres de contenedores mediante la limpieza de procesos huérfanos.

Ejecución del contenedor en modo detached con política de reinicio automático (--restart always).

Validación de Red: Desactivación temporal de firewalls internos (ufw) y mapeo explícito de puertos para evitar rechazos de conexión (ERR_CONNECTION_REFUSED).

Evidencia de Funcionamiento
El servicio se encuentra actualmente en estado operativo bajo la IP:
http://3.83.105.229:5000

Estado del contenedor verificado mediante sudo docker ps con mapeo 0.0.0.0:5000->5000/tcp.
