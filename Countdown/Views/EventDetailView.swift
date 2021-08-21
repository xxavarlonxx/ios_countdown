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
                VStack {
                    Text(vm.eventName)
                        .font(.largeTitle)
                        .bold()
                        .foregroundColor(.white)
                    Spacer()
                    if vm.timerItems.count == 0 {
                        ActivityIndicator().animated(true).style(.large)
                            .tintColor(Color.white)
                    }
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
        
        private var event: EventMO
        private var timerService: TimerService
        private var cancellable: AnyCancellable?
        
        init(timerService: TimerService = CountdownTimerService.init(), event: EventMO) {
            self.timerService = timerService
            self.event = event
            self.backgroundColor = event.eventColor.color
            self.eventName = event.title ?? ""
            cancellable = timerService.getTimerItems().sink { timerItems in
                self.timerItems = timerItems
            }
        }
        
        func updateDeltaTime(currentDateTime: Date){
            guard let targetDateTime = event.targetDateTime else {return}
            timerService.updateDeltaTimeFrom(currentDateTime, to: targetDateTime)
        }
    }
}
