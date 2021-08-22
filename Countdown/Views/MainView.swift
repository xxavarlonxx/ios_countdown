//
//  ContentView.swift
//  Countdown
//
//  Created by Andre Hochschulte on 04.08.21.
//

import SwiftUI
import SwiftUIX
import UserNotifications

struct MainView: View {
    
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var theme: Theme
    @StateObject var vm: ViewModel = .init()

    
    var body: some View {
        ZStack{
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
                                .foregroundColor(.white)
                                .background(theme.primaryColor)
                            
                        }
                        .clipShape(Circle())
                        .shadow(radius: 20)
                        .padding(.bottom)
                        .sheet(isPresented: $vm.showingAddModal){
                            AddEventView()
                        }
                    }
                    
                }.navigationBarTitle(LocalizedStringKey("title_events_list"), displayMode: .large)
                
            }
            .accentColor(theme.primaryTextColor)
            .disabled(appState.isLoading)
            
            LoadingView(isPresented: $appState.isLoading, text: "title_loading_hud")
        }.onAppear(perform: onAppear)
            
    }
    
    func onAppear() {
        if !appState.hasAlreadyAskForNotificationPermission{
            DispatchQueue.main.asyncAfter(deadline: .now()+3) {
                UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
                    appState.hasAlreadyAskForNotificationPermission = true
                    if success {
                        appState.hasUserNotificationPermission = true
                    }
                    
                    if let error = error {
                        fatalError(error.localizedDescription)
                    }
                }
            }
        }
    }
    
}


extension MainView {
    final class ViewModel: ObservableObject {
        @Published var showingAddModal: Bool = false
        
        func onAppear(){
            
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
