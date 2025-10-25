//
//  NowPlayingService.swift
//  Now Playing Client
//
//  Created by Marc Steele on 24/10/2025.
//

import Combine
import Foundation
import HTTPTypesFoundation

class NowPlayingService: ObservableObject {
    static let shared = NowPlayingService()
    private let jsonEncoder = JSONEncoder()
    
    @Published
    var nowPlaying: NowPlayingDTO?
    
    private var stationName: String {
        UserDefaults.standard.string(forKey: Constants.settingsNowPlayingStation) ?? ""
    }
    
    private var domain: String {
        UserDefaults.standard.string(forKey: Constants.settingsNowPlayingDomain) ?? ""
    }
    
    private func generateAuthenticatedRequest(method: HTTPRequest.Method, path: String) async -> HTTPRequest {
        var request = HTTPRequest(
            method: method,
            scheme: "https",
            authority: domain,
            path: path
        )
    
        let authenticationService = getAuthenticationService()
        request.headerFields[authenticationService.headerField] = await authenticationService.getHeaderValue()
        
        print("Generated \(method) request to \(request.url?.absoluteString ?? "INVALID_URL")")
        return request
    }
    
    private func createStation() async {
        let stationCreateBody = StationCreateDTO(name: stationName)
        let request = await generateAuthenticatedRequest(method: .post, path: "/api/station/")
        print("Creating new station with name \(stationName)")
        
        do {
            let (responseBody, response) = try await URLSession.shared.upload(
                for: request,
                from: jsonEncoder.encode(stationCreateBody)
            )
            guard response.status == .created else {
                print("Failed to create the station. Error code \(response.status). Response: \(responseBody)")
                return
            }
        } catch {
            print("Something went wrong creating the station. Reason: \(error.localizedDescription)")
            return
        }
        
        print("Successfully created station with name \(stationName)")
        await updateNowPlaying(newNowPlaying: nowPlaying)
    }
    
    func updateNowPlaying(newNowPlaying: NowPlayingDTO?) async {
        DispatchQueue.main.async {
            self.nowPlaying = newNowPlaying
        }
        
        if newNowPlaying == nil {
            print("Clearing now playing information for \(stationName)")
        } else {
            print("Setting now playing for \(stationName) to be \(newNowPlaying!.artist) - \(newNowPlaying!.title)")
        }
        
        let request = await generateAuthenticatedRequest(method: .put, path: "/api/station/\(stationName)")
        
        do {
            let (responseBody, response) = try await URLSession.shared.upload(
                for: request,
                from: jsonEncoder.encode(newNowPlaying)
            )
            guard response.status == .ok else {
                print("Failed to Update now playing information for \(stationName). Error code \(response.status). Response: \(responseBody)")
                await self.createStation()
                return
            }
        } catch {
            print("Something went wrong updating the now playing information for \(stationName). Reason: \(error.localizedDescription)")
            return
        }
        
        print("Successfully updated now playing information for \(stationName)")
    }
    
}
