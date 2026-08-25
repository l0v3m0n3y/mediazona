# mediazona
web api for zona.media 
# main
```swift
import Foundation
import mediazona
let client = Mediazona()

do {
    let content = try await client.getInfographics()
    print(content)
} catch {
    print("Error: \(error)")
}
```

# Launch (your script)
```
swift run
```
