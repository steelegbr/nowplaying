//
//  FileWatchService.swift
//  Now Playing Client
//
//  Created by Marc Steele on 25/10/2025.
//

import Combine
import Foundation

enum FileWatchServiceStatus {
    case Stopped
    case Running
}

class FileWatchService: ObservableObject {
    static let shared = FileWatchService()
    
    @Published
    var status: FileWatchServiceStatus = .Stopped
    
    func start() {
        if status == .Running {
            print("Can't start file watching service as it's already running!")
            return
        }
    }
    
    func stop() {
        if status == .Stopped {
            print("Can't stop file watching service as it's already stopped!")
            return
        }
    }
}
