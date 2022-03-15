//
//  SettingsView.swift
//  MusicDemo
//
//  Created by Pv, Unnikrishnan | Unni | IPESD on 2022/03/03.
//

import SwiftUI

struct SettingsView: View {
    var items = ["Favorites": ["Offline Mode", "Save Locally"],
                 "Login": ["Use Biometric"],
                 "Videos": ["Trailler", "Teaser", "Other"],
                 "Profile": ["Sub Settings1", "Sub Settings2", "Sub Settings3"]]

    var body: some View {
        let keys = items.map{$0.key}
        let values = items.map {$0.value}
        NavigationView{
            List{
                ForEach(0..<items.count) {index in
                    HStack{
                        NavigationLink(destination: {
                                SubSettings(values: values[index])
                            })
                        {
                            Text(keys[index])
                                .font(.title2)
                        }
                    }.navigationBarTitle("Settings")
                }
            }
        }.navigationViewStyle(StackNavigationViewStyle())
        .padding(0)
    }
}

struct SubSettings: View {
    var values: [String]
    @State private var isChecked :[Bool]?
    
    var body: some View {
        List{
            ForEach(0..<values.count) { index in
                HStack {
                    if let isChecked = isChecked {
                        Button(action: {
                            toggle(index: index)
                            }) {
                            if isChecked[index] == true{
                                Image(systemName: "checkmark.square.fill")
                                    .foregroundColor(.green)
                            } else {
                                Image(systemName: "square")
                            }
                        }
                        Text(values[index])
                            .font(.title2)
                    }
                }.onAppear(perform:{
                    self.isChecked = Array(repeating: false, count: values.count)
                })
            }
        }
    }
    
    func toggle(index: Int) -> Void {
        if let checked = isChecked?[index]{
            isChecked?[index] = !checked
        }
        UIImpactFeedbackGenerator(style: .medium)
        .impactOccurred()
    }
    
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            SettingsView()
                .previewDevice("iPad (9th generation)")
            .previewInterfaceOrientation(.landscapeLeft)
            SettingsView()
                .previewDevice("iPad (9th generation)")
                .previewInterfaceOrientation(.landscapeLeft)
        }
    }
}
