//
//  Home.swift
//  complex-animation
//
//  Created by Nguyen Van Thuan on 13/03/2023.
//

import SwiftUI

var tags: [String] = ["History", "Classical", "Biagraphy", "Carton", "Advantrue", "Fairy", "Fantasy"]

struct Home: View {
    
    @State var activeTag: String = "Biagraphy"
    @State var caroselMode: Bool = false
    @Namespace private var animation
    
    @State var showDetail: Bool = false
    @State var selectedBook: Book?
    @State var animateCurrentBook: Bool = false
    
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Text("Browse")
                    .font(.largeTitle.bold())
                
                Text("Recommend")
                    .fontWeight(.semibold)
                    .foregroundColor(.secondary)
                    .padding(.leading, 16)
                    .offset(y: 2)
                
                Spacer(minLength: 10)
                
                Menu {
                    Button("Tuggle Carosel Mode: \(caroselMode ? "On" : "Off")") {
                        caroselMode.toggle()
                    }
                } label: {
                    Image(systemName: "ellipsis")
                        .rotationEffect(.init(degrees: 90))
                        .foregroundColor(.gray)
                }

            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 16)
            
            TagsView()
            
            GeometryReader { reader in
                let size = reader.size
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: 36) {
                        ForEach(sampleBooks, id: \.self) { book in
                            BookCardView(book)
                                .onTapGesture {
                                    withAnimation(.easeIn(duration: 0.15)) {
                                        animateCurrentBook = true
                                        selectedBook = book
                                    }
                                    
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                                        withAnimation(.interactiveSpring(response: 0.6,
                                                                         dampingFraction: 0.7,
                                                                         blendDuration: 0.7)) {
                                            showDetail = true
                                        }
                                    }
                                }
                        }
                    }
                    .padding(.bottom, bottomPadding(size))
                    .background {
                        ScrollViewDetector(caroselMode: $caroselMode,
                                           totalCardCount: sampleBooks.count)
                    }
                }
                .coordinateSpace(name: "SCROLLVIEW")
            }
        }
        .overlay {
            if let selectedBook, showDetail {
                DetailView(show: $showDetail, book: selectedBook, animation: animation)
                    .transition(.asymmetric(insertion: .identity, removal: .offset(y: 5)))
            }
        }
        .onChange(of: showDetail) { newValue in
            if !newValue {
                withAnimation(.linear(duration: 0.3).delay(0.2)) {
                    animateCurrentBook = false
                }
            }
        }
    }
    
    func bottomPadding(_ size: CGSize) -> CGFloat {
        let cardHeight: CGFloat = 220
        let scrollHeight: CGFloat = size.height
        return scrollHeight - cardHeight
    }
    
    @ViewBuilder
    func BookCardView(_ book: Book) -> some View {
        GeometryReader { reader in
            let size = reader.size
            let rect = reader.frame(in: .named("SCROLLVIEW"))
            
            HStack(spacing: -20) {
                VStack(alignment: .leading, spacing: 8) {
                    Text(book.title)
                        .font(.title3)
                        .fontWeight(.semibold)
                    
                    Text("By \(book.author)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    RatingView(rating: book.rating)
                    
                    Spacer(minLength: 4)
                    
                    HStack {
                        Text("\(book.bookView)")
                            .fontWeight(.semibold)
                            .foregroundColor(.cyan)
                        
                        Text("Views")
                            .font(.caption)
                            .foregroundColor(.gray)
                        
                        Spacer(minLength: 0)
                        
                        Image(systemName: "chevron.right")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                }
                .padding(20)
                .frame(width: size.width / 2, height: size.height*0.8)
                .background(
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .fill(.white)
                        .shadow(color: .black.opacity(0.08), radius: 8, x: 5, y: 5)
                        .shadow(color: .black.opacity(0.08), radius: 8, x: -5, y: -5)
                )
                .zIndex(1)
                .offset(x: animateCurrentBook && selectedBook?.id == book.id ? -(size.width / 2 + 20) : 0)
                
                ZStack {
                    if !(showDetail && selectedBook?.id == book.id) {
                        Image(book.imageName)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: size.width / 2, height: size.height)
                            .clipShape(RoundedRectangle(cornerRadius: 12,
                                                           style: .continuous))
                            .matchedGeometryEffect(id: book.id, in: animation)
                            .shadow(color: .black.opacity(0.1), radius: 5, x: 5, y: 5)
                            .shadow(color: .black.opacity(0.1), radius: 5, x: -5, y: -5)
                    }
                    
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            .frame(width: size.width)
            .padding(.vertical, 16)
            .rotation3DEffect(.init(degrees: converOffsetToRotation(rect)),
                              axis: (x: 1, y: 0, z: 0),
                              anchor: .bottom,
                              anchorZ: 1,
                              perspective: 0.8)
        }
        .frame(height: 220)
        .padding(.horizontal, 16)
    }
    
    @ViewBuilder
    func TagsView() -> some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(tags, id: \.self) { tag in
                    Text(tag)
                        .font(.caption)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background {
                            
                            if activeTag == tag {
                                Capsule()
                                    .fill(.blue)
                                    .matchedGeometryEffect(id: "ACTIVETAB",
                                                           in: animation)
                            } else {
                                Capsule()
                                    .fill(.secondary.opacity(0.2))
                            }
              
                        }
                        .foregroundColor(
                            activeTag == tag
                            ? .white
                            : .secondary
                        )
                        .onTapGesture {
                            withAnimation(.interactiveSpring(response: 0.5,
                                                             dampingFraction: 0.7,
                                                             blendDuration: 0.7))
                            {
                                activeTag = tag
                            }
                        }
                }
            }
        }
        .padding(.horizontal, 16)
    }
    
    func converOffsetToRotation(_ rect: CGRect) -> CGFloat {
        let cardHeight = rect.height
        let minY = rect.minY - 0
        let progress = minY < 0 ? (minY / cardHeight) : 0
        let constrainedProgress = min(-progress, 1.0)
        return constrainedProgress * 90.0
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
