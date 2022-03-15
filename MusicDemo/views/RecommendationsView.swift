//
//  RecommendationsView.swift
//  MusicDemo
//
//  Created by Pv, Unnikrishnan | Unni | IPESD on 2022/03/04.
//

import SwiftUI
import URLImage

struct RecommendationsView: View {
    @State var isActive = false
    @State var movieId: Int = 0
    @State var isMovie = false
    @State private var recList: [RecommendedItem] = []
    
    struct RecommendedItem: Hashable {
        var id: Int
        var originalTitle: String
        var posterPath: String?
        var voteAverage: Double
        var releaseDate: String?
        var isMovie: Bool
    }
    
    var body: some View {
        VStack{
        Text("Similar")
            .font(.title)
            .frame(maxWidth: .infinity, alignment: .leading)
            ScrollView(.horizontal, showsIndicators: false){
                HStack{
                    ForEach(recList, id: \.self){movie in
                        NavigationLink(destination: getDestination(),
                                       isActive: $isActive){
                            VStack{
                                if let poster = movie.posterPath{
                                    URLImage(url: URL(string:  "\(BASE_IMAGE_URL)\(poster)")!) { image in
                                        image
                                            .resizable()
                                            .frame(width: UIScreen.main.bounds.size.width*0.25,
                                                height: UIScreen.main.bounds.size.width*0.45)
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
                            }.frame(maxHeight: UIScreen.main.bounds.size.width*0.50)
                                .onTapGesture(perform: {
                                    isActive = true
                                    self.movieId = movie.id
                                    isMovie = movie.isMovie
                                })
                        }
                    }
                }
        }.onAppear(perform: {
            getRecommended(id: self.movieId, isMovie: self.isMovie)
        })
        }
    }

    func getDestination()->AnyView{
        return isMovie == true ? AnyView(MovieDetailView(movieId: self.movieId)) :
                        AnyView(TVDetailView(tvId: self.movieId))
    }
    
    func getRecommended(id: Int, isMovie: Bool){
        APIManager.getRecommended(category: isMovie == true ? .MOVIES : .TV,
                                  movieId: id,
                                  pageNum: 1) { response in
            if let movielist = response as? MovieList {
                recList = movielist.results.map {
                    RecommendedItem(id: $0.id,
                              originalTitle: $0.originalTitle,
                              posterPath: $0.posterPath,
                              voteAverage: $0.voteAverage,
                              releaseDate: $0.releaseDate ?? "N/A",
                                isMovie: true)
                }
            }
            else if  let tvList = response as? TvList {
                recList = tvList.results.map {
                    RecommendedItem(id: $0.id,
                              originalTitle: $0.originalName,
                              posterPath: $0.posterPath,
                              voteAverage: $0.voteAverage,
                            releaseDate: $0.firstAirDate ?? "N/A",
                                    isMovie: false)
                }
            }
        }
    }
}

struct RecommendationsView_Previews: PreviewProvider {
    static var previews: some View {
        RecommendationsView(movieId: 634649, isMovie: true)
    }
}
