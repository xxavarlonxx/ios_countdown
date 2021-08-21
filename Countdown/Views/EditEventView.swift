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
    
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var theme: Theme
    
    @StateObject var vm: ViewModel
    
    init(event: EventMO = .init()) {
        let vm = ViewModel(event: event)
        _vm = StateObject(wrappedValue: vm)
    }
    
    var body: some View {
        NavigationView{
            Form{
                Section(header: Text("Basis information")){
                    TextField("Name", text: $vm.title)
                    DatePicker("Date & Time", selection: $vm.targetDateTime, displayedComponents: [.date, .hourAndMinute])
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
                            
                        }.accentColor(theme.primaryColor)
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
        .accentColor(theme.primaryColor)
        .onAppear(perform: vm.onAppear)
    }
    
    func onDismiss(_ save: Bool){
        if save {
            appState.isLoading = true
            vm.updateEvent()
            appState.isLoading = false
        }
        self.presentationMode.wrappedValue.dismiss()
    }
}

//Testkommentar123
extension EditEventView {
    final class ViewModel: ObservableObject{
        @Published var title:String = ""
        @Published var targetDateTime = Date()
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
            event.targetDateTime = targetDateTime
            event.color = selectedColor
            
            dataStorage.updateEvent(event: event)
        }
        
        func onAppear(){
            title = event.title ?? ""
            targetDateTime = event.targetDateTime ?? Date()
            selectedColor = event.color ?? EventColor.blue.rawValue
        }
    }
}


struct EditEventView_Previews: PreviewProvider {
    static var previews: some View {
        EditEventView()
    }
}
