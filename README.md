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

## Example
Para utilizar la capa de conexión, simplemente importa el módulo y llama al método `connectionRequest` con los parámetros necesarios.

```swift
import ConnectionLayer  

func exampleConnectionLayer() {
    let request = LoginOauthRequest(provider: ProviderType.apple, token: token, device_type: .ios)
    let url = RunApi.Auth.socialOauth
    let connectionLayer = ConnectionLayer(timeOut: timeOut, isDebug: isDebug)
    connectionLayer.connectionRequest(url: url, method: .post, headers: RunApi.headers, data: request.toData) { [weak self] (data, error, statusCode) in
        guard let self = self else {
            debugPrint("self_not_found".localized)
            return
        }
        if let error = error {
            self.receiveError(message: error.localizedDescription)
            return
        }
        guard let data = data else {
            let error = "data_not_found".localized
            self.receiveError(message: error)
            return
        }
        print("Response: \(String(describing: data))")
    }
}

```


## Author
Miguel Mexicano Herrera, miguelmexicano18@gmail.com

