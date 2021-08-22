//
//  NewEditEventView.swift
//  Countdown
//
//  Created by Andre Hochschulte on 05.08.21.
//

import SwiftUI

struct AddEventView: View {
    
    @Environment(\.presentationMode)
    var presentationMode
    
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var theme: Theme
    
    @StateObject var vm: ViewModel = ViewModel()
    
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
            .navigationBarTitle("Add Event", displayMode: .inline)
            .navigationBarItems(leading: Button(action: {onDismiss(false)}){
                Text("Cancel")
            },
            trailing: Button(action: {onDismiss(true)}){
                Text("Add")
            }
            .disabled(vm.title.isEmpty)
            )
        }
        .accentColor(theme.primaryColor)
        
    }
    
    func onDismiss(_ save: Bool){
        if save {
            appState.isLoading = true
            self.vm.addEvent()
            appState.isLoading = false
        }
        self.presentationMode.wrappedValue.dismiss()
    }
}

struct AddEventView_Previews: PreviewProvider {
    
    static var previews: some View {
        AddEventView()
        
    }
}


extension AddEventView {
    final class ViewModel: ObservableObject{
        @Published var title:String = ""
        @Published var allDay: Bool = true
        @Published var targetDateTime = Date()
        @Published var selectedColor = EventColor.blue.rawValue
        @Published var selectedFirstReminder = EventReminder.none.rawValue
        @Published var selectedSecondReminder = EventReminder.none.rawValue
        
        private var dataStorage: EventDataStorage
        private var notificationService: NotificationService
        
        init(dataStorage: EventDataStorage = StorageManager.shared, notificationService: NotificationService = NotificationManager.shared) {
            self.dataStorage = dataStorage
            self.notificationService = notificationService
        }
        
        func addEvent(){
            if allDay {
                targetDateTime = Calendar.current.startOfDay(for: targetDateTime)
            }
            let event = dataStorage.addEvent(title: title,
                                             targetDateTime: targetDateTime,
                                             allDay: allDay,
                                             colorName: selectedColor,
                                             firstReminder: selectedFirstReminder,
                                             secondReminder: selectedSecondReminder)
            notificationService.addNotificationsForEvent(event)
        }
        
    }
}

