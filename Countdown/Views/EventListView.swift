//
//  EventListView.swift
//  Countdown
//
//  Created by Andre Hochschulte on 04.08.21.
//

import SwiftUI
import UIKit
import Combine

struct EventListView: View {
    
    @StateObject var vm: ViewModel = .init()
    @EnvironmentObject var state: AppState
    
        
    var body: some View {
       
        
        return ScrollView(.vertical, showsIndicators: false){
            LazyVStack(spacing: 12){
                ForEach(vm.events, id: \.self){ event in
                    EventCardView(event: event)
                }
            }
        }
        .padding(.horizontal, 8)
        .padding(.top, 10)
        .onAppear(perform: vm.onAppear)
    }
}

struct EventListView_Previews: PreviewProvider {
    static var previews: some View {
        EventListView()
    }
}

extension EventListView {
    final class ViewModel: ObservableObject {
        @Published var events: [EventMO] = [EventMO]()
        
        private var dataStorage: EventDataStorage
        private var cancellable: AnyCancellable?
        
        init(dataStorage: EventDataStorage = CDEventDataStorage.shared) {
            self.dataStorage = dataStorage
        }
        
        func onAppear(){
            cancellable = self.dataStorage.getAllEvents().sink { [weak self] events in
                self?.events = events
            }
        }
    }
}
