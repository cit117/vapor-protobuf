//
//  Ex+Response.swift
//  VaporProtobuf
//
//  Created by mechen on 2021/5/11.
//

import Vapor
import SwiftProtobuf

extension Response {
    private struct _PbContainer: ProtoBufContainer {
        mutating func encode<M>(_ encodable: M, using contentType: HTTPMediaType) throws where M : Message {
            var body = ByteBufferAllocator().buffer(capacity: 0)
            let data = try Convert.decode(m: encodable, contentType: contentType)
            body.writeData(data)
            self.response.body = .init(buffer: body)  
        }
        
        func decode<M>(_ decodable: M.Type, using contentType: HTTPMediaType) throws -> M where M : Message {
            guard let body = self.response.body.buffer else {
                throw Abort(.unprocessableEntity)
            }
            return try Convert.encode(M.self, from: body, contentType: contentType)
        }
        
        
        let response: Response
        var contentType: HTTPMediaType? {
            return self.response.headers.contentType
        }
    }
    
    public var pb: ProtoBufContainer {
        get {
            return _PbContainer.init(response: self)
        }
        set {
            
        }
    }
}

