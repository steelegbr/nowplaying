//
//  AuthenticationStatus.swift
//  Now Playing Client
//
//  Created by Marc Steele on 24/10/2025.
//

import SwiftUI

struct AuthenticationStatusBanner: View {
    var authenticationStatus: AuthenticationStatus
    
    var body: some View {
        Text(statusText)
            .foregroundStyle(statusBackground)
            .padding()
    }
    
    private var statusText: String {
        switch authenticationStatus {
            case .Unauthenticated:
                "Not Authenticated"
            case .InProgress:
                "In Progress..."
            case .Authenticated:
                "Authenticated"
            case .Error:
                "Error"
        }
    }
    
    private var statusBackground: Color {
        switch authenticationStatus {
            case .Unauthenticated:
                .red
            case .InProgress:
                .orange
            case .Authenticated:
                .green
            case .Error:
                .red
        }
    }
}
