

import Foundation
import NIO


class ProxySourceInBound : ChannelInboundHandler {
	
	public typealias InboundIn   = ByteBuffer
	public typealias OutboundOut = ByteBuffer


	private let group    : MultiThreadedEventLoopGroup
	private let target   : HostInfo
	private var channels : [ObjectIdentifier : Channel] = [:]
	
	private let channelsSyncQueue = DispatchQueue(label: "channelsQueue")
	
	let targetIntercept : [ChannelHandler]
	
	public init(group: MultiThreadedEventLoopGroup, target: HostInfo, targetIntercept:[ChannelHandler] = []) {
		self.group           = group
		self.target          = target
		self.targetIntercept = targetIntercept
	}


	

	public func channelActive(context: ChannelHandlerContext) {
		
		let source = context.channel
		let id     = ObjectIdentifier(context.channel)

		let bootstrap = ClientBootstrap(group: self.group)
    	.channelOption(ChannelOptions.socket(SocketOptionLevel(SOL_SOCKET), SO_REUSEADDR), value: 1)
    	.channelInitializer { channel in
				channel.pipeline.addHandlers(self.targetIntercept).flatMap{ _ in
					channel.pipeline.addHandler( ProxyTargetInBound(group: self.group, source: source) )
				}
    	}


		let completion = { (result: Result<Channel,Error>) in
			switch result {
				case .failure(let error)   : print(error)
				
				case .success(let channel) :
					self.channelsSyncQueue.async {
						self.channels[id] = channel
					}
			}
		}
		
		
		switch target {
			case .ip(host: let host, port: let port):
				bootstrap.connect(host: host, port: port).whenComplete(completion)
			
			case .unixDomainSocket(path: let path):
				bootstrap.connect(unixDomainSocketPath: path).whenComplete(completion)
		}
		
	}




	public func channelRead(context: ChannelHandlerContext, data: NIOAny) {
		
		let id = ObjectIdentifier(context.channel)
		
		channelsSyncQueue.async {
			if let channel = self.channels[id] {
				_ = channel.writeAndFlush(data)
			}
		}
	}




	public func channelInactive(context: ChannelHandlerContext) {
		
		let id = ObjectIdentifier(context.channel)
		
		self.channelsSyncQueue.async {
			if let channel = self.channels[id] {
				_ = channel.close()
			}
		}
	}
	


}
