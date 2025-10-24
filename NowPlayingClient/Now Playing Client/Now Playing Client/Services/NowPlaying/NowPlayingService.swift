//
//  NowPlayingService.swift
//  Now Playing Client
//
//  Created by Marc Steele on 24/10/2025.
//

import Foundation
import HTTPTypesFoundation

class NowPlayingService {
    static let instance = NowPlayingService()
    
    private var stationName: String {
        let _stationName = UserDefaults.standard.string(forKey: Constants.settingsNowPlayingStation) ?? ""
        print("Determined station name to be \(_stationName).")
        return _stationName
    }
    
    private var domain: String {
        let _domain = UserDefaults.standard.string(forKey: Constants.settingsNowPlayingDomain) ?? ""
        print("Determined domain to be \(_domain)")
        return _domain
    }
    
    private func generateAuthenticatedRequest(method: HTTPRequest.Method, path: String) -> HTTPRequest {
        var request = HTTPRequest(
            method: method,
            scheme: "https",
            authority: domain,
            path: path
        )
    
        let authenticationService = getAuthenticationService()
        request.headerFields[authenticationService.headerField] = authenticationService.headerValue
        
        return request
    }
    
    private func createStation() async -> Bool {
        let stationCreateBody = StationCreateDTO(name: stationName)
        let request = generateAuthenticatedRequest(method: .post, path: "/api/station/")
        print("Creating new station with name \(stationName)")
        
        let (responseBody, response) = try await URLSession.shared.upload(for: request, from: stationCreateBody.name.data(using: .utf8)!)
        guard response.status == .created else {
            print("Failed to create the station.")
            return false
        }
        
        return true
    }
    
}
