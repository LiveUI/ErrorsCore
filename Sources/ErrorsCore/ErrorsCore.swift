//
//  ErrorsCore.swift
//  ErrorsCore
//
//  Created by Ondrej Rafaj on 09/12/2017.
//

import Foundation
import Vapor


// TODO: Change to frontend errors!
public enum GenericError: FrontendError {
    
    /// Impossible situation
    case impossibleSituation
    
    /// Error code
    public var identifier: String {
        return "generic"
    }
    
    /// Error reason
    public var reason: String {
        return "This should never, ever happen!"
    }
    
    /// Error http status code
    public var status: HTTPStatus {
        return .internalServerError
    }
    
}

public enum HTTPError: FrontendError {
    
    /// Not found
    case notFound
    
    /// Not authorized
    case notAuthorized
    
    /// Not authorized as Admin
    case notAuthorizedAsAdmin
    
    /// Missing request data
    case missingRequestData
    
    /// Missing authorization data
    case missingAuthorizationData
    
    /// Missing available
    case missingAvailable
    
    /// Missing search parameters
    case missingSearchParams
    
    /// Id is missing
    case missingId
    
    /// Error code
    public var identifier: String {
        switch self {
        case .notFound:
            return "httperror.not_found"
        case .notAuthorized:
            return "httperror.not_authorized"
        case .notAuthorizedAsAdmin:
            return "httperror.not_authorized_as_admin"
        case .missingRequestData:
            return "httperror.missing_request_data"
        case .missingAuthorizationData:
            return "httperror.missing_authorizationData"
        case .missingAvailable:
            return "httperror.missing_available"
        case .missingSearchParams:
            return "httperror.missing_search"
        case .missingId:
            return "httperror.missing_id"
        }
    }
    
    /// Error reason
    public var reason: String {
        switch self {
        case .notFound:
            return "Not found"
        case .notAuthorized:
            return "You shall not pass!"
        case .notAuthorizedAsAdmin:
            return "Only a member of an admin team is able to access this functionality"
        case .missingRequestData:
            return "Some request data are missing"
        case .missingAuthorizationData:
            return "Some authorization data are missing"
        case .missingAvailable:
            return "Not available"
        case .missingSearchParams:
            return "Search parameter is missing"
        case .missingId:
            return "Id is missing"
        }
    }
    
    /// Error http status code
    public var status: HTTPStatus {
        switch self {
        case .notFound:
            return .notFound
        case .notAuthorized:
            fallthrough
        case .notAuthorizedAsAdmin:
            return .unauthorized
        case .missingRequestData, .missingAuthorizationData, .missingAvailable, .missingSearchParams:
            return .preconditionRequired
        case .missingId:
            return .internalServerError
        }
    }
}



