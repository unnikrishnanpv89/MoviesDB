//
//  VideoListView.swift
//  MusicDemo
//
//  Created by Pv, Unnikrishnan | Unni | IPESD on 2022/03/14.
//

import SwiftUI
import URLImage

struct VideoListView: View {
    
    var id: Int
    @State var videos: MovieVideo?
    
    
    var body: some View {
        VStack{
            if let videos = videos{
                if let results = videos.results{
                    ScrollView {
                        VStack(spacing: 20) {
                            ForEach(results, id: \.id){ video in
                                if video.site == "YouTube"{
                                    NavigationLink(destination:  VideoPlayer(videoId: video.key)
                                                   .frame(minHeight: 0, maxHeight: UIScreen.main.bounds.size.height * 0.3)
                                                   .cornerRadius(12)
                                                    .padding(.horizontal, 24)){
                                            URLImage(url: URL(string:  "http://img.youtube.com/vi/\(video.key)/0.jpg")!) { image in
                                                image
                                                    .resizable()
                                                    .aspectRatio(contentMode: .fit)
                                            }.overlay(alignment: .center, content: {
                                                Image(systemName: "play.fill")
                                                    .frame(maxWidth: 100)
                                                    .foregroundColor(.white)
                                            })
                                    }
                                }
                            }
                        }
                    }
                }else{
                    Text("No video found!")
                }
            }else{
                Text("Loading...")
            }
        }.onAppear(perform: {
            getVideos(id: id)
        })
    }
    
    
    func getVideos(id: Int){
        APIManager.getMovieVideos(category: .MOVIES, movieId: id){ response in
            if let video = response as? MovieVideo {
                self.videos = video
            }
        }
    }
}

struct VideoListView_Previews: PreviewProvider {
    static var previews: some View {
        VideoListView(id: 634649)
    }
}
