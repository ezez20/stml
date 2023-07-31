//
//  JournalView.swift
//  stml
//
//  Created by Ezra Yeoh on 7/12/23.
//

import SwiftUI

struct JournalView: View {
    
    @State private var textField = ""
    @Binding var tabBarSelection: Int
    @FocusState private var noteIsFocused: Bool
    @State private var scrollOffset: CGPoint = .zero
    
    @State private var count = 0
    @ObservedObject private var keyboardHandler = KeyboardHeightHandler()
    
    var body: some View {
        
        GeometryReader { geo in
            
            ZStack {
                
                ScrollableTextEditor(text: $textField)
                    .background(Color("customYellow"))
                    .frame(width: geo.size.width - 40, height: geo.size.height - 40)
                    .position(x: geo.size.width/2, y: geo.size.height/2 + 20)
                    .focused($noteIsFocused)
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            noteIsFocused = true
                        }
                    }
                
                // Add button above keyboard to dismiss.
                if keyboardHandler.keyboardShowing && noteIsFocused {
                    Button {
                        noteIsFocused = false
                    } label: {
                        Image(systemName: "chevron.down")
                            .foregroundColor(.yellow)
                            .bold()
                            .padding()
                    }
                    .position(x: keyboardHandler.keyboardRect.maxX - 30, y: keyboardHandler.keyboardRect.minY - 70)
                }
                
                HStack {
                    
                    Button {
                        // Go back to MainScreenView
                        withAnimation {
                            noteIsFocused = false
                            tabBarSelection = 1
                        }
                        
                    } label: {
                        Image(systemName: "chevron.left")
                            .scaledToFit()
                            .foregroundColor(.black)
                            .bold()
                    }
                    .padding(10)
                    
                    Spacer()
                    
                    
                    Button {
                        noteIsFocused = false
                    } label: {
                        Image(systemName: "checkmark")
                            .scaledToFit()
                            .foregroundColor(.black)
                            .bold()
                    }
                    .padding(10)
                    
                }
                .padding()
                .frame(width: geo.size.width, height: 40)
                .position(x: geo.size.width/2, y: 15)
                .frame(width: geo.size.width, height: geo.size.height)
                
                VStack {
                    Text("\(Date.now.formatted(date: .abbreviated, time: .omitted))")
                    Text("\(Date.now.formatted(date: .omitted, time: .shortened))")
                        .font(.footnote)
                }
                .position(x: geo.size.width/2, y: 15)
            }
            .frame(width: geo.size.width, height: geo.size.height)
            .background(Color("customYellow"))
            .onChange(of: tabBarSelection) { _ in
                noteIsFocused = false
            }
        }
        
    }
    
}

struct JournalView_Previews: PreviewProvider {
    static var previews: some View {
        JournalView(tabBarSelection: .constant(1))
    }
}
