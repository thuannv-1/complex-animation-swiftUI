//
//  DetailView.swift
//  complex-animation
//
//  Created by Nguyen Van Thuan on 14/03/2023.
//

import SwiftUI

struct DetailView: View {
    
    @Binding var show: Bool
    var book: Book
    var animation: Namespace.ID
    @State var animationContent: Bool = false
    @State var offsetAnimation: Bool = false
    
    var body: some View {
        VStack(spacing: 16) {
            
            Button {
                withAnimation(.easeIn(duration: 0.2)) {
                    offsetAnimation = false
                }
                
                withAnimation(.easeIn(duration: 0.35)) {
                    show = false
                    animationContent = false
                }
            } label: {
                Image(systemName: "chevron.left")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundColor(.black)
                    .contentShape(Rectangle())
            }
            .padding(.vertical, 16)
            .frame(maxWidth: .infinity, alignment: .leading)
            .opacity(animationContent ? 1 : 0)

            // Image Preview Matched GeometryReader Effect
            GeometryReader { reader in
                let size = reader.size
                
                HStack(spacing: 20) {
                    Image(book.imageName)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: (size.width) / 2, height: size.height)
                        /// Custome Corner Shape
                        .clipShape(RoundedRectangle(cornerRadius: 12,
                                                       style: .continuous))
                        .matchedGeometryEffect(id: book.id, in: animation)
                        .shadow(color: .black.opacity(0.1), radius: 5, x: 5, y: 5)
                        .shadow(color: .black.opacity(0.1), radius: 5, x: -5, y: -5)
                    
                    VStack(spacing: 8) {
                        Text(book.title)
                            .font(.title)
                            .fontWeight(.semibold)
                        
                        Text("By \(book.author)")
                            .font(.callout)
                            .foregroundColor(.gray)
                        
                        RatingView(rating: book.rating)
                    }
                    .offset(y: offsetAnimation ? 0 : 100)
                    .opacity(offsetAnimation ? 1 : 0)
                }
            }
            .frame(height: 220)
            
            // Description detail of book
            GeometryReader { reader in
                let size = reader.size
                
                VStack(alignment: .leading) {
                    Text("Book desriotion here")
                        .font(.title)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Rectangle().fill(.gray.opacity(0.2)))
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .offset(x: offsetAnimation ? 0 : -(size.width + 32))
            }
            .padding(.vertical, 16)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .padding(.horizontal, 16)
        .background(
            Rectangle()
                .fill(.white)
                .ignoresSafeArea()
                .opacity(animationContent ? 1 : 0)
        )
        .onAppear {
            withAnimation(.easeIn(duration: 0.35)) {
                animationContent = true
            }
            
            withAnimation(.easeIn(duration: 0.35).delay(0.15)) {
                offsetAnimation = true
            }
        }
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
