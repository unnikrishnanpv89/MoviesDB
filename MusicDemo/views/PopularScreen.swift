//
//  PopularScreen.swift
//  MusicDemo
//
//  Created by Pv, Unnikrishnan | Unni | IPESD on 2022/03/01.
//

import SwiftUI
import URLImage
import RealmSwift

struct PopularScreen: View {
    @State var isActive = false
    @State var movieId: Int = 0
    @State var isMovie = false
    
    struct MovieItem: Hashable {
        var id: Int
        var originalTitle: String
        var popularity: Double
        var posterPath: String?
        var voteCount: Int
        var voteAverage: Double
        var releaseDate: String?
        var mediaType: Bool
    }
    
    @State private var popularMovieList: [MovieItem] = []
    
    func updateItems(index: Int) {
        APIManager.getMyList(id: ListId.allCases[index]) { response in
            if let movielist = response as? ListResult {
                popularMovieList = movielist.results.map {
                    MovieItem(id: $0.id,
                          originalTitle: $0.originalTitle ?? "N/A",
                          popularity: $0.popularity,
                          posterPath: $0.posterPath,
                          voteCount: $0.voteCount,
                          voteAverage: $0.voteAverage,
                          releaseDate: $0.releaseDate ?? "N/A",
                          mediaType: $0.mediaType == "movie" ? true : false)
                }
            }
        }
    }
    
    var body: some View {
        VStack{
            Text("What's Popular")
                .font(.title)
            CustomToggleView(toggleOn: 0, options: ["Streaming", "On TV", "For Rent",
                                        "In Theaters"], toggleCallback: self.toggleCallback)
                .frame(height: 50)
            ScrollView(.horizontal, showsIndicators: false){
                HStack{
                    //NavigationView{
                        ForEach(popularMovieList, id: \.self){movie in
                            NavigationLink(destination: getDestination(), isActive: $isActive){
                                VStack{
                                    if let poster = movie.posterPath{
                                        URLImage(url: URL(string:  "\(BASE_IMAGE_URL)\(poster)")!) { image in
                                            image
                                                .resizable()
                                                .frame(width: UIScreen.main.bounds.size.width*0.25,
                                                    height: UIScreen.main.bounds.size.width*0.40)
                                                .aspectRatio(contentMode: .fit)
                                                .overlay(
                                                    RatingView(rating: movie.voteAverage.formatCircle()).offset(y:15)
                                                    ,alignment: .bottomLeading)
                                        }
                                    }
                                    Spacer()
                                    Text(movie.originalTitle)
                                        .font(.body)
                                        .bold()
                                        .frame(width: UIScreen.main.bounds.size.width*0.25)
                                        .lineLimit(2)
                                        .frame(alignment:.bottom)
                                }.frame(maxHeight: UIScreen.main.bounds.size.width*0.48)
                                    .onTapGesture(perform: {
                                        isActive = true
                                        movieId = movie.id
                                        self.isMovie = movie.mediaType
                                    })
                            }
                        }
                    //}.navigationBarHidden(false)
                }
            }.onAppear(perform: {
                print("am appearing..")
                updateItems(index: 0)
            })
        }
    }
    
    func toggleCallback(index: Int){
        updateItems(index: index)
    }
    
    func getDestination()->AnyView{
        return isMovie == true ? AnyView(MovieDetailView(movieId: self.movieId)) :
                        AnyView(TVDetailView(tvId: self.movieId))
    }
}

extension Double {
    func formatCircle() -> CGFloat {
        return CGFloat(truncating: NumberFormatter().number(from: String(format: "%.2f",self))!)
    }
}

struct PopularScreen_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            PopularScreen()
                .previewDevice("iPhone 12")
            PopularScreen()
        }
    }
}
