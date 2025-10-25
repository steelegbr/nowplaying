//
//  FileWatchServiceButton.swift
//  Now Playing Client
//
//  Created by Marc Steele on 25/10/2025.
//

import SwiftUI

struct FileWatchServiceButton: View {
    @ObservedObject var fileWatchService: FileWatchService
    
    var body: some View {
        Button(action: handleButtonPress) {
            Text(buttonText)
        }
    }
    
    var buttonText: String {
        switch fileWatchService.status {
            case .Stopped:
                "Start"
            case .Running:
                "Stop"
        }
    }
    
    func handleButtonPress() {
        switch fileWatchService.status {
            case .Stopped:
                fileWatchService.start()
            case .Running:
                fileWatchService.stop()
        }
    }
}

struct FileWatchServiceButton_Previews: PreviewProvider {
    static var previews: some View {
        FileWatchServiceButton(
            fileWatchService: FileWatchService.shared
        )
    }
}
