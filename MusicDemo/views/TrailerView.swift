//
//  TrailerView.swift
//  MusicDemo
//
//  Created by Pv, Unnikrishnan | Unni | IPESD on 2022/03/01.
//

import SwiftUI
import URLImage
import RealmSwift

struct TrailerView: View {
    @State var isActive = false
    @State var movieId: Int = 0
    @State var isMovie = false
    @State var videos: MovieVideo?
    @State var videoId: String = ""
    
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
    
    @State private var trailerList: [MovieItem] = []
    
    func updateItems(index: Int) {
        let newIndex = index+6  //enum index
        APIManager.getMyList(id: ListId.allCases[newIndex]) { response in
            if let movielist = response as? ListResult {
                trailerList = movielist.results.map {
                    MovieItem(id: $0.id,
                          originalTitle: $0.title ?? "N/A",
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
            Text("Latest Trailers")
                .font(.title)
                .foregroundColor(.white)
            CustomToggleView(toggleOn: 0, options: ["Streaming", "On TV", "For Rent",
                                                    "In Theaters"], toggleCallback: self.toggleCallback)
                .frame(height: 50)
            ScrollView(.horizontal, showsIndicators: false){
                HStack{
                        ForEach(trailerList, id: \.self){movie in
                            NavigationLink(destination: self.getDestination(), isActive: $isActive){
                            VStack{
                                if let poster = movie.posterPath{
                                    URLImage(url: URL(string:  "\(TV_IMAGE_URL)\(poster)")!) { image in
                                        image
                                            .resizable()
                                            .frame(width: UIScreen.main.bounds.size.width*0.45,
                                                   height: UIScreen.main.bounds.size.width*0.25)
                                            .aspectRatio(contentMode: .fit)
                                    }.overlay(alignment: .center, content: {
                                        Image(systemName: "play.fill")
                                            .frame(maxWidth: 100)
                                            .foregroundColor(.white)
                                    })
                                }
                                Spacer()
                                Text(movie.originalTitle)
                                    .font(.body)
                                    .frame(width: UIScreen.main.bounds.size.width*0.40)
                                    .lineLimit(2)
                                    .offset(y: -2)
                                    .foregroundColor(.white)
                                    .frame(alignment:.bottom)
                            }.frame(height: UIScreen.main.bounds.size.width*0.30)
                            .onTapGesture(perform: {
                                isActive = true
                                self.movieId = movie.id
                                getVideos()
                            })
                        }
                    }
                }
            }
        }.background(.black)
        .onAppear(perform: {
            updateItems(index: 0)
        })
    }
    
    func toggleCallback(index: Int){
        updateItems(index: index)
    }
    
    func getDestination()->AnyView{
        return AnyView(VideoPlayer(videoId: self.videoId)
                    .navigationBarHidden(false)
                    .frame(minHeight: 0, maxHeight: UIScreen.main.bounds.size.height * 0.3)
                    .cornerRadius(12)
                    .padding(.horizontal, 24))
    }
    
    func playVideo(){
        for video in videos?.results ?? []{
            if video.site == "YouTube"{
                videoId = video.key
                isActive = true
            }
        }
    }
    
    func getVideos(){
        APIManager.getMovieVideos(category: self.isMovie ? .MOVIES : .TV, movieId: self.movieId){ response in
            if let video = response as? MovieVideo {
                self.videos = video
                playVideo()
            }
        }
    }
}

struct TrailerView_Previews: PreviewProvider {
    static var previews: some View {
        TrailerView()
    }
}
