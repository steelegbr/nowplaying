//
//  AuthenticationButton.swift
//  Now Playing Client
//
//  Created by Marc Steele on 24/10/2025.
//

import SwiftUI

struct AuthenticationButton: View {
    var authenticationService: AuthenticationService
    
    var body: some View {
        Button(action: handleButtonPress) {
            Text(buttonText)
        }
    }
    
    var buttonText: String {
        switch authenticationService.state {
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
    
    func handleButtonPress() {
        if authenticationService.state == .Unauthenticated || authenticationService.state == .Error {
            authenticationService.authenticate()
        } else if authenticationService.state == .Authenticated {
            authenticationService.logout()
        }
    }
}

