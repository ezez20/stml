//
//  stmlApp.swift
//  stml
//
//  Created by Ezra Yeoh on 6/15/23.
//

import SwiftUI

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
            
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .onOpenURL { url in
                    // For spotify authorization and authentication flow
                    let parameters = spotifyController.appRemote.authorizationParameters(from: url)
                    
                    if let code = parameters?["code"] {
                        spotifyController.responseCode = code
                    } else if let accessToken = parameters?[SPTAppRemoteAccessTokenKey] {
                        spotifyController.accessToken = accessToken
                    } else if let errorDescription = parameters?[SPTAppRemoteErrorDescriptionKey] {
                        print("No access token error: \(errorDescription)")
                    }
                }
                .onChange(of: scenePhase) { phase in
                    switch phase {
                    case .active:
                        if let accessToken = spotifyController.appRemote.connectionParameters.accessToken {
                            spotifyController.appRemote.connectionParameters.accessToken = accessToken
                            spotifyController.appRemote.connect()
                        } else if let accessToken = spotifyController.accessToken {
                            spotifyController.appRemote.connectionParameters.accessToken = accessToken
                            spotifyController.appRemote.connect()
                        }
                    case .inactive:
                        if spotifyController.appRemote.isConnected {
                            spotifyController.appRemote.disconnect()
                        }
                    case .background:
                        print("scenePhase: background")
                        break
                    @unknown default:
                        print("scenePhase: unknown default")
                        break
                    }
                }

            
        }
    }
    
}
