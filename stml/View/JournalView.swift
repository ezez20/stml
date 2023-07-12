//
//  JournalView.swift
//  stml
//
//  Created by Ezra Yeoh on 7/12/23.
//

import SwiftUI

struct JournalView: View {
    var body: some View {
        GeometryReader { geo in
            VStack {
                Text("Journal View")
                    .frame(width: 100, height: 30)
            }
            .frame(width: geo.size.width, height: geo.size.height)
            .background(.yellow)
        }
    }
}

struct JournalView_Previews: PreviewProvider {
    static var previews: some View {
        JournalView()
    }
}
