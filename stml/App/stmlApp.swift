//
//  stmlApp.swift
//  stml
//
//  Created by Ezra Yeoh on 6/15/23.
//

import SwiftUI
import SpotifyiOS

@main
struct stmlApp: App {
    
    @Environment(\.scenePhase) var scenePhase
    
    let persistenceController = PersistenceController.shared
    @StateObject var spotifyController = SpotifyController()
    
    init() {
        // Add "didFinishLaunchingWithOptions" methods here
    }

    var body: some Scene {
        
        WindowGroup {
            
            ContentView(spotifyController: spotifyController)
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .onOpenURL { url in
                    print("onOpenURL: \(url)")
                    // For spotify authorization and authentication flow
                    authorizingSpotify(url)
                }
                .onChange(of: scenePhase) { phase in
                    // For spotify authorization and authentication flow when SCENE CHANGES
                    reconnectSpotify(phase)
                }
            
        }
    }
    
    func authorizingSpotify(_ url: URL) {
        let parameters = spotifyController.appRemote.authorizationParameters(from: url)
        
        if let code = parameters?["code"] {
            spotifyController.responseCode = code
        } else if let accessToken = parameters?[SPTAppRemoteAccessTokenKey] {
            spotifyController.accessToken = accessToken
        } else if let errorDescription = parameters?[SPTAppRemoteErrorDescriptionKey] {
            print("No access token error: \(errorDescription)")
        }
        
    }
    
    func reconnectSpotify(_ scenePhase: ScenePhase) {
        switch scenePhase {
        case .active:
            print("scenePhase: active")
            if let accessToken = spotifyController.appRemote.connectionParameters.accessToken {
                spotifyController.appRemote.connectionParameters.accessToken = accessToken
                spotifyController.appRemote.connect()
                print("ACCESS TOKEN: \(accessToken)")
            } else if let accessToken = spotifyController.accessToken {
                spotifyController.appRemote.connectionParameters.accessToken = accessToken
                spotifyController.appRemote.connect()
            }
        case .inactive:
            print("scenePhase: inactive")
        case .background:
            print("scenePhase: background")
            if spotifyController.appRemote.isConnected {
                print("Spotify controller is still connected")
            } else {
                spotifyController.appRemote.connect()
                print("Spotify controller is reconnecting")
            }
            break
        @unknown default:
            print("scenePhase: unknown default")
            break
        }
    }
    
}
