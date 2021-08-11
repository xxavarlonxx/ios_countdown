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
    
    @StateObject var vm: ViewModel = ViewModel()
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false){
            LazyVStack(spacing: 12){
                ForEach(vm.events, id: \.self){
                    EventCardView(event: $0, onEdit: onEdit, onDelete: onDelete)
                }
            }
        }
        .padding(.horizontal, 8)
        .padding(.top, /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
        .onAppear(perform: vm.onAppear)
        .sheet(item: $vm.eventEditSelection){ item in
            EditEventView(event: item)
        }
        
    }
    
    func onEdit(event: EventMO){
        vm.eventEditSelection = event
    }
    
    func onDelete(event: EventMO){
        vm.eventDeleteSelection = event
    }
}

struct EventListView_Previews: PreviewProvider {
    static var previews: some View {
        EventListView()
    }
}

extension EventListView {
    final class ViewModel: ObservableObject {
        @Published var events: [EventMO] = []
        @Published var eventEditSelection: EventMO?
        @Published var eventDeleteSelection: EventMO?
        
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
