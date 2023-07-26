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
//        textView.inputAccessoryView = makeToolbar()
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
    
//    func makeToolbar() -> UIToolbar {
//           let toolbar = UIToolbar()
//           toolbar.barStyle = .default
//           let doneButton = UIBarButtonItem(title: "Done", style: .done, target: context.coordinator, action: #selector(don))
//           let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
//           toolbar.items = [spacer, doneButton]
//           toolbar.sizeToFit()
//           return toolbar
//       }
//
//    @objc func doneButtonTapped() {
//        self.view.endEditing(true) // Hide the keyboard
//          }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }
    
    class Coordinator: NSObject, UITextViewDelegate {
        var parent: ScrollableTextEditor
        var previousRect = CGRectZero
        
        init(parent: ScrollableTextEditor) {
            self.parent = parent
        }
        
        func textViewDidChange(_ textView: UITextView) {
            parent.text = textView.text
            parent.scrollOffset = textView.contentOffset
            
            var pos = textView.endOfDocument
            var currentRect = textView.caretRect(for: pos)
            if(currentRect.origin.y > previousRect.origin.y){
                //new line reached, write your code
                print("New line started")
            }
            if currentRect.origin.y > UIScreen.main.bounds.height/2 - 20{
                self.parent.scrollOffset = CGPoint(x: 0, y: UIScreen.main.bounds.midX + 20)
            }
            previousRect = currentRect
        }
        
        func textViewDidEndEditing(_ textView: UITextView) {
            self.parent.scrollOffset = CGPoint(x: 0, y: 0)
        }
    }
}

