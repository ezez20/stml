//
//  AddNoteSheetView.swift
//  stml
//
//  Created by Ezra Yeoh on 7/24/23.
//

import SwiftUI

struct AddNoteSheetView: View {
    
    @State private var textField = ""
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        
        GeometryReader { geo in
            VStack {
                HStack {
                    
                    Button {
                        // Dismiss
                        dismiss()
                    } label: {
                        Image(systemName: "chevron.down")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 20, height: 20)
                            .foregroundColor(.gray)
                            .padding()
                    }
                    
                    Spacer()
                    
                    Text("Jul 25")
                        .font(.subheadline).bold()
                        .padding()
                    
                    Spacer()
                    
                    Button {
                        
                    } label: {
                        Image(systemName: "book.closed.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 20, height: 20)
                            .foregroundColor(.yellow)
                            .padding()
                    }
                }
                .background(.white)
                
                TextField("Thoughts of the day...", text: $textField, axis: .vertical)
                    .textFieldStyle(.plain)
                    .background(Color("customYellow"))
                    .lineLimit(4...4)
                    .padding()
                
                
            }
            .frame(width: geo.size.width)
            .background(Color("customYellow"))
            
        }
    }
    
}

struct AddNoteSheetView_Previews: PreviewProvider {
    static var previews: some View {
        AddNoteSheetView()
    }
}
