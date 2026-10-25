//
//  FileWatchView.swift
//  Now Playing Client
//
//  Created by Marc Steele on 25/10/2025.
//

import SwiftUI

struct FileWatchView: View {
    @ObservedObject var fileWatchService = FileWatchService.shared
    
    var body: some View {
        HStack {
            FileWatchServiceButton(fileWatchService: fileWatchService)
            FileWatchServiceBanner(fileWatchService: fileWatchService)
        }
    }
}


struct FileWatchView_Previews: PreviewProvider {
    static var previews: some View {
        FileWatchView()
    }
}
