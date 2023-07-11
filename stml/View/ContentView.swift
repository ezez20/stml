//
//  ContentView.swift
//  stml
//
//  Created by Ezra Yeoh on 6/15/23.
//

import SwiftUI
import CoreData
import Combine

struct ContentView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    @ObservedObject var spotifyController: SpotifyController
    @State private var isConnected = false
    @State private var spotifyUriSaved = ""
    
// MARK: - View
    var body: some View {
        
        NavigationView {
            VStack {
                
                if isConnected {
                    Text("Now playing: \(spotifyController.trackLabelText)")
                    
                    Button {
                        spotifyController.tappedPauseOrPlay()
                    } label: {
                        Image(uiImage: (spotifyController.playPauseImage ?? UIImage(systemName: "questionmark"))!)
                    }

                    
                    Image(uiImage: (spotifyController.albumImage ?? UIImage(systemName: "questionmark"))!)
                }
                
                Text("Connect to your Spotify Account")
                    .foregroundColor(isConnected ?  .green : .black)
            
                Button {
                    print("Connect to Spotify Button Tapped")
                    spotifyController.connectButtonTapped()
                } label: {
                    Text("Connect to Spotify")
                }
                .buttonStyle(.borderedProminent)
                .tint(.green)
                
               Button {
                   print("Spotify track URI saved: \(spotifyController.trackURI)")
                   APIService.shared.playSpotifyTrack(trackUri: spotifyController.trackURI)

                } label: {
                    Text("Refresh")
                }
                .buttonStyle(.borderedProminent)
                .tint(.green)
            }
        
        }.onChange(of: spotifyController.trackLabelText) { v in
            print("onChange")
            if spotifyController.appRemote.isConnected {
                isConnected = true
                print("Connected")
            } else {
                isConnected = false
                print("Not connected")
            }
        }
        
        
    }

// MARK: - Functions

}


// MARK: - PreviewProvider
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(spotifyController: SpotifyController()).environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
