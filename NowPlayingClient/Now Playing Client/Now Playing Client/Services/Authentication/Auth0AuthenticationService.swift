//
//  Auth0AuthenticationService.swift
//  Now Playing Client
//
//  Created by Marc Steele on 24/10/2025.
//

import SwiftUI
import Auth0

class Auth0AuthenticationService: AuthenticationService {
    private static let shared = Auth0AuthenticationService()
    
    override var headerField: String { "Authorization" }
    override var headerValue: String { "Bearer \(accessToken ?? "NO_TOKEN")" }
    
    private var accessToken: String?
    private var refreshToken: String? {
        get {
            UserDefaults.standard.string(forKey: Constants.settingsAuth0RefreshToken)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Constants.settingsAuth0RefreshToken)
        }
    }
    
    override func authenticate() {
        print("Auth0 authenticate called.")
        
        if state == .Authenticated || state == .InProgress {
            print("Skipping authentication as we're in state \(state).")
            return
        }
        
        state = .InProgress
        
        let clientId = UserDefaults.standard.string(forKey: Constants.settingsAuth0ClientId) ?? "NO_CLIENT_ID"
        let domain = UserDefaults.standard.string(forKey: Constants.settingsAuth0Domain) ?? "NO_DOMAIN"
        print("Determined to be using \(clientId) for \(domain).")
        
        attemptLoginWithRefreshToken(clientId: clientId, domain: domain)
        
        
    }
    
    private func attemptLoginWithRefreshToken(clientId: String, domain: String) {
        if (refreshToken ?? "").isEmpty {
            print("Skipping refresh token login as no refresh token available.")
            attemptLogin(clientId: clientId, domain: domain)
        }
        
        print("Attempting login with refresh token.")
        Auth0
            .authentication(
                clientId: clientId,
                domain: domain
            )
            .renew(withRefreshToken: refreshToken!)
            .start { result in
                switch result {
                    case .success(let credentials):
                        print("Successfully used refresh token.")
                        self.accessToken = credentials.idToken
                        self.state = .Authenticated
                    case .failure(let error):
                        print("Failed with: \(error)")
                        self.refreshToken = nil
                        self.attemptLogin(clientId: clientId, domain: domain)
                }
            }
        
    }
    
    private func attemptLogin(clientId: String, domain: String) {
        print("Falling back to normal authentication")
        
        Auth0
            .webAuth(
                clientId: clientId,
                domain: domain
            )
            .scope("openid profile email offline_access")
            .start { result in
                switch result {
                    case .success(let credentials):
                        print("Obtained credentials: \(credentials).")
                        self.refreshToken = credentials.refreshToken
                        self.accessToken = credentials.idToken
                        self.state = .Authenticated
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

