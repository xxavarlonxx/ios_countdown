//
//  AboutView.swift
//  Countdown
//
//  Created by Andre Hochschulte on 29.08.21.
//

import SwiftUI

struct AboutView: View {
    @Environment(\.presentationMode)
    var presentationMode
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var theme: Theme
    @StateObject var vm: ViewModel = ViewModel()
    
    var body: some View {
        NavigationView {
            Form{
                Section(header: Text("Version")){
                    HStack {
                        Text("Version")
                        Spacer()
                        Text("1.0.0")
                    }
                }
                Section(header: Text("Policy & Terms")){
                    HStack {
                        Spacer()
                        Button(action:{}){
                            Text("Privacy Policy")
                        }
                        Spacer()
                    }
                    
                    HStack {
                        Spacer()
                        Button(action:{}){
                            Text("Terms & Conditions")
                        }
                        Spacer()
                    }
                }
//                Section(header: Text("Contact")){
//                    HStack {
//                        Spacer()
//                        Button(action:{}){
//                            Text("Contact me!")
//                        }
//                        Spacer()
//                    }
//                }
            }
            .navigationBarTitle("About", displayMode: .inline)
            .navigationBarItems(leading: Button(action:{ self.presentationMode.wrappedValue.dismiss()}){
                Image(systemName: "xmark").foregroundColor(colorScheme == .dark ? .white : .black).imageScale(.large)
            })
        
        }.accentColor(theme.primaryColor)
    }
}


class ViewModel: ObservableObject {
    
}

struct AboutView_Previews: PreviewProvider {
    static var previews: some View {
        AboutView()
    }
}
