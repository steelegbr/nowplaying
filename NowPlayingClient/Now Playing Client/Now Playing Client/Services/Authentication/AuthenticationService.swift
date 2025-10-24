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
        print("Call to empty authentication service!")
    }
}

struct AuthenticationGrouping {
    let name: String
    let service: AuthenticationService.Type
}

let authenticationGroupings: [AuthenticationGrouping] = [
    AuthenticationGrouping(name: Constants.authenticationMethodAuth0, service: Auth0AuthenticationService.self)
]
