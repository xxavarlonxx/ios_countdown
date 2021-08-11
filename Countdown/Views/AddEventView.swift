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
    
    @StateObject var vm: ViewModel = ViewModel()
    
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
        .accentColor(Theme.primaryColorDarker)
        
    }
    
    func onDismiss(_ save: Bool){
        if save {
            self.vm.addEvent()
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
        @Published var targetDate = Date()
        @Published var targetTime = Date()
        @Published var selectedColor = EventColor.blue.rawValue
        
        private var dataStorage: EventDataStorage
        
        init(dataStorage: EventDataStorage = CDEventDataStorage.shared) {
            self.dataStorage = dataStorage
        }
        
        func addEvent(){
            dataStorage.addEvent(title: title,
                                 targetDateTime: Calendar.current.combine(date: targetDate, with: targetTime),
                                 colorName: selectedColor)
        }
        
    }
}

