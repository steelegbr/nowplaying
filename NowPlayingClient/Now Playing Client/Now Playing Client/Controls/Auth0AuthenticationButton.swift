//
//  AuthenticationButton.swift
//  Now Playing Client
//
//  Created by Marc Steele on 24/10/2025.
//

import SwiftUI

struct Auth0AuthenticationButton: View {
    @ObservedObject var auth0Service: Auth0AuthenticationService
    
    var body: some View {
        Button(action: handleButtonPress) {
            Text(buttonText)
        }
        .disabled(buttonDisabled)
    }
    
    var buttonText: String {
        switch auth0Service.state {
            case .Unauthenticated:
                "Log In"
            case .InProgress:
                "Logging In..."
            case .Authenticated:
                "Log Out"
            case .Error:
                "Log In"
        }
    }
    
    var buttonDisabled: Bool {
        auth0Service.state == .InProgress
    }
    
    func handleButtonPress() {
        if auth0Service.state == .Unauthenticated || auth0Service.state == .Error {
            auth0Service.authenticate()
        } else if auth0Service.state == .Authenticated {
            auth0Service.logout()
        }
    }
}

