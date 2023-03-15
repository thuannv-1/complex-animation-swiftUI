//
//  ScrollViewDetector.swift
//  complex-animation
//
//  Created by Nguyen Van Thuan on 14/03/2023.
//

import SwiftUI

struct ScrollViewDetector: UIViewRepresentable {
    @Binding var caroselMode: Bool
    var totalCardCount: Int
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }
    
    func makeUIView(context: Context) -> UIView {
        return UIView()
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        DispatchQueue.main.async {
            if let scrollView = uiView
                .superview?
                .superview?
                .superview as? UIScrollView {
                scrollView.decelerationRate = caroselMode ? .fast : .normal
                
                context.coordinator.totalCount = totalCardCount
                if caroselMode {
                    scrollView.delegate = context.coordinator
                } else {
                    scrollView.delegate = nil
                }
            }
        }
    }
    
    class Coordinator: NSObject, UIScrollViewDelegate {
        var parent: ScrollViewDetector
        
        var totalCount: Int = 0
        var velocityY: CGFloat = 0
        
        init(parent: ScrollViewDetector) {
            self.parent = parent
        }
        
        
        func scrollViewWillEndDragging(_ scrollView: UIScrollView,
                                       withVelocity velocity: CGPoint,
                                       targetContentOffset: UnsafeMutablePointer<CGPoint>) {
            let cardHeight: CGFloat = 220
            let cardSpacing: CGFloat = 36
            
            let targetEnd: CGFloat = scrollView.contentOffset.y + (velocity.y * 60)
            let index = (targetEnd / cardHeight).rounded()
            
            let modifyEnd = index * cardHeight
            let spacing = index * cardSpacing
            
            targetContentOffset.pointee.y = modifyEnd + spacing
            velocityY = velocity.y
        }
        
        func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
            let cardHeight: CGFloat = 220
            let cardSpacing: CGFloat = 36
            
            let targetEnd: CGFloat = scrollView.contentOffset.y + (velocityY * 60)
            let index = max(min((targetEnd / cardHeight).rounded(),
                                CGFloat(totalCount - 1)),
                            0.0)
            
            let modifyEnd = index * cardHeight
            let spacing = index * cardSpacing
            
            scrollView.setContentOffset(.init(x: 0, y: modifyEnd + spacing - cardHeight),
                                        animated: true)
        }
    }
}
