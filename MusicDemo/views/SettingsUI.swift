//
//  SettingsUI.swift
//  MusicDemo
//
//  Created by Pv, Unnikrishnan | Unni | IPESD on 2022/02/22.
//

import SwiftUI

struct SettingsUI: View {
    let colors: [Color] = [.red, .green, .blue]
    var body: some View {
        VStack {
            ForEach(colors, id: \.self) { color in
                Text(color.description.capitalized)
                    .padding()
            }
        }
    }
}

struct SettingsUI_Previews: PreviewProvider {
    static var previews: some View {
        SettingsUI()
    }
}
