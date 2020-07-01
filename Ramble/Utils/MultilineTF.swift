//
//  MultilineTF.swift
//  Ramble
//
//  Created by Peter Keating on 6/30/20.
//  Copyright © 2020 Peter Keating. All rights reserved.
//

import SwiftUI

struct MultiLineTF: UIViewRepresentable {
    
    @Binding var txt : String
    
    func makeCoordinator() -> MultiLineTF.Coordinator {
        
        return MultiLineTF.Coordinator(parent1: self)
    }
    
    func makeUIView(context: UIViewRepresentableContext<MultiLineTF>) -> UITextView {
        
        let tview = UITextView()
        tview.isEditable = true
        tview.isUserInteractionEnabled = true
        tview.isScrollEnabled = true
        tview.text = "Type your bio here"
        tview.font = .systemFont(ofSize: 18, weight: .bold)
        tview.delegate = context.coordinator
        return tview
    }
    
    func updateUIView(_ uiView: UITextView, context: UIViewRepresentableContext<MultiLineTF>) {
        
    }
    
    class Coordinator : NSObject, UITextViewDelegate {
        
        var parent : MultiLineTF
        
        init(parent1 : MultiLineTF) {
            
            parent = parent1
        }
        
        func textViewDidChange(_ textView: UITextView) {
            self.parent.txt = textView.text
        }
        
        func textViewDidBeginEditing(_ textView: UITextView) {
            textView.text = ""
            textView.textColor = .label
        }
    }
}
