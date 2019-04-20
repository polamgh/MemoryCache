# MemoryCache
A lightweight, pure-Swift library for downloading and caching images from the web.


Cache and download image from web
```swift
let imageView = CustomUIImage(frame: self.view.bounds)
imageView.cacheImage(urlString: dataSource[indexPath.row].urls.regular)
```

Cache and download json from web 
```swift
DataManager().loadJson(urlString: "http://pastebin.com/raw/wgkJgazE") { (json, link, error) in
   if error == nil {
       DispatchQueue.main.async {
           self.txtResult.text = "Result : \(json!)"
       }
   }
}
```
Add cache extension for download and cache
```swift
import MemoryCache
extension String : DataConvertible, DataRepresentable {
    
    public typealias Result = String

    public static func convertFromData(_ data: Data) -> Result? {
        let string = NSString(data: data, encoding: String.Encoding.utf8.rawValue)
        return string as Result?
    }

    public func asData() -> Data! {
        return self.data(using: String.Encoding.utf8)
    }
    
}
```
