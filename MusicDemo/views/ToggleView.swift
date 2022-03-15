//
//  ToggleView.swift
//  MusicDemo
//
//  Created by Pv, Unnikrishnan | Unni | IPESD on 2022/02/21.
//

import SwiftUI

struct ToggleView: View {
    @Binding var toggleOn: Bool
    @State var option1: String
    @State var option2: String
    var toggleMovie : () -> ()
    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: self.toggleOn ? .leading : .trailing) {
                Capsule()
                    .frame(width: geo.size.width , height: geo.size.width * 0.1 + 4)
                    .foregroundColor(.gray)
                    .overlay(alignment: self.toggleOn ? .trailing : .leading, content: {
                        Text($option2.wrappedValue)
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                    })
                    
                Capsule()
                    .frame(width: geo.size.width * 0.5, height: geo.size.width * 0.1, alignment: .center)
                    .overlay(Capsule().stroke(Color.gray, lineWidth: 4))
                    .foregroundColor(.white)
                    .overlay(
                        Text($option1.wrappedValue)
                            .font(.headline)
                    )
            }
            .onTapGesture {
                withAnimation(.easeInOut(duration: 0.2)) {
                        self.toggleOn.toggle()
                        let temp = option1
                        option1 = option2
                        option2 = temp
                        self.toggleMovie()
                }
            }
        }
    }
}

struct ToggleView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ToggleView(toggleOn: .constant(false), option1: "Choise1", option2: "Choise2", toggleMovie: {})
        }
        
    }
}
