//
//  MyDebugMiddleware.swift
//  ErrorsCore
//
//  Created by Ondrej Rafaj on 13/12/2017.
//

import Foundation
import Vapor


public final class UrlDebugMiddleware: Middleware {
    
    public func respond(to req: Request, chainingTo next: Responder) -> EventLoopFuture<Response> {
        if let env = try? Environment.detect(), env != .production {
            let method = req.method
            let path = req.url.path
            let query = req.url.query
            var reqString = "\(method) \(path)"
            if let q = query {
                reqString += "?\(q)"
            }
            req.logger.info(Logger.Message(stringLiteral: reqString))
        }
        return next.respond(to: req)
    }
    
    public init() { }
    
}
