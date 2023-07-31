//
//  ReadView.swift
//  stml
//
//  Created by Ezra Yeoh on 7/12/23.
//

import SwiftUI

struct ReadView: View {
    @State private var dummyData = [1,2,3,4,5]
    
    let layout = [
        GridItem(.adaptive(minimum: 100))
    ]
    
    var body: some View {
        
        NavigationStack {
            
            LazyVGrid(columns: layout) {
                ForEach(dummyData, id: \.self) { journal in
                    NavigationLink {
                        ReadJournalView()
                    } label: {
                        Rectangle()
                            .frame(width: 80, height: 120)
                            .cornerRadius(5)
                            .foregroundColor(.brown)
                            .padding()
                    }
                    .navigationTitle("Journal")
                }
            }
            .background(.green)
            
        }
     
        
    }
    
}

struct ReadView_Previews: PreviewProvider {
    static var previews: some View {
        ReadView()
    }
}
