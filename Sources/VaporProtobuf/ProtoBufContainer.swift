//
//  ProtoBufContainer.swift
//  VaporProtobuf
//
//  Created by mechen on 2021/5/11.
//

import SwiftProtobuf
import Vapor

public protocol ProtoBufContainer {
    var contentType: HTTPMediaType? { get }
    func decode<M>(_ decodable: M.Type,using contentType: HTTPMediaType) throws -> M where M:Message
    mutating func encode<M>(_ encodable: M,using contentType: HTTPMediaType) throws where M:Message
}

extension ProtoBufContainer {
    public func decode<M>(_ decodable: M.Type) throws -> Proto<M> where M:Message {
        try self.decode(M.self, as: .proto)
    }
    public func decode<M>(_ decodable: M.Type,as contentType: HTTPMediaType) throws -> Proto<M> where M:Message {
        var proto = try self.decode(M.self, using: contentType)
        try proto.afterDecode()
        return .init(message: proto)
    }
    public mutating func encode<M>(_ encodable: Proto<M>) throws where M:Message {
        try self.encode(encodable.message, using: .proto)
    }
    public mutating func encode<M>(_ encodable: Proto<M>,as contentType: HTTPMediaType) throws where M:Message {
        var encodable = encodable
        try encodable.message.beforeEncode()
        try self.encode(encodable.message, using: contentType)
    }
}
