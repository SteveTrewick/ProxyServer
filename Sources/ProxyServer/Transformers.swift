
import Foundation
import NIO

protocol ProxyTransform {
	func transform(data: NIOAny) -> NIOAny
}

class VoidTransform : ProxyTransform {
	func transform(data: NIOAny) -> NIOAny { data }
}

