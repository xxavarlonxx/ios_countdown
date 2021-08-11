//
//  EventCard.swift
//  Countdown
//
//  Created by Andre Hochschulte on 04.08.21.
//

import SwiftUI

struct EventCardView: View {
    
    @StateObject var viewModel: EventCardViewModel
    var onEdit: ((EventMO) -> ())?
    var onDelete: ((EventMO) -> ())?
    
    init(event: EventMO = .init(), onEdit:((EventMO) -> ())?, onDelete:((EventMO) -> ())?) {
        let vm = EventCardViewModel(event: event)
        _viewModel = StateObject(wrappedValue: vm)
        self.onEdit = onEdit
        self.onDelete = onDelete
    }
    
    var body: some View {
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
                        .foregroundColor(Theme.textColor)
                        .lineLimit(2)
                    Text(viewModel.event.targetDateTime ?? Date(), style: .date)
                        .font(.caption)
                        .foregroundColor(Theme.textColor)
                        .lineLimit(1)
                    VStack{
                        HStack(spacing: 10){
                            Button(action: editTapped){
                                ZStack{
                                    Circle()
                                        .fill()
                                        .frame(width: 40, height: 40)
                                        .foregroundColor(Color.black.opacity(0.3))
                                    Image(systemName: "pencil")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 15)
                                        .foregroundColor(Theme.textColor)
                                }
                            }
                            
                            Button(action: deleteTapped){
                                ZStack{
                                    Circle()
                                        .fill()
                                        .frame(width: 40, height: 40)
                                        .foregroundColor(Color.black.opacity(0.3))
                                    Image(systemName: "trash")
                                        .resizable()
                                        .aspectRatio(contentMode:  .fit)
                                        .frame(width: 15)
                                        .foregroundColor(Theme.textColor)
                                }
                            }
                        }
                    }.padding(.top, 12)
                    
                }
                Spacer()
                VStack{
                    ZStack(){
                        Circle()
                            .fill()
                            .frame(width: 75, height: 75)
                            .foregroundColor(Color.black.opacity(0.5))
                        VStack(){
                            Text("\(viewModel.event.delta.0)")
                                .font(.title)
                                .bold()
                                .foregroundColor(Theme.textColor)
                            Text(viewModel.event.delta.1)
                                .font(.subheadline)
                                .foregroundColor(Theme.textColor)
                            
                        }.multilineTextAlignment(.center)
                        
                        
                    }
                    
                    
                }
                
                
                
            }.padding(.horizontal, 16.0)
        }
    }
    
    func editTapped() {
        guard let onEdit = onEdit else {return}
        onEdit(viewModel.event)
    }
    
    func deleteTapped() {
        guard let onDelete = onDelete else {return}
        onDelete(viewModel.event)
    }
}

struct EventCard_Previews: PreviewProvider {
    static var previews: some View {
        EventCardView(event: .init(), onEdit: nil, onDelete: nil)
    }
}


extension EventCardView {
    
    final class EventCardViewModel: ObservableObject {
        @Published var event: EventMO
        
        init(event:EventMO) {
            self.event = event
        }
    }
}
