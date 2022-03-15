//
//  TrendingView.swift
//  MusicDemo
//
//  Created by Pv, Unnikrishnan | Unni | IPESD on 2022/03/01.
//

import SwiftUI
import URLImage
import RealmSwift

struct TrendingView: View {
    @State var isActive = false
    @State var movieId: Int = 0
    
    @State private var trendingList: [TrendingItem] = []
    
    struct TrendingItem: Hashable {
        var id: Int
        var originalTitle: String
        var posterPath: String?
        var voteAverage: Double
        var releaseDate: String?
        var mediaType: String
    }
    
    var body: some View {
        Text("Trending")
            .font(.title)
        CustomToggleView(toggleOn: 0, options: ["Today", "This Week"], toggleCallback: self.toggleCallback)
            .frame(height: 50)
        if trendingList.count > 0 {
            ScrollView(.horizontal, showsIndicators: false){
                HStack{
                        ForEach(trendingList, id: \.self){movie in
                            NavigationLink(destination: getDestination(type: movie.mediaType), isActive: $isActive){
                            VStack{
                                if let poster = movie.posterPath{
                                    URLImage(url: URL(string:  "\(BASE_IMAGE_URL)\(poster)")!) { image in
                                                image
                                            .resizable()
                                            .frame(width: UIScreen.main.bounds.size.width*0.25,
                                                height: UIScreen.main.bounds.size.width*0.40)
                                            .aspectRatio(contentMode: .fit)
                                            .overlay(
                                                RatingView(rating: movie.voteAverage.formatCircle()).offset(y:25)
                                                    ,alignment: .bottomLeading)
                                                }
                                }
                                Spacer()
                                Text(movie.originalTitle)
                                    .font(.body)
                                    .frame(width: UIScreen.main.bounds.size.width*0.25)
                                    .lineLimit(2)
                                    .frame(alignment:.bottom)
                            }.frame(maxHeight: UIScreen.main.bounds.size.width*0.46)
                            .onTapGesture(perform: {
                                isActive = true
                                movieId = movie.id
                            })
                        }
                    }
                }
            }
        }else{
            Text("Loading...")
                .onAppear(perform: {
                getTrending(window: .day)
            })
        }
    }
    
    func toggleCallback(index: Int){
        if index == 0{
            getTrending(window: .day)
        }else{
            getTrending(window: .week)
        }
    }
    
    func getDestination(type: String)->AnyView{
        return type == "movie" ? AnyView(MovieDetailView(movieId: self.movieId)) :
                        AnyView(TVDetailView(tvId: self.movieId))
    }
    
    func getTrending(window: Time_Window){
        APIManager.getTrending(window: window) { response in
            if let trending = response as? TrendingResults {
                trendingList = trending.results.map {
                    TrendingItem(id: $0.id,
                              originalTitle: $0.originalTitle ?? "N/A",
                              posterPath: $0.posterPath,
                              voteAverage: $0.voteAverage,
                             releaseDate: $0.releaseDate ?? "N/A",
                             mediaType: $0.mediaType)
                }
            }
        }
    }
}

struct TrendingView_Previews: PreviewProvider {
    static var previews: some View {
        TrendingView()
    }
}
