//
//  EventListView.swift
//  Countdown
//
//  Created by Andre Hochschulte on 04.08.21.
//

import SwiftUI
import UIKit

struct EventListView: View {
    var events: [Event]
    
    var body: some View {
        ScrollView{
            LazyVStack(spacing: 12){
                ForEach(events, id: \.id){ event in
                    EventCardView(event: event)
                }
            }
        }
        .padding(.horizontal, 8)
        .padding(.top, /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
    }
}

struct EventListView_Previews: PreviewProvider {
    static var previews: some View {
        EventListView(events: Event.dummyEventList)
    }
}
