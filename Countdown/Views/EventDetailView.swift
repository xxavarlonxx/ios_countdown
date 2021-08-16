//
//  EventDetailView.swift
//  Countdown
//
//  Created by Andre Hochschulte on 15.08.21.
//

import SwiftUI

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
                    HStack{
                        DateOutputView(value: $vm.year, unity: "Years")
                        DateOutputView(value: $vm.month, unity: "Months")
                        DateOutputView(value: $vm.day, unity: "Days")
                        
                    }
                    HStack{
                        DateOutputView(value: $vm.hour, unity: "Hours")
                        DateOutputView(value: $vm.minute, unity: "Minutes")
                        DateOutputView(value: $vm.second, unity: "Seconds")
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
        @Published var year: Int = 0
        @Published var month: Int = 0
        @Published var day: Int = 0
        @Published var hour: Int = 0
        @Published var minute: Int = 0
        @Published var second: Int = 0
        @Published var eventName: String = ""
        
        private var event: EventMO
        
        init(event: EventMO) {
            self.event = event
            self.backgroundColor = event.eventColor.color
            self.eventName = event.title ?? ""
        }
        
        func updateDeltaTime(currentDateTime: Date){
            guard let eventDateTime = event.targetDateTime else {return}
            let calendar = Calendar.current
            let deltaComponents = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: currentDateTime, to: eventDateTime )
            self.year = deltaComponents.year!
            self.month =  deltaComponents.month!
            self.day = deltaComponents.day!
            self.hour = deltaComponents.hour!
            self.minute = deltaComponents.minute!
            self.second = deltaComponents.second!
        }
    }
}
