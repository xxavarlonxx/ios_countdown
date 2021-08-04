//
//  EventCard.swift
//  Countdown
//
//  Created by Andre Hochschulte on 04.08.21.
//

import SwiftUI
import UIKit

struct EventCardView: View {
    var event: Event
    
    var body: some View {
        ZStack(){
            Rectangle()
                .fill()
                .frame(width: .infinity, height: 150)
                .foregroundColor(event.color.value)
                .cornerRadius(8)
                .shadow(radius: 2)
            HStack(){
                VStack(alignment: .leading, spacing: 4){
                    Text(event.title)
                        .font(.title)
                        .bold()
                        .foregroundColor(.white)
                        .lineLimit(2)
                    Text(event.targetDateTime, style: .date)
                        .font(.caption)
                        .foregroundColor(.white)
                        .lineLimit(1)
                }
                Spacer()
                ZStack(){
                    Circle()
                        .fill()
                        .frame(width: 75, height: 75)
                        .foregroundColor(Color(UIColor.darkGray))
                    VStack(){
                        Text("12")
                            .font(.title)
                            .bold()
                            .foregroundColor(Color.white)
                        Text("Days")
                            .font(.subheadline)
                            .foregroundColor(Color.white)
                            
                    }.multilineTextAlignment(.center)
                    
                    
                }
                
               
            }.padding(.horizontal, 16.0)
        }
    }
}

struct EventCard_Previews: PreviewProvider {
    static var previews: some View {
        EventCardView(event: Event.dummyEvent)
    }
}
