//
//  ContentView.swift
//  Countdown
//
//  Created by Andre Hochschulte on 04.08.21.
//

import SwiftUI

struct MainView: View {
    
    @StateObject var vm = ViewModel()
    
    var body: some View {
        
        NavigationView{
            ZStack {
                EventListView()
                VStack{
                    Spacer()
                    Button(action: {
                        vm.showingAddModal = true
                    }) {
                        Image(systemName: "plus")
                            .resizable()
                            .frame(width: 35, height: 35)
                            .padding(30)
                            .foregroundColor(Theme.textColor)
                            .background(Theme.primaryColorDarker)
                            .shadow(radius:20)
                        
                    }
                    .clipShape(Circle())
                    .padding(.bottom)
                    .sheet(isPresented: $vm.showingAddModal){
                        AddEventView()
                    }
                }
                
            }.navigationBarTitle("Next Events", displayMode: .large)
            
        }.accentColor(.white)
        
        
    }
}


extension MainView {
    final class ViewModel: ObservableObject {
        @Published var showingAddModal: Bool = false
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
