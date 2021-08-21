//
//  DateOutputView.swift
//  Countdown
//
//  Created by Andre Hochschulte on 15.08.21.
//

import SwiftUI

struct TimerItemView: View {
    
    @EnvironmentObject var theme: Theme
    var timerItem: TimerItem
    
    var body: some View {
        ZStack{
            Circle()
                .fill()
                .frame(width: 100, height: 100)
                .foregroundColor(Color.black.opacity(0.5))
            VStack(){
                Text("\(timerItem.value)")
                    .font(.title)
                    .bold()
                    .foregroundColor(theme.primaryTextColor)
                Text(timerItem.unity)
                    .font(.subheadline)
                    .foregroundColor(theme.primaryTextColor)
                
            }.multilineTextAlignment(.center)
        }
    }
}

struct DateOutputView_Previews: PreviewProvider {
    static var previews: some View {
        TimerItemView(timerItem: TimerItem.dummyTimerItem())
    }
}
