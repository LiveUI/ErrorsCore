//
//  Request+Errors.swift
//  ErrorsCore
//
//  Created by Ondrej Rafaj on 13/01/2018.
//

import Foundation
import Vapor


/// Error response object
public struct ErrorResponse: Content {
    
    /// Error
    public let error: String
    
    /// Description
    public let description: String
    
}

/// Success response object
public struct SuccessResponse: Content {
    
    /// Code
    public let code: String
    
    /// Description
    public let description: String?
    
}


/// RequestResponse object
public struct RequestResponse {
    
    /// Request reference
    public let request: Request
    
    /// Initializer
    public init(req: Request) {
        self.request = req
    }
    
    // MARK: Generators
    
    /// Basic response
    ///
    /// - parameters:
    ///     - status: HTTPStatus, default .ok (200)
    public func basic(status: HTTPStatus = .ok) throws -> Response {
        let response = Response()
        response.status = status
        
        let headers = HTTPHeaders([("Content-Type", "application/json; charset=utf-8")])
        response.headers = headers
        
        return response
    }
    
    /// Basic error response
    ///
    /// - parameters:
    ///     - status: HTTPStatus
    ///     - error: String, error
    ///     - description: String, description
    public func error(status: HTTPStatus, error: String, description: String) throws -> Response {
        let response = try basic(status: status)
        
        let responseObject = ErrorResponse(error: error, description: description)
        let encoder = JSONEncoder()
        response.body = try Response.Body(data: encoder.encode(responseObject))
        
        return response
    }
    
    /// Basic success response
    ///
    /// - parameters:
    ///     - status: HTTPStatus, default .ok (200)
    ///     - error: String, error
    ///     - description: String, description
    public func success(status: HTTPStatus = .ok, code: String, description: String? = nil) throws -> Response {
        let response = try basic(status: status)
        
        let responseObject = SuccessResponse(code: code, description: description)
        let encoder = JSONEncoder()
        response.body = try Response.Body(data: encoder.encode(responseObject))
        
        return response
    }
    
    /// Not found response (404)
    public func notFound() throws -> Response {
        // TODO: make "not_found" come from HTTPStatus
        let response = try error(status: .notFound, error: "not_found", description: "Not found")
        return response
    }
    
    /// Not authorized (401)
    public func notAuthorized() throws -> Response {
        let response = try error(status: .unauthorized, error: "not_authorized", description: "Not authorized")
        return response
    }
    
    /// Authentication has expired (401)
    public func authExpired() throws -> Response {
        let response = try error(status: .unauthorized, error: "not_authorized", description: "Authorization expired")
        return response
    }
    
    /// Bad URL (404)
    public func badUrl() throws -> Response {
        let response = try error(status: .notFound, error: "not_found", description: "Endpoint doesn't exist; See http://boost.docs.apiary.io for API documentation")
        return response
    }
    
    /// No content (204)
    public func noContent() throws -> Response {
        let response = try basic(status: .noContent)
        return response
    }
    
    /// Object deleted (204)
    public func deleted() throws -> Response {
        let res = try noContent()
        return res
    }
    
    /// Functionality obly available in debug mode response
    public func onlyInDebug() throws -> Response {
        let response = try error(status: .preconditionFailed, error: "not_available", description: "Endpoint is not available in production mode")
        return response
    }
    
    /// Maintenance has finished standard response (200)
    public func maintenanceFinished(message: String) throws -> Response {
        let response = try success(code: "maintenance_ok", description: message)
        return response
    }
    
    /// I am a teapot (418, and why not?!)
    public func teapot() throws -> Response {
        let response = try success(status: .custom(code: 418, reasonPhrase: "I am teapot"), code: "teapot", description: """
            I'm a little teapot
            Short and stouts
            Here is my handle
            Here is my spout
            When I get all steamed up
            I just shout
            Tip me over and pour me out
            """
        )
        return response
    }
    
    /// Ping
    public func ping() throws -> Response {
        let response = try success(code: "pong")
        return response
    }
    
    /// Internal server error (500)
    public func internalServerError(message: String) throws -> Response {
        let response = try error(status: .internalServerError, error: "server_err", description: message)
        return response
    }
    
    /// Full allow CORS response
    public func cors() throws -> Response {
        let response = try noContent()
        let origin = "http://www.boost-react.com"
        response.headers.replaceOrAdd(name: "Access-Control-Allow-Origin", value: origin)
        var headers: [String] = []
        var isContentType: Bool = false
        for header in request.headers {
            if (header.name.lowercased() == "content-type") {
                isContentType = true
            }
            headers.append(header.name)
        }
        if !isContentType {
            headers.append("Content-Type")
        }
        if !headers.contains("Authorization") {
            headers.append("Authorization")
        }
        response.headers.replaceOrAdd(name: .accessControlAllowHeaders, value: headers.joined(separator: ","))
        response.headers.replaceOrAdd(name: .accessControlMaxAge, value: "5")
        response.headers.remove(name: .contentType)
        return response
    }
    
}


extension Request {
    
    /// Quick access to preset responses (wooohoooo!)
    public var response: RequestResponse {
        return RequestResponse(req: self)
    }
    
}
