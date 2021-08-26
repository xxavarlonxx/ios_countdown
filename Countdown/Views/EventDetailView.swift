//
//  EventDetailView.swift
//  Countdown
//
//  Created by Andre Hochschulte on 15.08.21.
//

import SwiftUI
import Combine
import SwiftUIX

struct EventDetailView: View {

    
    @EnvironmentObject var theme: Theme
    @StateObject var vm: ViewModel
    var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    
    init(event: EventMO = .init()) {
        let vm = ViewModel(event: event)
        _vm = StateObject(wrappedValue: vm)
    }
    
    var body: some View {
        GeometryReader{ proxy in
            ZStack{
                vm.backgroundColor.ignoresSafeArea()
                VStack(spacing: 16) {
                    Text(vm.eventName)
                        .font(.largeTitle)
                        .bold()
                        .foregroundColor(theme.primaryTextColor)
                    Spacer()
                    
                    if vm.timerItems.count == 0 {
                        ActivityIndicator().animated(true).style(.large)
                            .tintColor(theme.primaryTextColor)
                    }else{
                        Text(vm.targetTimeIsInThePast ? "detail_event_time_headline_since" : "detail_event_time_headline_left")
                            .bold()
                            .font(.title)
                            .foregroundColor(theme.primaryTextColor)
                        HStack{
                            ForEach(vm.timerItems.indices, id: \.self) { index in
                                if index < 3 {
                                    TimerItemView(timerItem: vm.timerItems[index])
                                }
                            }
                        }
                        
                        if vm.timerItems.count > 3 {
                            HStack{
                                ForEach(vm.timerItems.indices, id: \.self) { index in
                                    if index > 2 {
                                        TimerItemView(timerItem: vm.timerItems[index])
                                    }
                                }
                            }
                        }
                    }
                    Spacer()
                    
                }
                .frame(width: proxy.size.width, height: proxy.size.height)
                .onReceive(timer, perform: { time in
                    vm.updateDeltaTime(currentDateTime: time)
                })
            }
        }
    }
}

struct EventDetailView_Previews: PreviewProvider {
    static var previews: some View {
        EventDetailView(event: EventMO.dummyEvent)
    }
}

extension EventDetailView {
    final class ViewModel: ObservableObject{
        @Published var backgroundColor: Color
        @Published var eventName: String = ""
        @Published var timerItems: [TimerItem] = []
        @Published var targetTimeIsInThePast: Bool = false
        
        private var event: EventMO
        private var timerService: TimerService
        private var cancellable: AnyCancellable?
        
        init(timerService: TimerService = TimerManager.init(), event: EventMO) {
            self.timerService = timerService
            self.event = event
            self.backgroundColor = event.eventColor.color
            self.eventName = event.title ?? ""
            cancellable = timerService.getTimerItems().sink { timerItems in
                self.timerItems = timerItems
            }
        }
        
        func updateDeltaTime(currentDateTime: Date){
            var from = currentDateTime
            var to = event.targetDateTimeValue
            
            if to <= from {
                targetTimeIsInThePast = true
                from = event.targetDateTimeValue
                to = currentDateTime
            }
            timerService.updateDeltaTimeFrom(from, to: to)
        }
    }
}
