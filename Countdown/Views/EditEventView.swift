//
//  EditEventView.swift
//  Countdown
//
//  Created by Andre Hochschulte on 08.08.21.
//

import SwiftUI

struct EditEventView: View {
    
    @Environment(\.presentationMode)
    var presentationMode
    
    
    
    @StateObject var vm: ViewModel
    
    init(event: EventMO) {
        let vm = ViewModel(event: event)
        _vm = StateObject(wrappedValue: vm)
    }
    
    var body: some View {
        NavigationView{
            Form{
                Section(header: Text("Basis information")){
                    TextField("Name", text: $vm.title)
                    DatePicker("Date", selection: $vm.targetDate, displayedComponents: .date)
                    DatePicker("Time", selection: $vm.targetTime, displayedComponents: .hourAndMinute)
                }
                Section(header: Text("Visual information")){
                    Picker("Color", selection: $vm.selectedColor){
                        ForEach(EventColor.rawValueList(), id: \.self){color in
                            HStack{
                                Rectangle()
                                    .frame(width: 10, height: 10)
                                    .foregroundColor(EventColor(rawValue: color)?.color)
                                Text(color.capitalized)
                            }
                            
                        }.accentColor(Theme.primaryColorDarker)
                    }
                }
                
            }
            .navigationBarTitle("Edit", displayMode: .inline)
            .navigationBarItems(leading: Button(action: {onDismiss(false)}) {
                Text("Cancel")
            },
            trailing: Button(action: {onDismiss(true)}) {
                Text("Save")
            }
            .disabled(vm.title.isEmpty)
            )
        }
        .accentColor(Theme.primaryColorDarker)
        .onAppear(perform: vm.onAppear)
    }
    
    func onDismiss(_ save: Bool){
        if save {
            vm.updateEvent()
        }
        self.presentationMode.wrappedValue.dismiss()
    }
}

extension EditEventView {
    final class ViewModel: ObservableObject{
        @Published var title:String = ""
        @Published var targetDate = Date()
        @Published var targetTime = Date()
        @Published var selectedColor = EventColor.blue.rawValue
        @Published var barTitle: String = "Edit"
        
        private var dataStorage: EventDataStorage
        
        private var event: EventMO
        
        init(dataStorage: EventDataStorage = CDEventDataStorage.shared, event: EventMO) {
            self.event = event
            self.dataStorage = dataStorage
        }
        
        func updateEvent(){
            event.title = title
            event.targetDateTime = Calendar.current.combine(date: targetDate, with: targetTime)
            event.color = selectedColor
            
            dataStorage.updateEvent(event: event)
        }
        
        func onAppear(){
            title = event.title ?? ""
            targetDate = event.targetDate
            targetTime = event.targetTime
            selectedColor = event.color ?? EventColor.blue.rawValue
        }
    }
}


struct EditEventView_Previews: PreviewProvider {
    static var previews: some View {
        EditEventView(event: .init())
    }
}
