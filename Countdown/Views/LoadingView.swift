//
//  LoadingView.swift
//  Countdown
//
//  Created by Andre Hochschulte on 21.08.21.
//

import SwiftUI
import SwiftUIX

struct LoadingView: View {
    
    @Binding var isPresented: Bool
    var text: String
    
    var body: some View {
        if isPresented {
            GeometryReader{ proxy in
                ZStack{
                    Rectangle()
                        .fill(Color.clear)
                        .frame(width: proxy.size.width, height: proxy.size.height)
                        .edgesIgnoringSafeArea(.all)
                    VStack(spacing: 10){
                        ActivityIndicator().animated(true).style(.large).tintColor(.white)
                        Text(text).bold().font(.headline)
                    }
                    .padding()
                    .padding(.horizontal, 32)
                    .foregroundColor(.white)
                    .background(Rectangle()
                                    .fill(Color(.systemGray))
                                    .cornerRadius(8)
                    )
                }
            }
        }else{
            EmptyView()
        }
        
    }
}

struct LoadingView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingView(isPresented: .constant(false), text: "Loading")
    }
}
