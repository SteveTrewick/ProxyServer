
import Foundation
import NIO

public protocol ProxyTransform {
	func transform(data: NIOAny) -> NIOAny
}

public class VoidTransform : ProxyTransform {
	public init() {}
	public func transform(data: NIOAny) -> NIOAny { data }
}

