//
//  Convert.swift
//  VaporProtobuf
//
//  Created by mechen on 2021/5/11.
//

import Vapor
import SwiftProtobuf

struct Convert {
   static func decode<M>(m:M,contentType: HTTPMediaType) throws -> Data where M : Message {
        switch contentType {
        case .json:
            return try m.jsonUTF8Data()
        case .proto:
            return try m.serializedData()
        default:
            throw Abort.init(.unsupportedMediaType)
        }
    }

   static func encode<M>(_ decodable: M.Type, from body: ByteBuffer, contentType: HTTPMediaType) throws -> M where M : Message {
        let data = body.getData(at: body.readerIndex, length: body.readableBytes) ?? Data()
        switch contentType {
        case .json:
            return try decodable.init(jsonUTF8Data: data)
        case .proto:
            return try decodable.init(serializedData: data)
        default:
            throw Abort.init(.unsupportedMediaType)
        }
    }
}

