import Foundation
import NIO


import Foundation
import NIO


public enum HostInfo {
	case ip(host: String, port: Int)
	case unixDomainSocket(path: String)
}


public class ProxyServer {
	
	let group  : MultiThreadedEventLoopGroup
	let source : HostInfo
	let target : HostInfo
	
	let sourceTransform: ProxyTransform
	let targetTransform: ProxyTransform
	
	
	init(source: HostInfo, target: HostInfo, sourceTransform: ProxyTransform = VoidTransform(), targetTransform: ProxyTransform = VoidTransform(), group: MultiThreadedEventLoopGroup = MultiThreadedEventLoopGroup(numberOfThreads: System.coreCount)) {
		self.source          = source
		self.target          = target
		self.sourceTransform = sourceTransform
		self.targetTransform = targetTransform
		self.group           = group
	}
	
	
	
	
	func start(then complete: @escaping (Result<Void,Error>) -> Void) {
		
		let bootstrap = ServerBootstrap(group: group)
			.serverChannelOption(ChannelOptions.backlog, value: 256)
			.serverChannelOption(ChannelOptions.socket(SocketOptionLevel(SOL_SOCKET), SO_REUSEADDR), value: 1)
			.childChannelInitializer { channel in
				channel.pipeline.addHandler(ProxySourceInBound(group: self.group, target: self.target, sourceTransform: self.sourceTransform, targetTransform: self.targetTransform))
			}
			.childChannelOption(ChannelOptions.socket(SocketOptionLevel(SOL_SOCKET), SO_REUSEADDR), value: 1)
			.childChannelOption(ChannelOptions.maxMessagesPerRead, value: 16)
			.childChannelOption(ChannelOptions.recvAllocator, value: AdaptiveRecvByteBufferAllocator())

		
		let completion = { (result: Result<Channel,Error>) in
			switch result {
				case .failure(let error): complete(.failure(error))
				case .success           : complete(.success(()))
			}
		}
		
		switch source {
			case .ip(host: let host, port: let port): bootstrap.bind(host: host, port: port).whenComplete(completion)
			case .unixDomainSocket(path: let path)  : bootstrap.bind(unixDomainSocketPath: path).whenComplete(completion)
		}
		
	}
	
}
