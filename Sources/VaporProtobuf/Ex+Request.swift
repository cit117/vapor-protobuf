//
//  Ex+Request.swift
//  VaporProtobuf
//
//  Created by mechen on 2021/5/11.
//

import Vapor
import SwiftProtobuf

extension Request {
    private struct _PbContainer: ProtoBufContainer {
        mutating func encode<M>(_ encodable: M, using contentType: HTTPMediaType) throws where M : Message {
            var body = ByteBufferAllocator().buffer(capacity: 0)
            let data = try Convert.decode(m: encodable, contentType: contentType)
            body.writeData(data)
        }   
        func decode<M>(_ decodable: M.Type, using contentType: HTTPMediaType) throws -> M where M : Message {
            guard let body = self.request.body.data else {
                self.request.logger.debug("Request body is empty. If you're trying to stream the body, decoding streaming bodies not supported")
                throw Abort(.unprocessableEntity)
            }
            return try Convert.encode(M.self, from: body, contentType: contentType)
        }
        
        let request: Request
        var contentType: HTTPMediaType? {
            return self.request.headers.contentType
        }
    }
    
    public var pb: ProtoBufContainer {
        get {
            return _PbContainer.init(request: self)
        }
        set {
            
        }
    }
}
