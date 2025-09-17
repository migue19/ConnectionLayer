# ConnectionLayer
Una simple capa de conexión para realizar peticiones HTTP en Swift.

# Instalación

## Podfile
Agregar el modulo en el Podfile
```ruby
platform :ios, '13.0'
use_frameworks!

target 'TuApp' do
  pod 'ConnectionLayer'
end
```
## Instalar
Ejecutar el comando en terminal
```bash
pod install
```

## Uso rápido
Para utilizar la capa de conexión, simplemente importa el módulo y llama al método `connectionRequest` con los parámetros necesarios.
Importar el módulo
```swift
import ConnectionLayer
```
GET con parámetros
```swift
let client = ConnectionLayer(time: 30, isDebug: true)

client.connectionRequest(
    url: "https://api.ejemplo.com/users",
    method: .get,
    headers: nil,
    parameters: ["page": 1, "q": "miguel"]
) { data, error in
    if let error = error {
        print("Error:", error)
        return
    }
    guard let data = data else {
        print("Sin datos")
        return
    }
    // Decodifica si esperas JSON
    let obj = try? JSONSerialization.jsonObject(with: data)
    print("OK:", obj ?? "bytes=\(data.count)")
}
```
POST con cuerpo JSON
```swift
let payload: [String: Any] = [
    "name": "Miguel",
    "email": "miguel@ejemplo.com",
    "active": true
]

client.connectionRequest(
    url: "https://api.ejemplo.com/users",
    method: .post,
    headers: ["Authorization": "Bearer TOKEN"],
    parameters: payload
) { data, error in
    // Manejo igual al ejemplo anterior
}
```
POST Subida de binarios / body Data
```swift
let imageData: Data = ... // PNG/JPEG/etc.

client.connectionRequest(
    url: "https://api.ejemplo.com/upload",
    method: .post,
    headers: ["Content-Type": "application/octet-stream"],
    data: imageData
) { data, error, status in
    print("status =", status as Any, "error =", error as Any)
}
```
Cabeceras personalizadas
```swift
let headers: HTTPHeaders = [
    "Authorization": "Bearer TOKEN",
    "Accept-Language": "es-MX"
]

client.connectionRequest(
    url: "https://api.ejemplo.com/secure",
    method: .get,
    headers: headers,
    parameters: nil
) { data, error in
    // ...
}
```
## API

**Inicialización**

```swift
init()
init(time: Int = 180, isDebug: Bool = true, session: URLSession? = nil)
```

* `time`: timeout en segundos para request y resource.
* `isDebug`: habilita logs útiles por consola.
* `session`: inyección opcional de `URLSession` (para tests o configuración avanzada).

**Requests (closures)**

```swift
// JSON params (GET -> query string | POST/PUT/PATCH -> HTTP body)
func connectionRequest(
  url: String,
  method: HTTPMethod,
  headers: HTTPHeaders?,
  parameters: [String: Any]?,
  closure: @escaping (Data?, Error?) -> Void
)

// Body binario (ignora body si method == .get); devuelve statusCode
func connectionRequest(
  url: String,
  method: HTTPMethod,
  headers: HTTPHeaders?,
  data: Data?,
  closure: @escaping (Data?, Error?, Int?) -> Void
)
```
## Manejo de errores y *status codes*

* **Transporte (red/cancelación/timeouts)**: devuelve el `Error` del sistema (`URLError`, etc.).
* **Respuesta no HTTP**: `URLError(.badServerResponse)`.
* **2xx**: éxito; en el overload con `status`, se devuelve el **código real** (incl. `204`).
* **4xx**: `NSError(domain: "HTTPClientError", code: status, userInfo: ...)`.
* **5xx**: `NSError(domain: "HTTPServerError", code: status, userInfo: ...)`.
* **Otro**: `NSError(domain: "HTTPUnexpectedStatus", code: status, userInfo: ...)`.

> Si el servidor responde `204 No Content`, `data` puede venir `nil` (correcto).

## Registro (*logging*)

Con `isDebug = true`, se imprime:

* URL, método y *headers*.
* Body (si es JSON, se intenta parsear; si no, se indican bytes o texto truncado).
* `statusCode`.
* Tamaño/JSON de respuesta cuando aplica.

> Logs pensados para desarrollo: evita *dump* de binarios grandes y ayuda a depurar rápido.

## Buenas prácticas

* Para JSON: añade `Accept`/`Content-Type` solo si aplica. El *layer* ya pone valores por defecto en llamadas con `parameters` no `nil` y método no-`GET`.

## Author
Miguel Mexicano Herrera, miguelmexicano18@gmail.com
