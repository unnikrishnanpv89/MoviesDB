//
//  DetailView.swift
//  MusicDemo
//
//  Created by Pv, Unnikrishnan | Unni | IPESD on 2022/02/25.
//

import SwiftUI
import URLImage
import RealmSwift

let ORIGINAL_IMAGE_URL = "https://image.tmdb.org/t/p/original/"

struct MovieDetailView: View {
    
    var movieId: Int = 0
    @ObservedObject var observed = MovieLoader()
    
    init(movieId: Int){
        self.movieId = movieId
    }
    
    var body: some View {
        if let movie = observed.movie{
                ScrollView(showsIndicators: false){
                    ZStack{
                        VStack{
                            DetailsPageTitleView(title: movie.title, genres: movie.genres)
                            PosterOverlay(backdropPath: movie.backdropPath,
                                          status: movie.status,
                                          originalLanguage: movie.originalLanguage,
                                          budget: movie.budget,
                                          revenue: movie.revenue)
                            IconsView(voteAverage: movie.voteAverage,
                                      homepage: movie.homepage,
                                      movieId: self.movieId,
                            favCallBack: addToFavorite)
                            if let overview = movie.overview{
                                Text(overview)
                                    .font(.body)
                                    .italic()
                            }
                            CastView(movieId: movieId, isMovie: true)
                            RecommendationsView(movieId: movieId, isMovie: true)
                        }.navigationBarHidden(false)   //vstack
                            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .topLeading)
                    }//zstack
                }
                .onAppear(perform: {    //navigationview
                    observed.getMovie(id: self.movieId)
                })
        } else{
            Text("Loading..").onAppear(
                perform: {
                    observed.getMovie(id: self.movieId)
            })
        }
    }
    
    func addToFavorite(){
        //print("Add to fav", observed.movie)
        /*if let movie = observed.movie{
            realm.beginWrite()
            realm.add(movie, update: Realm.UpdatePolicy.modified)
            if realm.isInWriteTransaction {
                  try! realm.commitWrite()
             }
        }*/
    }
}


class MovieLoader: ObservableObject{
    @Published var movie: MovieAdditionalDetails? = nil
    
    init(movieId: Int? = nil){
        if let id = movieId{
            getMovie(id: id)
        }
    }
    
    func getMovie(id: Int){
        if id != 0 {
            APIManager.getAddiDetail(movieId: id, category: .MOVIES) { [weak self](response) in
                if let movie = response as? MovieAdditionalDetails {
                    self?.movie = movie
                }
            }
        }
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        MovieDetailView(movieId: 2734)
    }
}
