//
//  TabBarView.swift
//  stml
//
//  Created by Ezra Yeoh on 7/12/23.
//

import SwiftUI

struct TabBarView: View {
    var body: some View {
        HStack {
            
            Spacer()
            
            Button { }
            label: {
                VStack {
                    Image(systemName: "text.book.closed")
                        .foregroundColor(.gray)
                    Text("Read")
                        .font(.footnote)
                        .foregroundColor(.gray)
                    
                }
            }
            .frame(width: 50, height: 30)
            .padding()
            
            Spacer()
            
            
            Button { }
            label: {
                VStack {
                    Image(systemName: "camera")
                        .foregroundColor(.gray)
                    Text("Capture")
                        .font(.footnote)
                        .foregroundColor(.gray)
                }
            }
            .frame(width: 50, height: 30)
            .padding()
            
            Spacer()
            
            Button { }
            label: {
                VStack {
                    Image(systemName: "square.and.pencil")
                        .foregroundColor(.gray)
                    Text("Journal")
                        .font(.footnote)
                        .foregroundColor(.gray)
                }
            }
            .frame(width: 50, height: 30)
            .padding()
            
            Spacer()
        }
        .background(.green)
    }
}

struct TabBarView_Previews: PreviewProvider {
    static var previews: some View {
        TabBarView()
    }
}
