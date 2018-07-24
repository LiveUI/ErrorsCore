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

