//
//  CustomToggleView.swift
//  MusicDemo
//
//  Created by Pv, Unnikrishnan | Unni | IPESD on 2022/03/01.
//

import SwiftUI

struct CustomToggleView: View {
    @State var toggleOn: Int
    @State var options: [String]
    var toggleCallback : (Int) -> ()
    var body: some View {
        GeometryReader { geo in
            ZStack {
                Capsule()
                    .frame(width: geo.size.width, height: 50)
                    .overlay(Capsule().stroke(Color.gray, lineWidth: 4))
                    .foregroundColor(.white)
                    .overlay(content: {
                        HStack{
                            ForEach(0..<options.count){ index in
                                if index != toggleOn{
                                    Text(options[index])
                                        .font(.body)
                                        .foregroundColor(.black)
                                        .padding()
                                        .onTapGesture(perform: {
                                            self.toggleSelection(index: index)
                                        })
                                }else{
                                    Capsule()
                                        .frame(width: geo.size.width/CGFloat(options.count), height: 50, alignment: .center)
                                        .overlay(Capsule().stroke(Color.gray, lineWidth: 4))
                                        .foregroundColor(.black)
                                        .overlay(
                                            Text(options[toggleOn])
                                                .font(.headline)
                                                .foregroundColor(.green)
                                        )
                                }
                            }
                        }
                    })
            }
        }
    }
    
    func toggleSelection(index: Int){
        self.toggleOn = index
        self.toggleCallback(index)
    }
}

struct CustomToggleView_Previews: PreviewProvider {
    static var previews: some View {
        CustomToggleView(toggleOn: 0, options: ["Option1", "Option2"], toggleCallback: {_ in })
    }
}
