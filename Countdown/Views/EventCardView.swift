//
//  EventCard.swift
//  Countdown
//
//  Created by Andre Hochschulte on 04.08.21.
//

import SwiftUI
import SwipeCell
import Combine

struct EventCardView: View {
    
    @StateObject var viewModel: EventCardViewModel
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var theme: Theme
    
    init(event: EventMO = .init()) {
        let vm = EventCardViewModel(event: event)
        _viewModel = StateObject(wrappedValue: vm)
    }
    
    var body: some View {
        let deleteButton = SwipeCellButton(buttonStyle: .image, title: "Delete", systemImage: "trash", view: nil, backgroundColor: Color.red) {
            viewModel.eventDeleteSelection = viewModel.event
        }
        
        let swipeSlot = SwipeCellSlot(slots: [deleteButton], slotStyle: .destructive, buttonWidth: 80)
        
        ZStack(){
            Rectangle()
                .fill()
                .frame(width: .infinity, height: 150)
                .foregroundColor(viewModel.event.eventColor.color)
                .cornerRadius(8)
                .shadow(radius: 2)
            HStack(){
                VStack(alignment: .leading, spacing: 4){
                    Text(viewModel.event.title ?? "")
                        .font(.title)
                        .bold()
                        .foregroundColor(theme.primaryTextColor)
                        .lineLimit(2)
                    Text(viewModel.event.targetDateTime ?? Date(), style: .date)
                        .font(.caption)
                        .foregroundColor(theme.primaryTextColor)
                        .lineLimit(1)
                }
                Spacer()
                VStack{
                    ZStack(){
                        Circle()
                            .fill()
                            .frame(width: 75, height: 75)
                            .foregroundColor(Color.black.opacity(0.5))
                        VStack(){
                            if viewModel.eventTargetIsInThePast(){
                                Image(systemName: "checkmark.circle")
                                    .resizable()
                                    .frame(width: 50, height: 50)
                                    .foregroundColor(theme.primaryTextColor)
                            }else{
                                Text("\(viewModel.event.delta.0)")
                                    .font(.title)
                                    .bold()
                                    .foregroundColor(theme.primaryTextColor)
                                Text(viewModel.event.delta.1)
                                    .font(.subheadline)
                                    .foregroundColor(theme.primaryTextColor)
                            }
                            
                            
                        }.multilineTextAlignment(.center)
                    }
                }
            }.padding(.horizontal, 16.0)
        }
        .background(NavigationLink(
            destination: EventDetailView(event: viewModel.event),
            isActive: $viewModel.isActive){
            EmptyView()
        })
        .onTapGesture {
            viewModel.isActive = true
        }
        .onLongPressGesture{
            viewModel.eventEditSelection = viewModel.event
        }
        .dismissSwipeCellForScrollViewForLazyVStack()
        .swipeCell(cellPosition: .right, leftSlot: nil, rightSlot: swipeSlot)
        .sheet(item: $viewModel.eventEditSelection){ item in
            EditEventView(event: item)
        }
        .alert(item: $viewModel.eventDeleteSelection) { item in
            Alert(title: Text("Delete Event"),
                  message: Text("Do you really want to delete Event \(item.title!)?"),
                  primaryButton: .destructive(Text("Yes"), action: {
                    deleteTapped(item: item)
                  }),
                  secondaryButton: .cancel(Text("No"), action: {
                    dismissDestructiveDelayButton()
                  }))
        }
        
        
    }
    
    func deleteTapped(item: EventMO) {
        appState.isLoading = true
        viewModel.deleteEvent(event: item)
        appState.isLoading = false
    }
}

struct EventCard_Previews: PreviewProvider {
    static var previews: some View {
        EventCardView()
    }
}


extension EventCardView {
    
    final class EventCardViewModel: ObservableObject {
        @Published var event: EventMO
        @Published var isActive: Bool = false
        @Published var eventEditSelection: EventMO?
        @Published var eventDeleteSelection: EventMO?
        @Published var eventFinishedSelection: EventMO?
        
        private var dataStorage: EventDataStorage
        private var notificsationService: NotificationService
        
        private var cancellable: AnyCancellable?
        
        init(dataStorage: EventDataStorage = StorageManager.shared,
             notificationService: NotificationService = NotificationManager.shared,
             event: EventMO) {
            self.dataStorage = dataStorage
            self.notificsationService = notificationService
            self.event = event
            
            cancellable = self.notificsationService.subcribeToSelectedEvent().sink(receiveValue: { eventId in
                if self.event.idValue.uuidString == eventId {
                    print("Sinking Event \(eventId)")
                    self.isActive = true
                }
            })
            
        }

        func deleteEvent(event: EventMO){
            self.dataStorage.deleteEvent(event: event)
            notificsationService.deleteNotificationForEvent(event)
        }
        
        func eventTargetIsInThePast()-> Bool{
            return event.targetDateTimeValue <= Date()
        }
    }
}

