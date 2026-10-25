//
//  NowPlayingSettingsView.swift
//  Now Playing Client
//
//  Created by Marc Steele on 24/10/2025.
//

import SwiftUI

struct NowPlayingSettingsView: View {
    @AppStorage(Constants.settingsNowPlayingDomain) private
        var nowPlayingDomain = "clock.solidradio.co.uk"
    @AppStorage(Constants.settingsNowPlayingStation) private
        var nowPlayingStation: String = ""

    @State private var tokenDraft = ""
    @State private var statusMessage: String?
    @State private var isError = false

    var body: some View {
        Form {
            Section("Studio Clock Server") {
                TextField("Domain", text: $nowPlayingDomain)
                TextField("Station", text: $nowPlayingStation)
            }

            Section("API Authentication") {
                SecureField("API token", text: $tokenDraft)

                HStack {
                    Button("Save Token", action: saveToken)
                        .disabled(
                            tokenDraft.trimmingCharacters(
                                in: .whitespacesAndNewlines
                            ).isEmpty
                        )

                    Button(
                        "Remove Token",
                        role: .destructive,
                        action: removeToken
                    )
                }

                if let statusMessage {
                    Text(statusMessage)
                        .font(.caption)
                        .foregroundStyle(
                            isError ? Color.red : Color.secondary
                        )
                }
            }
        }
        .padding()
    }

    private func loadSettings() {
        do {
            if let storedToken = try KeychainStore.load(Constants.tokenAccount) {
                tokenDraft = storedToken

            }
        } catch {
            isError = true
            statusMessage =
                "Couldn't load the API token: \(error.localizedDescription)"
        }
    }

    private func saveToken() {
        let token = tokenDraft.trimmingCharacters(
            in: .whitespacesAndNewlines
        )

        guard !token.isEmpty else { return }

        do {
            try KeychainStore.save(token, for: Constants.tokenAccount)
            tokenDraft = token
            isError = false
            statusMessage = "API token saved securely."
        } catch {
            isError = true
            statusMessage =
                "Couldn't save the API token: \(error.localizedDescription)"
        }
    }

    private func removeToken() {
        do {
            try KeychainStore.delete(Constants.tokenAccount)
            tokenDraft = ""
            isError = false
            statusMessage = "API token removed."
        } catch {
            isError = true
            statusMessage =
                "Couldn't remove the API token: \(error.localizedDescription)"
        }
    }
}

struct NowPlayingSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        NowPlayingSettingsView()
    }
}
