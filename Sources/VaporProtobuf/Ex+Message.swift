//
//  Ex+Message.swift
//  VaporProtobuf
//
//  Created by mechen on 2021/5/11.
//

import SwiftProtobuf

public extension Message {
    mutating func beforeEncode() throws { }
    mutating func afterDecode() throws { }
}
