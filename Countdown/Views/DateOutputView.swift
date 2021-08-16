//
//  DateOutputView.swift
//  Countdown
//
//  Created by Andre Hochschulte on 15.08.21.
//

import SwiftUI

struct DateOutputView: View {
    
    @Binding var value: Int
    var unity: String = ""
    
    var body: some View {
        ZStack{
            Circle()
                .fill()
                .frame(width: 100, height: 100)
                .foregroundColor(Color.black.opacity(0.5))
            VStack(){
                Text("\(value)")
                    .font(.title)
                    .bold()
                    .foregroundColor(Theme.textColor)
                Text(unity)
                    .font(.subheadline)
                    .foregroundColor(Theme.textColor)
                
            }.multilineTextAlignment(.center)
        }
    }
}

struct DateOutputView_Previews: PreviewProvider {
    static var previews: some View {
        DateOutputView(value: .constant(1), unity: "Years")
    }
}
