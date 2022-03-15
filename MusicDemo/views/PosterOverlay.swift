//
//  PosterOverlay.swift
//  MusicDemo
//
//  Created by Pv, Unnikrishnan | Unni | IPESD on 2022/03/04.
//

import SwiftUI
import URLImage

struct PosterOverlay: View {
    
    @State var isOverlay = false
    let backdropPath: String?
    let status: String?
    let originalLanguage: String?
    let budget: Int?
    let revenue: Int?
    
    var body: some View {
        if let backdropPath = backdropPath{
            URLImage(url: URL(string:  "\(TV_IMAGE_URL)\(backdropPath)")!) { image in
                image
                    .resizable()
                    .frame(width: UIScreen.main.bounds.size.width, height: 230)
                    .aspectRatio(contentMode: .fit)
                    .overlay(content: {
                        if isOverlay{
                            OverlayView(status: self.status,
                                    originalLanguage: self.originalLanguage,
                                        budget: self.budget,
                                        revenue: self.revenue)
                        }else{
                            EmptyView()
                        }
                    })
            }.onTapGesture(perform: {
                    isOverlay = !isOverlay
            })
        }
    }
}

struct OverlayView: View{
    let status: String?
    let originalLanguage: String?
    let budget: Int?
    let revenue: Int?
    var body: some View{
        VStack{
                Text("Status: \(status ?? "N/A")")
                    .foregroundColor(.yellow)
                    .font(.body)
                Spacer()
                Text("Language: \(originalLanguage ?? "N/A")")
                    .foregroundColor(.yellow)
                    .font(.body)
                Spacer()
                Text("Budget: $\(formatPoints(from: budget) ?? "N/A")")
                    .foregroundColor(.yellow)
                    .font(.body)
                Spacer()
                Text("Revenue: $\(formatPoints(from: revenue) ?? "N/A")")
                    .foregroundColor(.yellow)
                    .font(.body)
        }.frame(maxWidth: .infinity, alignment: .trailing)
    }
    func formatPoints(from: Int?) -> String? {
        if let from = from {
            let number = Double(from)
            let thousand = number / 1000
            let million = number / 1000000
            let billion = number / 1000000000
            
            if billion >= 1.0 {
                return "\(round(billion*10)/10)B"
            } else if million >= 1.0 {
                return "\(round(million*10)/10)M"
            } else if thousand >= 1.0 {
                return ("\(round(thousand*10/10))K")
            } else {
                return "\(Int(number))"
            }
        }else{
            return nil
        }
    }
}

struct PosterOverlay_Previews: PreviewProvider {
    static var previews: some View {
        PosterOverlay(backdropPath: "/nvxrQQspxmSblCYDtvDAbVFX8Jt.jpg",
                      status: "Released",
                      originalLanguage: "English",
                      budget: 10000,
                      revenue: 20000)
    }
}
