//
//  ReadView.swift
//  stml
//
//  Created by Ezra Yeoh on 7/12/23.
//

import SwiftUI

struct ReadView: View {
    var body: some View {
        GeometryReader { geo in
            ZStack {
                Text("Read View")
            }
            .frame(width: geo.size.width, height: geo.size.height)
            .background(.blue)
            
        }
    }
}

struct ReadView_Previews: PreviewProvider {
    static var previews: some View {
        ReadView()
    }
}
