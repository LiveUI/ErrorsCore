//
//  ErrorsCoreMiddleware.swift
//  ErrorsCore
//
//  Created by Ondrej Rafaj on 12/12/2017.
//

import Foundation
import Async
import Debugging
import HTTP
import Service
import Vapor


public final class ErrorsCoreMiddleware: Middleware, Service {
    
    /// The environment to respect when presenting errors.
    let environment: Environment
    
    /// Log destination
    let log: Logger
    
    /// Create a new ErrorMiddleware for the supplied environment.
    public init(environment: Environment, log: Logger) {
        self.environment = environment
        self.log = log
    }
    
    /// See `Middleware.respond`
    public func respond(to req: Request, chainingTo next: Responder) throws -> Future<Response> {
        return try next.respond(to: req).catchMap { (error) -> (Response) in
            if let frontendError = error as? FrontendError {
                let response = try req.response.error(status: frontendError.status, error: frontendError.identifier, description: frontendError.reason)
                return response
            }
            else {
                let reason: String
                switch self.environment {
                case .production:
                    if let abort = error as? AbortError {
                        reason = abort.reason
                    } else {
                        reason = "Something went wrong."
                    }
                default:
                    self.log.error(error.localizedDescription)
                    
                    if let debuggable = error as? Debuggable {
                        reason = debuggable.reason
                    } else if let abort = error as? AbortError {
                        reason = abort.reason
                    } else {
                        reason = "Something went wrong. \(error.localizedDescription)"
                    }
                }
                return try req.response.internalServerError(message: reason)
            }
        }
    }
}
