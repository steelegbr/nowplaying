//
//  FileWatchService.swift
//  Now Playing Client
//
//  Created by Marc Steele on 25/10/2025.
//

import Combine
import Foundation
import FileWatcher

enum FileWatchServiceStatus {
    case Stopped
    case Running
}

enum FileWatchRegKey: String {
    case Artist = "artist"
    case Title = "title"
    case Year = "year"
}

class FileWatchService: ObservableObject {
    static let shared = FileWatchService()
    private let nowPlayingService = NowPlayingService.shared
    private var fileWatcher: FileWatcher?
    
    @Published
    var status: FileWatchServiceStatus = .Stopped
    
    func start() {
        if status == .Running {
            print("Can't start file watching service as it's already running!")
            return
        }
        
        let fileUrl = UserDefaults.standard.url(forKey: Constants.settingsWatchFile)
        if fileUrl == nil {
            print("Got a NULL file watch URL. Can't start!")
            return
        }
        
        fileWatcher = FileWatcher([fileUrl!.path()])
        fileWatcher?.callback = fileWatcherCallback
        fileWatcher?.queue = DispatchQueue.global()
        fileWatcher?.start()
        
        print("File watch service started monitoring \(fileUrl?.path()).")
        status = .Running
    }
    
    func stop() {
        if status == .Stopped {
            print("Can't stop file watching service as it's already stopped!")
            return
        }
        
        fileWatcher?.stop()
        fileWatcher = nil
        status = .Stopped
    }
    
    private func fileWatcherCallback(event: FileWatcherEvent) {
        let fileUrl = NSURL(fileURLWithPath: event.path)
        print("Got a file event for path \(fileUrl)")
        guard fileUrl.startAccessingSecurityScopedResource() else {
            print("Failed to get permissions onto the now playing file.")
            return
        }
        
        do {
            let contents = try String(contentsOf: fileUrl as URL, encoding: .utf8)
            print("Determined now playing file contents to be '\(contents)'")
            let nowPlaying = contentsToNowPlayingDTO(contents: contents)
            Task {
                await nowPlayingService.updateNowPlaying(newNowPlaying: nowPlaying)
            }
        } catch {
            print("Failed to read the now playing file. Reason: \(error.localizedDescription)")
        }
    }
    
    private func contentsToNowPlayingDTO(contents: String) -> NowPlayingDTO? {
        let fullNowPlaying = extractFullNowplaying(contents: contents)
        if fullNowPlaying != nil {
            return fullNowPlaying
        }
        
        return extractPartialNowPlaying(contents: contents)
    }
    
    private func extractFullNowplaying(contents: String) -> NowPlayingDTO? {
        let capturePattern = #"(?<artist>.+) - (?<title>.+) \((?<year>\d{0,4})\)"#
        let nowPlayingRegex = try! NSRegularExpression(pattern: capturePattern, options: [])
        let matches = nowPlayingRegex.matches(
            in: contents,
            options: [],
            range: NSRange(contents.startIndex..<contents.endIndex, in: contents)
        )
        
        guard let match = matches.first else {
            return nil
        }
        
        return NowPlayingDTO(
            artist: extractRegexSubstring(match: match, key: .Artist, contents: contents),
            title: extractRegexSubstring(match: match, key: .Title, contents: contents),
            year: Int(extractRegexSubstring(match: match, key: .Year, contents: contents, defaultToNumber: true))
        )
    }
    
    private func extractPartialNowPlaying(contents: String) -> NowPlayingDTO? {
        let capturePattern = #"(?<artist>.+) - (?<title>.+)"#
        let nowPlayingRegex = try! NSRegularExpression(pattern: capturePattern, options: [])
        let matches = nowPlayingRegex.matches(
            in: contents,
            options: [],
            range: NSRange(contents.startIndex..<contents.endIndex, in: contents)
        )
        
        guard let match = matches.first else {
            return nil
        }
        
        return NowPlayingDTO(
            artist: extractRegexSubstring(match: match, key: .Artist, contents: contents),
            title: extractRegexSubstring(match: match, key: .Title, contents: contents),
            year: nil
        )
    }
    
    private func extractRegexSubstring(match: NSTextCheckingResult, key: FileWatchRegKey, contents: String, defaultToNumber: Bool = false) -> String {
        let matchRange = match.range(withName: key.rawValue)
        if let substringRange = Range(matchRange, in: contents) {
            let substring = String(contents[substringRange])
            return substring
        }
        
        return defaultToNumber ? "0" : ""
    }
}
