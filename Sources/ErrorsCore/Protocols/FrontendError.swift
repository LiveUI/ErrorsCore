//
//  FrontendError.swift
//  ErrorsCore
//
//  Created by Ondrej Rafaj on 14/01/2018.
//

import Foundation
import Vapor


/// Frontend debuggable error
public protocol FrontendError: Debuggable {
    var status: HTTPStatus { get }
}


extension FrontendError {
    
    @available(*, deprecated, renamed: "identifier")
    public var code: String {
        return identifier
    }
    
    @available(*, deprecated, renamed: "reason")
    public var desctiption: String {
        return reason
    }
    
}
