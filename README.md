# ProxyServer

A super simple TCP or UNIX Domain socket proxy using NIO 


```swift
let target = HostInfo.ip(host: "127.0.0.1", port: 9999)
let source = HostInfo.ip(host: "127.0.0.1", port: 9998)
let proxy  = ProxyServer(source: source, target: target)

proxy.start { result in
	switch result {
		case .failure(let error) : print("failed with error : \(error)")
		case .success            : print("proxying : \(source) --> \(target)")
	}
}

// If you are in a command line app
RunLoop.main.run()

```

You probably don't need this. But hey, code is social or something and I need the practice.
