import SwiftProtobuf
import Vapor

public struct Proto<T:Message>{
   public var message:T
}

extension Proto: ResponseEncodable,RequestDecodable {
    public static func decodeRequest(_ request: Request) -> EventLoopFuture<Proto<T>> {
        do {
            guard var buffer = request.body.data else {
                throw Abort.init(.badRequest,reason: "body为空")
            }
            let data = buffer.readData(length: buffer.readableBytes)!
            var result: Self
            if request.headers.contentType == .proto {
                result = try .init(message: .init(serializedData: data))
            } else {
                result = try .init(message: .init(jsonUTF8Data: data))
            }
            return request.eventLoop.makeSucceededFuture(result)
        }catch  {
           return request.eventLoop.makeFailedFuture(error)
       }
    }
    public func encodeResponse(for request: Request) -> EventLoopFuture<Response> {
        let response = Response()
        do {
            var data:Data
            if request.headers.contentType == .proto {
                data = try message.serializedData()
                response.headers.contentType = .proto
            } else {
                data = try message.jsonUTF8Data()
                response.headers.contentType = .json
            }
            response.body =  .init(data: data)
            return request.eventLoop.makeSucceededFuture(response)
        } catch  {
            return request.eventLoop.makeFailedFuture(error)
        }
    }
}
