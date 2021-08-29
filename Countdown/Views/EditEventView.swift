//
//  EditEventView.swift
//  Countdown
//
//  Created by Andre Hochschulte on 08.08.21.
//

import SwiftUI
import Combine

struct EditEventView: View {
    
    @Environment(\.presentationMode)
    var presentationMode
    
    @Environment(\.colorScheme) var colorScheme
    
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
                Section(header: Text("add_event_form_name_section_label"), footer: Text(vm.errorTextEventName).font(.caption).foregroundColor(.red)){
                    HStack {
                        Image(systemName: "textformat").foregroundColor(theme.primaryIconColor)
                        TextField("add_event_form_name_textfield_placeholder", text: $vm.title)
                    }
                }
                Section(header: Text("add_event_form_datetime_section_label"), footer: Text(vm.errorTextEventDateTime).font(.caption).foregroundColor(.red)){
                    
                    HStack{
                        Image(systemName: "calendar").foregroundColor(theme.primaryIconColor)
                        DatePicker("add_event_form_date_picker_label", selection: $vm.targetDateTime, displayedComponents: [.date])
                    }
                    if !vm.allDay{
                        HStack {
                            Image(systemName: "clock").foregroundColor(theme.primaryIconColor)
                            DatePicker("add_event_form_time_picker_label", selection: $vm.targetDateTime, displayedComponents: [.hourAndMinute])
                        }
                    }
                    Toggle("add_event_form_allday_toggle_label", isOn: $vm.allDay)
                    
                }
                Section(header: Text("add_event_form_color_section_label")){
                    HStack{
                        Image(systemName: "eyedropper").foregroundColor(theme.primaryIconColor)
                        Picker("add_event_form_color_picker_label", selection: $vm.selectedColor){
                            ForEach(EventColor.allCases, id: \.self){eventColor in
                                HStack{
                                    Rectangle()
                                        .frame(width: 10, height: 10)
                                        .foregroundColor(eventColor.color)
                                    Text(LocalizedStringKey(eventColor.localizedStringKey))
                                }
                                
                            }.accentColor(theme.primaryColor)
                        }
                    }
                }
                Section(header: Text("add_event_form_reminders_section_label")){
                    Picker("add_event_form_firstreminder_picker_label", selection: $vm.selectedFirstReminder){
                        ForEach(EventReminder.allCases, id: \.self){reminder in
                            Text(LocalizedStringKey(reminder.localizedStringKey))
                            
                        }.accentColor(theme.primaryColor)
                    }
                    if vm.selectedFirstReminder != EventReminder.none {
                        Picker("add_event_form_secondreminder_picker_label", selection: $vm.selectedSecondReminder){
                            ForEach(EventReminder.allCases, id: \.self){reminder in
                                Text(LocalizedStringKey(reminder.localizedStringKey))
                                
                            }.accentColor(theme.primaryColor)
                        }
                    }
                    
                }
                
            }
            .navigationBarTitle("edit_event_form_title", displayMode: .inline)
            .navigationBarItems(leading: Button(action:{ onDismiss(false)}){
                Image(systemName: "xmark").foregroundColor(colorScheme == .dark ? .white : .black).imageScale(.large)
            },
            trailing: Button(action: {onDismiss(true)}) {
                Text("edit_event_form_positive_button_title")
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
        @Published var selectedColor = EventColor.blue
        @Published var allDay: Bool = true
        @Published var selectedFirstReminder = EventReminder.none
        @Published var selectedSecondReminder = EventReminder.none
        @Published var isValid = false
        @Published var errorTextEventName = ""
        @Published var errorTextEventDateTime = ""
        
        private var dataStorage: EventDataStorage
        private var notificationService: NotificationService
        private var event: EventMO
        
        private var cancellables = Set<AnyCancellable>()
        
        private var isEventNameValidPublisher: AnyPublisher<Bool, Never>  {
            $title
                .debounce(for: 0.8, scheduler: RunLoop.main)
                .removeDuplicates()
                .map{ !$0.isEmpty }
                .eraseToAnyPublisher()
        }
        
        private var isEventDateTimeValidPublisher: AnyPublisher<Bool, Never> {
            $targetDateTime
                .debounce(for: 0.8, scheduler: RunLoop.main)
                .removeDuplicates()
                .map{ $0 > Date()}
                .eraseToAnyPublisher()
        }
        
        private var isFormValidPublisher : AnyPublisher<Bool, Never>{
            Publishers.CombineLatest(isEventNameValidPublisher, isEventDateTimeValidPublisher)
                .map { $0 && $1}
                .eraseToAnyPublisher()
        }
        
        init(dataStorage: EventDataStorage = StorageManager.shared,
             notificationService: NotificationService = NotificationManager.shared,
             event: EventMO) {
            self.event = event
            self.allDay = event.allDay
            self.dataStorage = dataStorage
            self.notificationService = notificationService
            
            $selectedFirstReminder.receive(on: RunLoop.main)
                .dropFirst()
                .map {$0 == EventReminder.none ? EventReminder.none : self.selectedSecondReminder}
                .assign(to: \.selectedSecondReminder, on: self)
                .store(in: &cancellables)
            
            isFormValidPublisher.receive(on: RunLoop.main)
                .assign(to: \.isValid, on: self)
                .store(in: &cancellables)
            
            isEventNameValidPublisher.receive(on: RunLoop.main)
                .dropFirst()
                .map { $0 ? "" : EventFormValidationError.eventNameIsEmpty.rawValue}
                .assign(to: \.errorTextEventName, on: self)
                .store(in: &cancellables)
            
            isEventDateTimeValidPublisher.receive(on: RunLoop.main)
                .dropFirst()
                .map { $0 ? "" : EventFormValidationError.eventDateTimeIsInThePast.rawValue}
                .assign(to: \.errorTextEventDateTime, on: self)
                .store(in: &cancellables)
        }
        
        func updateEvent(){
            event.title = title
            event.targetDateTime = targetDateTime
            event.color = selectedColor.rawValue
            event.firstReminder = selectedFirstReminder.rawValue
            event.secondReminder = selectedSecondReminder.rawValue
            
            dataStorage.updateEvent(event: event)
            notificationService.editNotificationForEvent(event)
        }
        
        func onAppear(){
            title = event.titleValue
            targetDateTime = event.targetDateTimeValue
            selectedColor = EventColor(rawValue: event.colorValue) ?? EventColor.blue
            selectedFirstReminder = EventReminder(rawValue: event.firstReminderValue) ?? EventReminder.none
            selectedSecondReminder = EventReminder(rawValue: event.secondReminderValue) ?? EventReminder.none
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
