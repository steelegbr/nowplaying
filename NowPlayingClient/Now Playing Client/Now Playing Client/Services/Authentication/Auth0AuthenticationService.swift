//
//  Auth0AuthenticationService.swift
//  Now Playing Client
//
//  Created by Marc Steele on 24/10/2025.
//

import SwiftUI
import Auth0

class Auth0AuthenticationService: AuthenticationService {
    static let shared = Auth0AuthenticationService()
    
    override func authenticate() {
        print("Auth0 authenticate called...")
        
        if state == .Authenticated || state == .InProgress {
            print("Skipping authentication as we're in state \(state)")
            return
        }
        
        state = .InProgress
        
        let clientId = UserDefaults.standard.string(forKey: Constants.settingsAuth0ClientId) ?? "NO_CLIENT_ID"
        let domain = UserDefaults.standard.string(forKey: Constants.settingsAuth0Domain) ?? "NO_DOMAIN"
        print("Determined to be using \(clientId) for \(domain)")
        
        Auth0
            .webAuth(
                clientId: clientId,
                domain: domain
            )
            .start { result in
                switch result {
                    case .success(let credentials):
                        print("Obtained credentials: \(credentials)")
                    case .failure(let error):
                        print("Failed with: \(error)")
                        self.state = .Error
                }
            }
    }
    
    override func logout() {
        print("Auth0 logout called...")
    }
    
    override class func instance() -> AuthenticationService {
        return shared
    }
}
