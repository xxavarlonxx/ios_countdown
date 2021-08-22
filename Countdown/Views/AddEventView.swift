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
                Section(header: Text("add_event_form_name_section_label")){
                    TextField("add_event_form_name_textfield_placeholder", text: $vm.title)
                }
                Section(header: Text("add_event_form_datetime_section_label")){
                    
                    DatePicker("add_event_form_date_picker_label", selection: $vm.targetDateTime, displayedComponents: [.date])
                    if !vm.allDay{
                        DatePicker("add_event_form_time_picker_label", selection: $vm.targetDateTime, displayedComponents: [.hourAndMinute])
                    }
                    Toggle("add_event_form_allday_toggle_label", isOn: $vm.allDay)
                    
                }
                Section(header: Text("add_event_form_color_section_label")){
                    Picker("add_event_form_color_picker_label", selection: $vm.selectedColor){
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
                Section(header: Text("add_event_form_reminders_section_label")){
                    Picker("add_event_form_firstreminder_picker_label", selection: $vm.selectedFirstReminder){
                        ForEach(EventReminder.allCasesAsString(), id: \.self){reminder in
                            Text(reminder)
                            
                        }.accentColor(theme.primaryColor)
                    }
                    Picker("add_event_form_secondreminder_picker_label", selection: $vm.selectedSecondReminder){
                        ForEach(EventReminder.allCasesAsString(), id: \.self){reminder in
                            Text(reminder)
                            
                        }.accentColor(theme.primaryColor)
                    }
                }
                
            }
            .navigationBarTitle("add_event_form_title", displayMode: .inline)
            .navigationBarItems(leading: Button(action: {onDismiss(false)}){
                Text("add_event_form_negative_button_title")
            },
            trailing: Button(action: {onDismiss(true)}){
                Text("add_event_form_positive_button_title")
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

