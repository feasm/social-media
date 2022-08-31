//
//  UIKitView.swift
//  social-media
//
//  Created by Felipe Alexander Da Silva Melo on 27/08/22.
//

import SwiftUI

struct UIKitView: UIViewRepresentable {
    let viewBuilder: () -> UIView
    
    init(_ viewBuilder: @escaping () -> UIView) {
        self.viewBuilder = viewBuilder
    }
    
    func makeUIView(context: Context) -> some UIView {
        return viewBuilder()
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        
    }
}
