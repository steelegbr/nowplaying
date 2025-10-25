//
//  FileWatchServiceBanner.swift
//  Now Playing Client
//
//  Created by Marc Steele on 25/10/2025.
//

import SwiftUI

struct FileWatchServiceBanner: View {
    @ObservedObject var fileWatchService: FileWatchService
    
    var body: some View {
        Text(statusText)
            .foregroundStyle(statusColour)
            .padding()
    }
    
    private var statusText: String {
        switch fileWatchService.status {
            case .Running:
                "Running"
            case .Stopped:
                "Stopped"
        }
    }
    
    private var statusColour: Color {
        switch fileWatchService.status {
            case .Stopped:
                .red
            case .Running:
                .green
        }
    }
}

struct FileWatchServiceBanner_Previews: PreviewProvider {
    static var previews: some View {
        FileWatchServiceBanner(fileWatchService: FileWatchService.shared)
    }
}
