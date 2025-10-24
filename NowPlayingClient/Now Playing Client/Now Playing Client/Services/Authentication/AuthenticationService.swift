//
//  AuthenticationService.swift
//  Now Playing Client
//
//  Created by Marc Steele on 24/10/2025.
//

import SwiftUI
import Combine

enum AuthenticationStatus {
    case Unauthenticated
    case InProgress
    case Authenticated
    case Error
}

class AuthenticationService: ObservableObject {
    var objectWillChange: ObservableObjectPublisher
    
    init() {
        self.objectWillChange = ObservableObjectPublisher()
    }
    
    @Published
    var state: AuthenticationStatus = .Unauthenticated
    
    func authenticate() {
        print("Log in call to empty authentication service!")
    }
    
    func logout() {
        print("Log out call to empty authentication service!")
    }
    
    class func instance() -> AuthenticationService {
        AuthenticationService()
    }
    
    static func getService() -> AuthenticationService {
        let selectedService = UserDefaults.standard.string(forKey: Constants.settingsAuthenticationMethod) ?? Constants.authenticationMethodAuth0
        let selectedClass = authenticationGroupings.first { $0.name == selectedService }
        return selectedClass!.service.instance()
    }
}

struct AuthenticationGrouping {
    let name: String
    let service: AuthenticationService.Type
}

let authenticationGroupings: [AuthenticationGrouping] = [
    AuthenticationGrouping(name: Constants.authenticationMethodAuth0, service: Auth0AuthenticationService.self)
]
