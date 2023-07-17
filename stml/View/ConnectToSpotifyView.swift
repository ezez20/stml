//
//  ConnectToSpotifyView.swift
//  stml
//
//  Created by Ezra Yeoh on 7/12/23.
//

import SwiftUI

struct ConnectToSpotifyView: View {
    
    @State private var isConnected = false
    @State private var spotifyController: SpotifyController
    
    init(isConnected: Bool = false, spotifyController: SpotifyController) {
        self.isConnected = isConnected
        self.spotifyController = spotifyController
    }
    
    var body: some View {
        
        VStack {
            
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
                print("Spotify track URI saved: \(spotifyController.currentTrackURI)")
                spotifyController.getCurrentPlaybackInfo()
                //                   APIService.shared.playSpotifyTrack(trackUri: spotifyController.trackURI)
                
            } label: {
                Text("Mark Position")
            }
            .buttonStyle(.borderedProminent)
            .tint(.green)
            
            Button {
                APIService.shared.playSpotifyTrack(trackUri: spotifyController.currentTrackURI, playbackPosition: spotifyController.playBackPositionState)
                
            } label: {
                Text("Replay position")
            }
            .buttonStyle(.borderedProminent)
            .tint(.green)
            
        }
        
        
    }
    
}

struct ConnectToSpotifyView_Previews: PreviewProvider {
    static var previews: some View {
        ConnectToSpotifyView(spotifyController: SpotifyController())
    }
}
