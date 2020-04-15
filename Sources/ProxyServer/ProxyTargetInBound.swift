


import Foundation
import NIO



class ProxyTargetInBound : ChannelInboundHandler {
	
	public typealias InboundIn   = ByteBuffer
	public typealias OutboundOut = ByteBuffer


	let group       : MultiThreadedEventLoopGroup
	let source      : Channel
	let transformer : ProxyTransform
	
	public init(group: MultiThreadedEventLoopGroup, source: Channel, transform: ProxyTransform = VoidTransform()) {
		self.group       = group
		self.source      = source
		self.transformer = transform
	}
	
	public func channelRead(context: ChannelHandlerContext, data: NIOAny) {
		_ = source.writeAndFlush(transformer.transform(data: data))
	}
	
	public func channelInactive(context: ChannelHandlerContext) {
		_ = source.close()
	}
}


