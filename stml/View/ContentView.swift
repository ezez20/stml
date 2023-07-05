//
//  ContentView.swift
//  stml
//
//  Created by Ezra Yeoh on 6/15/23.
//

import SwiftUI
import CoreData

struct ContentView: View {
    
    @Environment(\.managedObjectContext) private var viewContext

    
// MARK: - View
    var body: some View {
        
        NavigationView {
            VStack {
                Text("Connect to your Spotify Account")
                Button {
                    print("Connect to Spotify Button Tapped")
                } label: {
                    Text("Connect to Spotify")
                }
                .buttonStyle(.borderedProminent)
                .tint(.green)
            }
        }
        
    }

// MARK: - Functions

}


// MARK: - PreviewProvider
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
