
import Foundation
import NIO

public protocol ProxyTransform {
	func transform(channelId: ObjectIdentifier, data: NIOAny) -> NIOAny
}

public class VoidTransform : ProxyTransform {
	public init() {}
	public func transform(channelId: ObjectIdentifier, data: NIOAny) -> NIOAny { data }
}

