//
//  ContentView.swift
//  Countdown
//
//  Created by Andre Hochschulte on 04.08.21.
//

import SwiftUI
import SwiftUIX

struct MainView: View {
    
    @EnvironmentObject var appState: AppState
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
                                .background(Theme.indigo500)
                                .shadow(radius:20)
                            
                        }
                        .clipShape(Circle())
                        .padding(.bottom)
                        .sheet(isPresented: $vm.showingAddModal){
                            AddEventView()
                        }
                    }
                    
                }.navigationBarTitle("Next Events", displayMode: .large)
                
            }
            .accentColor(.white)
            .disabled(appState.isLoading)
            
            LoadingView(isPresented: $appState.isLoading, text: "Loading")
        }
            
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
