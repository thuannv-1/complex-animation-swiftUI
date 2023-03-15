//
//  RatingView.swift
//  complex-animation
//
//  Created by Nguyen Van Thuan on 14/03/2023.
//

import SwiftUI

struct RatingView: View {
    var rating: Int
    
    var body: some View {
        HStack(spacing: 4) {
            ForEach(1...5, id: \.self) { index in
                Image(systemName: "star.fill")
                    .font(.caption2)
                    .foregroundColor(index <= rating ? .yellow : .secondary)
            }
            
            Text("(\(rating))")
                .fontWeight(.semibold)
                .foregroundColor(.yellow)
        }
    }
}
