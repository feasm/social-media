//
//  PostView.swift
//  social-media
//
//  Created by Felipe Alexander Da Silva Melo on 27/08/22.
//

import SwiftUI

struct PostView: View {
    private let imageSize: CGFloat = 60
    private var isAnswer: Bool = false
    private var viewData: PostViewData
    private let onShareEvent: (() -> Void)?
    private let onQuoteEvent: (() -> Void)?
    
    init(viewData: PostViewData, onShareEvent: (() -> Void)? = nil, onQuoteEvent: (() -> Void)? = nil) {
        self.viewData = viewData
        self.onShareEvent = onShareEvent
        self.onQuoteEvent = onQuoteEvent
    }
    
    var body: some View {
        VStack(spacing: DesignSystem.Spacing.verySmall) {
            if viewData.isRepost {
                HStack(spacing: DesignSystem.Spacing.verySmall) {
                    Image(systemName: "arrow.2.squarepath")
                        .padding([.leading], 39)
                    
                    Text(viewData.repostUsername ?? "")
                    
                    Spacer()
                }
                .foregroundColor(.lightGray)
            }
            
            if isAnswer {
                HStack{
                    Text("In answer to")
                        .foregroundColor(.lightGray)
                    Button {
                        
                    } label: {
                        Text("@johnz")
                    }
                    .foregroundColor(.primaryBlue)

                }
            }
            
            HStack(alignment: .top, spacing: DesignSystem.Spacing.small) {
                Image(systemName: "person.circle")
                    .frame(width: imageSize, height: imageSize)
                    .font(.largeTitle)

                VStack(alignment: .leading, spacing: DesignSystem.Spacing.small) {
                    HStack {
                        Text("@" + viewData.username)
                            .bold()
                        
                        Spacer()
                        
                        Text(viewData.creationDate)
                            .foregroundColor(.lightGray)
                    }

                    Text(viewData.text)
                        .font(.body)
                    
                    if let viewData = viewData.quoteViewData {
                        PostView(viewData: viewData)
                            .border(.gray, width: 1)
                            .cornerRadius(3)
                    }

                    HStack(spacing: DesignSystem.Spacing.veryBig) {
                        if onQuoteEvent != nil {
                            Button {
                                onQuoteEvent?()
                            } label: {
                                Image(systemName: "bubble.right")
                            }
                        }

                        if onShareEvent != nil {
                            Button {
                                onShareEvent?()
                            } label: {
                                Image(systemName: "arrow.2.squarepath")
                            }
                        }

                        Spacer()
                    }
                    .foregroundColor(.lightGray)
                }
            }
        }
        .padding([.bottom, .top, .trailing], DesignSystem.Margin.small)
    }
}

struct PostView_Previews: PreviewProvider {
    static var previews: some View {
        let viewData = PostViewData(username: "johnz", text: "This is a message!", repostUsername: "", creationDate: "August 25, 2021")
        PostView(viewData: viewData)
            .previewLayout(.sizeThatFits)
    }
}
