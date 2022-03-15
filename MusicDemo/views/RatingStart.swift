//
//  RatingStart.swift
//  MusicDemo
//
//  Created by Pv, Unnikrishnan | Unni | IPESD on 2022/02/25.
//

import SwiftUI

struct RatingStart: View {
    var rating: CGFloat
    var maxRating =  5

        var body: some View {
            let stars = HStack(spacing: 0) {
                ForEach(0..<maxRating) { _ in
                    Image(systemName: "star.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                }
            }.frame(maxWidth:  UIScreen.main.bounds.width*0.25,
                    maxHeight: UIScreen.main.bounds.height*0.1)

            stars.overlay(
                GeometryReader { g in
                    let width = rating / CGFloat(maxRating) * g.size.width
                    ZStack(alignment: .leading) {
                        Rectangle()
                            .frame(width: width)
                            .foregroundColor(.yellow)
                    }
                }
                .mask(stars)
            )
            .foregroundColor(.gray)
        }
}

struct RatingStart_Previews: PreviewProvider {
    static var previews: some View {
        RatingStart(rating: 4.5)
    }
}
