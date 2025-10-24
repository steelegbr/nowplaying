//
//  Auth0AuthenticationService.swift
//  Now Playing Client
//
//  Created by Marc Steele on 24/10/2025.
//

import SwiftUI

class Auth0AuthenticationService: AuthenticationService {
    static let shared = Auth0AuthenticationService()
    
    override func authenticate() {
        print("Auth0 authenticate called...")
    }
    
    override func logout() {
        print("Auth0 logout called...")
    }
    
    override class func instance() -> AuthenticationService {
        return shared
    }
}
