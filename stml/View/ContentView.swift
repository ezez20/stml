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
    
    
// MARK: - View
    var body: some View {
        
        NavigationView {
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
                    print("Refresh")
                   spotifyController.updating()
                   print("DDD UPDATE2: \(spotifyController.trackLabelText)")
                   
                } label: {
                    Text("Refresh")
                }
                .buttonStyle(.borderedProminent)
                .tint(.green)
            }
        
        }.onChange(of: spotifyController.trackLabelText) { v in
            print("V: \(v)")
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
