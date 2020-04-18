


import Foundation
import NIO



class ProxyTargetInBound : ChannelInboundHandler {
	
	public typealias InboundIn   = ByteBuffer
	public typealias OutboundOut = ByteBuffer


	let group       : MultiThreadedEventLoopGroup
	let source      : Channel
	
	
	public init(group: MultiThreadedEventLoopGroup, source: Channel) {
		self.group       = group
		self.source      = source
	}
	
	public func channelRead(context: ChannelHandlerContext, data: NIOAny) {
		_ = source.writeAndFlush(data)
	}
	
	public func channelInactive(context: ChannelHandlerContext) {
		
		source.close(mode: .all, promise: nil)
	}
}


