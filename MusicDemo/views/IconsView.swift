//
//  IconsView.swift
//  MusicDemo
//
//  Created by Pv, Unnikrishnan | Unni | IPESD on 2022/03/04.
//

import SwiftUI
import RealmSwift

struct IconsView: View {
    
    let voteAverage: Double?
    let homepage: String?
    let movieId: Int
    var favCallBack: () -> ()
    @State var videos: MovieVideo?
    @State var isActive = false
    @State var videoId: String = ""
    @State var favImage: String = "heart"
    
    var body: some View {
        HStack(spacing: 50){
            if let voteAverage = voteAverage {
                RatingView(rating: voteAverage.formatCircle()).frame(alignment: .leading)
            }
            Image(systemName: getShareIcon(url: homepage ?? nil))
                .resizable()
                .foregroundColor(.white)
                .frame(width: 50, height: 50)
                .onTapGesture(perform: {
                    if let url = homepage{
                        shareUrl(url: url)
                    }
                })
            
            Image(systemName: favImage)
                .resizable()
                .foregroundColor(.white)
                .frame(width: 50, height: 50)
                .onTapGesture(perform: {
                    self.favCallBack()
                    favImage = "heart.fill"
                })
            
            NavigationLink(destination:
                            //VideoPlayer(videoId: videoId)
                            //    .navigationBarHidden(false)
                           VideoListView(id: movieId)
                            //.frame(minHeight: 0, maxHeight: UIScreen.main.bounds.size.height * 0.3)
                            //.cornerRadius(12)
                            //.padding(.horizontal, 24)
                            ,isActive: $isActive){
                    Image(systemName: "play.fill")
                        .resizable()
                        .foregroundColor(.white)
                        .frame(width: 50, height: 50)
            }
        }.onTapGesture(perform: {})
        .frame(width: UIScreen.main.bounds.size.width)
        .background(Rectangle().fill(Color(UIColor.black)))
        .offset(y: -7)
        .onAppear(perform: {
            //getVideos(id: self.movieId)
            getFavImage(movieId: movieId)
        })
    }
    
    func getShareIcon(url: String?)->String{
        if url == nil {
            return "square.and.arrow.up.circle"
        }else{
            return "square.and.arrow.up.circle.fill"
        }
    }
    
    func getFavImage(movieId: Int){
        if realm.objects(MovieDetail.self).filter("id  == \(self.movieId)").first != nil {
            favImage = "heart.fill"
        }else{
            favImage = "heart"
        }
    }
    
    /*func playVideo(){
        for video in videos?.results ?? []{
            print(video)
            if video.type == "Trailer" && video.site == "YouTube"{
                videoId = video.key
                isActive = true
            }
        }
    }
    
    func getVideos(id: Int){
        APIManager.getMovieVideos(category: .MOVIES, movieId: id){ response in
            if let video = response as? MovieVideo {
                self.videos = video
            }
        }
    }*/

    func shareUrl(url: String){
        guard let urlShare = URL(string: url) else { return }
        let activityVC = UIActivityViewController(activityItems: [urlShare], applicationActivities: nil)
        UIApplication.shared.windows.first?.rootViewController?.present(activityVC, animated: true, completion: nil)
    }
}

struct IconsView_Previews: PreviewProvider {
    static var previews: some View {
        IconsView(voteAverage: 7.5, homepage: "www.vom", movieId: 12345, favCallBack: {()})
    }
}
