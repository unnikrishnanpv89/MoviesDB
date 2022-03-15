//
//  RatingView.swift
//  MusicDemo
//
//  Created by Pv, Unnikrishnan | Unni | IPESD on 2022/02/25.
//

import SwiftUI



struct RatingView: View {
    var progress : CGFloat
    
    init(rating: CGFloat){
        self.progress = rating
    }
    
    var body: some View {
        VStack(){
            ZStack {
                // 3.
                Circle()
                    .stroke(Color.gray, lineWidth: 8)
                    .background(Circle().foregroundColor(Color.black))
                    .opacity(0.4)
                // 4.
                Circle()
                    .trim(from: 0, to: progress/10)
                    .stroke(getColor(progress: progress), lineWidth: 5)
                    .rotationEffect(.degrees(-90))
                // 5.
                .overlay(
                    Text("\(Int(progress * 10.0))%")
                        .foregroundColor(getColor(progress: progress))
                        .font(.body))
            }.frame(width: 50, height: 50, alignment: .leading)
        }
    }
    
    func getColor(progress: CGFloat)-> SwiftUI.Color{
        switch progress{
        case _ where progress > 7.5:
            return .green
        case _ where progress > 5:
            return .yellow
        default:
            return .red
        }
    }
}

struct RatingView_Previews: PreviewProvider {
    static var previews: some View {
        RatingView(rating: 8.3)
    }
}
