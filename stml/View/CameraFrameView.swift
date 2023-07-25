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
                    .onAppear {
                        print("Image view")
                    }
            } else if let takenImage = takenImage {
                Image(uiImage: takenImage)
                    .frame(width: geo.size.width, height: geo.size.height)
                    .onAppear {
                        print("takenImage view")
                    }
            } else {
                Color.black
                    .frame(width: geo.size.width, height: geo.size.height)
                    .onAppear {
                        print("black view")
                    }
            }
        }
        
    }
}

struct FrameView_Previews: PreviewProvider {
    static var previews: some View {
        CameraFrameView()
    }
}
