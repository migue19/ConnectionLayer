# ConnectionLayer

## Novedades (Ascendente)
**1.0.2**-*17 de Septiembre 2025*
    - Se corrige el log para imprimir los detalles de la peticion en modo debug.
    - Se corrige el error cuando el response no es HTTPURLResponse.
    - Se validan correntamente los estatus de exito 200...299.
    - Se agrega logica para 400's y 500's.
    - Se actualiza el minimum deploy target a iOS 13.
    - Update README.md
**1.0.1**-*19 de Agosto 2025*
    - Se remplaza el retorno de una cadena de error por un `Error` opcional.
    - Se regresa un entero con el codigo de estatus.
**1.0.0**-*29 de Abril 2024*
    - Primer Version estable de la capa de conexión.
