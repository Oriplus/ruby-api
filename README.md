# Ruby Rack API

Esta es una API diseñada para gestionar productos una vez estando autenticado. Se ha construido en Rack Ruby y utiliza JWT para la autenticación.

## Login

{APP_URL}/v1/users/login

Enviando en el body las credenciales para la autenticación
```
{
    "user": "admin",
    "password": "test123"
}
```

## Gestión de productos

Una vez logueado usar el token recibido e incluirlo en el encabezado como Authorization Bearer Token para:

* POST {APP_URL}/v1/products: Crear productos, enviando el en el body el nombre del producto
```
{
    "name" : "Xbox S"
}
```
* GET {APP_URL}/v1/products: Ver Lista de Productos
* GET POST {APP_URL}/v1/products/{product_id}: Ver Producto individualmente

## Instalación

Crear archivo .env tomando como ejemplo .env.example

```
docker-compose up app
```

## Test

```
docker-compose run --rm test
```
## Especificación de OpenAPI.

```
{APP_URL}/openapi.yaml
```

