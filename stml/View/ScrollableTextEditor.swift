//
//  ScrollableTextEditor.swift
//  stml
//
//  Created by Ezra Yeoh on 7/26/23.
//

import SwiftUI

struct ScrollableTextEditor: UIViewRepresentable {
    @Binding var text: String
//    @Binding var scrollOffset: CGPoint
    @State var scrollOffset = CGPoint()

    
    func makeUIView(context: Context) -> UITextView {
        let textView = UITextView()
        textView.delegate = context.coordinator
        textView.isScrollEnabled = true
        textView.isEditable = true
        textView.backgroundColor = UIColor.clear
        textView.text = text
        textView.font = UIFont.systemFont(ofSize: 20)
        textView.tintColor = .systemYellow

        return textView
    }
    
    func updateUIView(_ uiView: UITextView, context: Context) {
        if uiView.text != text {
            uiView.text = text
        }
        if uiView.contentOffset != scrollOffset {
            uiView.setContentOffset(scrollOffset, animated: false)
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }
    
    class Coordinator: NSObject, UITextViewDelegate {
        var parent: ScrollableTextEditor
        var previousRect = CGRectZero
        @ObservedObject var keyboardHeightHandler = KeyboardHeightHandler()
        
        init(parent: ScrollableTextEditor) {
            self.parent = parent
        }
        
        func textViewDidChange(_ textView: UITextView) {
            parent.text = textView.text
            parent.scrollOffset = textView.contentOffset
            
            let pos = textView.endOfDocument
            let currentRect = textView.caretRect(for: pos)
            if(currentRect.origin.y > previousRect.origin.y) || (currentRect.origin.y < previousRect.origin.y) {
                //new line reached, write your code
                print("New line started OR New line deleted")
                
                if currentRect.maxY > keyboardHeightHandler.keyboardHeight + 60 {
                    print("Text went passed keyboard ")
                    let yOffset = currentRect.maxY - (UIScreen.main.bounds.height - keyboardHeightHandler.keyboardHeight - 120)
                    self.parent.scrollOffset = CGPoint(x: 0, y: yOffset)
                }
                
            }

            previousRect = currentRect
        }
        
        func textViewDidBeginEditing(_ textView: UITextView) {
            textView.selectedTextRange = textView.textRange(from: textView.beginningOfDocument, to: textView.endOfDocument)
        }
        
        func textViewDidEndEditing(_ textView: UITextView) {
            self.parent.scrollOffset = CGPoint(x: 0, y: 0)
        }
    }
}


