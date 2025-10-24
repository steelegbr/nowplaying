//
//  FileWatchSettingsView.swift
//  Now Playing Client
//
//  Created by Marc Steele on 24/10/2025.
//

import SwiftUI
import UniformTypeIdentifiers

struct FileWatchSettingsView: View {
    @State private var showPicker = false
    @AppStorage(Constants.settingsWatchFile) private var watchFile: URL?
    
    var body: some View {
        HStack {
            Text("\(watchFile?.absoluteString ?? "No file selected!")")
            Button {
                showPicker = true
            } label: {
                Label("Choose File to Watch", systemImage: "folder")
            }
            .fileImporter(
                isPresented: $showPicker,
                allowedContentTypes: [UTType.plainText]
            ) { result in
                switch result {
                    case .success(let selectedUrl):
                        watchFile = selectedUrl
                    case .failure:
                        print("Failed to select a watch file")
                }
            }
        }.padding()
        
        
    }
}

struct FileWatchSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        FileWatchSettingsView()
    }
}

