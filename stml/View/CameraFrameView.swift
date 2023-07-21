//
//  FrameView.swift
//  stml
//
//  Created by Ezra Yeoh on 7/20/23.
//

import SwiftUI

struct CameraFrameView: View {
    var image: CGImage?
    var takenImage: UIImage?
    private let label = Text("frame")
    
    var body: some View {
        
        GeometryReader { geo in
            if let image = image {
                Image(image, scale: 2.0, orientation: .up, label: label)
                    .frame(width: geo.size.width, height: geo.size.height)
            } else if takenImage != nil {
                Image(uiImage: takenImage!)
                    .frame(width: geo.size.width, height: geo.size.height)
                    .onAppear {
                        print("Taken Image: \(takenImage)")
                    }
            } else {
                Color.gray
                    .frame(width: geo.size.width, height: geo.size.height)
            }
        }
        
    }
}

struct FrameView_Previews: PreviewProvider {
    static var previews: some View {
        CameraFrameView()
    }
}
