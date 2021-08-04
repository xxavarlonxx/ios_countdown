//
//  ContentView.swift
//  Countdown
//
//  Created by Andre Hochschulte on 04.08.21.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView{
            ZStack {
                EventListView(events: Event.dummyEventList)
                VStack{
                    Spacer()
                    ZStack {
                        Circle()
                            .fill()
                            .frame(width: 100, height: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/)
                            .foregroundColor(Color(UIColor.black))
                        Image(systemName: "plus")
                            .resizable()
                            .frame(width: 35, height: 35)
                            .foregroundColor(.white)
                    }
                    
                }
                
                    
            }.navigationTitle("Next events")
           
            
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
