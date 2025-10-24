//
//  AuthenticationService.swift
//  Now Playing Client
//
//  Created by Marc Steele on 24/10/2025.
//

import SwiftUI
import Combine
import HTTPTypes

enum AuthenticationStatus {
    case Unauthenticated
    case InProgress
    case Authenticated
    case Error
}

protocol AuthenticationService {
    var state: AuthenticationStatus { get }
    var headerField: HTTPField.Name { get }
    var headerValue: String { get }
    func authenticate()
    func logout()
    static func instance() -> any AuthenticationService
}


func getAuthenticationService() -> any AuthenticationService {
    let selectedService = UserDefaults.standard.string(forKey: Constants.settingsAuthenticationMethod) ?? Constants.authenticationMethodAuth0
    let selectedClass = authenticationGroupings.first { $0.name == selectedService }
    return selectedClass!.service.instance()
}

struct AuthenticationGrouping {
    let name: String
    let service: any AuthenticationService.Type
}

let authenticationGroupings: [AuthenticationGrouping] = [
    AuthenticationGrouping(name: Constants.authenticationMethodAuth0, service: Auth0AuthenticationService.self)
]
