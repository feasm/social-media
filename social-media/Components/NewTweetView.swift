//
//  NewTweetView.swift
//  social-media
//
//  Created by Felipe Alexander Da Silva Melo on 27/08/22.
//

import SwiftUI
import Combine

struct NewTweetView: View {
    let imageSize: CGFloat = 60
    
    @Binding var newPost: String
    @Binding var numberOfLettersLeft: String
    @Binding var quotePost: PostViewData?
    @Binding var isFocused: Bool {
        didSet {
            __isFocused = isFocused
        }
    }
    @FocusState var __isFocused: Bool
    
    let username: String
    let onTweetButtonPressed: () -> Void
    
    var body: some View {
        HStack {
            VStack {
                Image(systemName: "person.circle")
                    .frame(width: imageSize, height: imageSize)
                    .font(.largeTitle)
                
                Text("@" + username)
            }
            
            ZStack {
                if !__isFocused {
                    HStack {
                        Text("What's happening?")
                            .foregroundColor(.lightGray)
                        
                        Spacer()
                    }
                }
                
                VStack {
                    TextEditor(text: $newPost)
                        .opacity(__isFocused ? 1 : 0.1)
                        .focused($__isFocused)
                        .frame(height: 40)
                    
                    if __isFocused {
                        if let quotePost = quotePost {
                            PostView(viewData: quotePost,
                                     onShareEvent: nil,
                                     onQuoteEvent: nil)
                                .border(.gray, width: 1)
                                .cornerRadius(3)
                        }
                        
                        HStack {
                            Spacer()
                            
                            Text(numberOfLettersLeft)
                                .font(.footnote)
                        }
                    }
                    
                    if isFocused {
                        Text("")
                            .opacity(0)
                            .onAppear {
                                __isFocused = isFocused
                            }
                    }
                }
            }
            
            
            Button("Tweet") {
                __isFocused = false
                onTweetButtonPressed()
            }
            .foregroundColor(.primaryBlue)
        }
    }
}

//struct NewTweetView_Previews: PreviewProvider {
//    static var previews: some View {
//        NewTweetView(newPost: "") {}
//            .previewLayout(.fixed(width: 400, height: 120))
//    }
//}
