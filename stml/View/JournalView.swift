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
    var body: some View {
        
        GeometryReader { geo in
            
            ZStack {
                
//                TextEditor(text: $textField)
//                    .accentColor(.yellow)
//                    .scrollContentBackground(.hidden)
//                    .background(.gray)
//                    .background(Color("customYellow"))
//                    .padding()
//                    .position(x: geo.size.width/2, y: geo.size.height/2)
////                    .frame(width: geo.size.width, height: geo.size.height - 20)
//                    .frame(width: geo.size.width, height: geo.size.height - 20)
//                    .focused($noteIsFocused)
//                    .toolbar {
//                        ToolbarItemGroup(placement: .keyboard) {
//                            Spacer()
//                            Button {
//                                noteIsFocused = false
//                            } label: {
//                                Image(systemName: "chevron.down")
//                                    .foregroundColor(.yellow)
//                            }
//
//                        }
//                    }
//                    .onAppear {
//                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
//                            noteIsFocused = true
//                        }
//                    }
                ScrollView {
                    ScrollableTextEditor(text: $textField)
                        .background(Color("customYellow"))
                        .padding()
                        .frame(width: geo.size.width, height: geo.size.height - 40)
                        .focused($noteIsFocused)
                        .toolbar {
                            ToolbarItemGroup(placement: .keyboard) {
                                Spacer()
                                Button {
                                    noteIsFocused = false
                                } label: {
                                    Image(systemName: "chevron.down")
                                        .foregroundColor(.yellow)
                                }
                                
                            }
                        }
                        .onAppear {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                noteIsFocused = true
                                
                            }
                        }
                }
                .position(x: geo.size.width/2, y: geo.size.height/2 + 40)
                
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
                        UIApplication.shared.keyWindow?.endEditing(true)
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
                    Text("Jan 20, 2023")
                    Text("10:44 AM")
                        .font(.footnote)
                }
                .position(x: geo.size.width/2, y: 15)
            }
            .frame(width: geo.size.width, height: geo.size.height)
            .background(Color("customYellow"))
            
        }
        
    }
    
}

struct JournalView_Previews: PreviewProvider {
    static var previews: some View {
        JournalView(tabBarSelection: .constant(1))
    }
}
