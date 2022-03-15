//
//  FreeToWatch.swift
//  MusicDemo
//
//  Created by Pv, Unnikrishnan | Unni | IPESD on 2022/03/01.
//

import SwiftUI
import URLImage
import RealmSwift

struct FreeToWatch: View {
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
    
    @State private var ftwList: [MovieItem] = []
    
    func updateItems(index: Int) {
        let newIndex = index+4  //enum index
        APIManager.getMyList(id: ListId.allCases[newIndex]) { response in
            if let movielist = response as? ListResult {
                ftwList = movielist.results.map {
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
        Text("Free To Watch")
             .font(.title)
        CustomToggleView(toggleOn: 0, options: ["Movies", "TV"], toggleCallback: self.toggleCallback)
             .frame(height: 50)
         ScrollView(.horizontal, showsIndicators: false){
             HStack{
                     ForEach(ftwList, id: \.self){movie in
                         NavigationLink(destination: self.getDestination(), isActive: $isActive){
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
                             self.isMovie = movie.mediaType
                         })
                     }
                 }
             }
         }.onAppear(perform: {
            updateItems(index: 0)
        })
    }
    
    func toggleCallback(index: Int){
        updateItems(index: index)
    }
    
    func getDestination()->AnyView{
        return isMovie == true ? AnyView(MovieDetailView(movieId: self.movieId)) :
                        AnyView(TVDetailView(tvId: self.movieId))
    }
    
}


struct FreeToWatch_Previews: PreviewProvider {
    static var previews: some View {
        FreeToWatch()
    }
}
