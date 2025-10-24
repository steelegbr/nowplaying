//
//  Auth0AuthenticationService.swift
//  Now Playing Client
//
//  Created by Marc Steele on 24/10/2025.
//

import SwiftUI
import Auth0
import Combine
import HTTPTypesFoundation

class Auth0AuthenticationService: AuthenticationService, ObservableObject {
    @Published
    var state: AuthenticationStatus = .Unauthenticated
    
    static let shared = Auth0AuthenticationService()
    private let credentialsManager = CredentialsManager(
        authentication: Auth0.authentication(
            clientId: UserDefaults.standard.string(forKey: Constants.settingsAuth0ClientId) ?? "NO_CLIENT_ID",
            domain: UserDefaults.standard.string(forKey: Constants.settingsAuth0Domain) ?? "NO_DOMAIN"
        )
    )
    private var cancellables = Set<AnyCancellable>()
    
    var headerField: HTTPField.Name { .authorization }
    var headerValue: String { "Bearer \(credentialsManager.credentials())" }
    
    private var clientId: String { UserDefaults.standard.string(forKey: Constants.settingsAuth0ClientId) ?? "NO_CLIENT_ID" }
    private var domain: String { UserDefaults.standard.string(forKey: Constants.settingsAuth0Domain) ?? "NO_DOMAIN" }
    
    func authenticate() {
        print("Auth0 authenticate called.")
        
        if state == .Authenticated || state == .InProgress {
            print("Skipping authentication as we're in state \(state).")
            return
        }
        
        attemptLoginWithRefreshToken()
    }
    
    private func attemptLoginWithRefreshToken() {
        state = .InProgress
        
        guard credentialsManager.canRenew() else {
            print("Skipping refresh token login as no refresh token available.")
            attemptLogin()
            return
        }

         print("Attempting login with refresh token.")
         credentialsManager
             .renew()
             .sink(
                receiveCompletion: { completion in
                     if case .failure(let error) = completion {
                         print("Refresh token login failed: \(error)")
                         self.attemptLogin()
                     }
                },
                receiveValue: { credentials in
                    print("Renewed credentials: \(credentials)")
                    DispatchQueue.main.async {
                        self.state = .Authenticated
                    }
                })
             .store(in: &self.cancellables)
        
    }
    
    private func attemptLogin() {
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
                        let stored = self.credentialsManager.store(credentials: credentials)
                        if stored {
                            print("Updated credentials in CredentialsManager")
                            DispatchQueue.main.async {
                                self.state = .Authenticated
                            }
                        } else {
                            print("Failed to store credentials in CredentialsManager.")
                            DispatchQueue.main.async {
                                self.state = .Error
                            }
                        }
                    case .failure(let error):
                        print("Failed with: \(error)")
                        DispatchQueue.main.async {
                            self.state = .Error
                        }
                }
            }
    }
    
    func logout() {
        print("Auth0 logout called.")
        if credentialsManager.clear() {
            print("Successfully logged out")
            state = .Unauthenticated
        } else {
            print("Failed to log out")
            state = .Error
        }
    }
    
    class func instance() -> AuthenticationService {
        return shared
    }
    
}

