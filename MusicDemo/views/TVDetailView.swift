//
//  TVDetailView.swift
//  MusicDemo
//
//  Created by Pv, Unnikrishnan | Unni | IPESD on 2022/03/02.
//

import SwiftUI
import URLImage
import RealmSwift

let TV_IMAGE_URL = "https://image.tmdb.org/t/p/w1066_and_h600_bestv2/"

struct TVDetailView: View {
    var tvId: Int
    @State var isActive = false
    @State var videoId: String = ""
    @State var favImage: String = "heart"
    @ObservedObject var observed = TVLoader()
    
    var body: some View {
        if let tv = observed.tv{
                ScrollView(showsIndicators: false){
                    ZStack{
                        VStack{
                            DetailsPageTitleView(title: tv.name, genres: tv.genres, runtime: 55)
                            PosterOverlay(backdropPath: tv.backdropPath,
                                          status: tv.status,
                                          originalLanguage: tv.originalLanguage,
                                          budget: nil,
                                          revenue: nil)
                            IconsView(voteAverage: tv.voteAverage,
                                      homepage: tv.homepage,
                                      movieId: self.tvId, favCallBack: self.addToFavorite)
                            if let overview = tv.overview{
                                Text(overview)
                                    .font(.body)
                                    .italic()
                            }
                            CastView(movieId: self.tvId, isMovie: false)
                            RecommendationsView(movieId: self.tvId, isMovie: false)
                        }.navigationBarHidden(true)
                        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .topLeading)
                        }
                }.onAppear(perform: {
                observed.getTV(id: self.tvId)
            })
        }else{
            Text("Loading..")
                .onAppear(perform: {
                    observed.getTV(id: self.tvId)
            })
        }
    }
    
    func addToFavorite(){
        print("Inside")
    }
}



class TVLoader: ObservableObject{
    @Published var tv: TVAdditionalDetail? = nil
    
    init(tvId: Int? = nil){
        if let id = tvId{
            getTV(id: id)
        }
    }
    
    func getTV(id: Int){
        if id != 0 {
            APIManager.getAddiDetail(movieId: id, category: .TV) { [weak self](response) in
                if let tv = response as? TVAdditionalDetail {
                    self?.tv = tv
                }
            }
        }
    }
}

struct TVDetailView_Previews: PreviewProvider {
    static var previews: some View {
        TVDetailView(tvId: 60735)
    }
}
