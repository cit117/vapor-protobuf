//
//  Extensions.swift
//  VaporProtobuf
//
//  Created by mechen on 2021/5/11.
//

import Vapor

public extension HTTPMediaType {
    static let proto = HTTPMediaType(type: "application", subType: "protobuf")
}
