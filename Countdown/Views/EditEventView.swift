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
                Section(header: Text("Name")){
                    TextField("Name", text: $vm.title)
                }
                Section(header: Text("Date & Time")){
                    
                    DatePicker("Date", selection: $vm.targetDateTime, displayedComponents: [.date])
                    if !vm.allDay{
                        DatePicker("Time", selection: $vm.targetDateTime, displayedComponents: [.hourAndMinute])
                    }
                    Toggle("All day", isOn: $vm.allDay)
                    
                }
                Section(header: Text("Color")){
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
                Section(header: Text("Reminders")){
                    Picker("First Reminder", selection: $vm.selectedFirstReminder){
                        ForEach(EventReminder.allCasesAsString(), id: \.self){reminder in
                            Text(reminder)
                            
                        }.accentColor(theme.primaryColor)
                    }
                    Picker("Second Reminder", selection: $vm.selectedSecondReminder){
                        ForEach(EventReminder.allCasesAsString(), id: \.self){reminder in
                            Text(reminder)
                            
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

extension EditEventView {
    final class ViewModel: ObservableObject{
        @Published var title:String = ""
        @Published var targetDateTime = Date()
        @Published var selectedColor = EventColor.blue.rawValue
        @Published var allDay: Bool = true
        @Published var selectedFirstReminder = EventReminder.none.rawValue
        @Published var selectedSecondReminder = EventReminder.none.rawValue
        
        private var dataStorage: EventDataStorage
        private var notificationService: NotificationService
        private var event: EventMO
        
        init(dataStorage: EventDataStorage = StorageManager.shared,
             notificationService: NotificationService = NotificationManager.shared,
             event: EventMO) {
            self.event = event
            self.allDay = event.allDay
            self.dataStorage = dataStorage
            self.notificationService = notificationService
        }
        
        func updateEvent(){
            event.title = title
            event.targetDateTime = targetDateTime
            event.color = selectedColor
            event.firstReminder = selectedFirstReminder
            event.secondReminder = selectedSecondReminder
            
            dataStorage.updateEvent(event: event)
            notificationService.editNotificationForEvent(event)
        }
        
        func onAppear(){
            title = event.titleValue
            targetDateTime = event.targetDateTimeValue
            selectedColor = event.color ?? EventColor.blue.rawValue
            selectedFirstReminder = event.firstReminderValue
            selectedSecondReminder = event.secondReminderValue
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.success)
        }
    }
}


struct EditEventView_Previews: PreviewProvider {
    static var previews: some View {
        EditEventView()
    }
}
