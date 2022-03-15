//
//  ListRowCardView.swift
//  MusicDemo
//
//  Created by Pv, Unnikrishnan | Unni | IPESD on 2022/03/11.
//

import SwiftUI
import URLImage

struct ListRowCardView: View {
    var tv : TVViewModel?
    var movie : MovieViewModel?
    var isMovie: Bool
    var displayItem : RowItem?
    var favImage: String
    var callback : (Any) -> ()
    
    struct RowItem: Hashable {
        var id: Int
        var originalTitle: String
        var popularity: Double
        var posterPath: String?
        var voteCount: Int
        var voteAverage: Double
        var releaseDate: String?
    }
    
    init(isMovie: Bool, favImage: String, callback: @escaping (Any) -> (),
         tv: TVViewModel? = nil,
         movie: MovieViewModel? = nil){
        self.isMovie = isMovie
        self.tv = tv
        self.movie = movie
        self.favImage = favImage
        self.callback = callback
        updateItems()
    }
    
    mutating func updateItems() {
        if isMovie{
            displayItem = movie.flatMap({
                RowItem(id: $0.id,
                        originalTitle: $0.movie.originalTitle,
                        popularity: $0.movie.popularity,
                        posterPath: $0.movie.posterPath,
                        voteCount: $0.movie.voteCount,
                        voteAverage: $0.movie.voteAverage ?? 0,
                        releaseDate: $0.movie.releaseDate)
            })
        } else{
            displayItem = tv.flatMap({
                RowItem(id: $0.id,
                        originalTitle: $0.tv.originalName,
                        popularity: $0.tv.popularity,
                        posterPath: $0.tv.posterPath,
                        voteCount: $0.tv.voteCount,
                        voteAverage: $0.tv.voteAverage ?? 0,
                        releaseDate: $0.tv.firstAirDate)
            })
        }
    }
    
    var body: some View {
        if let displayItem = displayItem{
            VStack{
                ZStack {
                    RoundedRectangle(cornerRadius: 15, style: .circular)
                        .fill(.black)
                        .shadow(radius: 10)
                    HStack{
                        HStack{
                            if let poster = displayItem.posterPath{
                                URLImage(url: URL(string:  "\(BASE_IMAGE_URL)\(poster)")!) { image in
                                    image
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                }.overlay(alignment: .bottom,
                                          content: {
                                    RatingStart(rating: displayItem.voteAverage.format(), maxRating: 5).offset(y:25)
                                })
                            }
                        }.frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                        HStack{
                            VStack {
                                Text(displayItem.originalTitle)
                                        .foregroundColor(.cyan)
                                        .fontWeight(.bold)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .font(.headline)
                                    Spacer()
                                Text(displayItem.releaseDate ?? "N/A")
                                        .foregroundColor(.white)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .font(Font.body)
                                    Spacer()
                                Text("Vote count: \(displayItem.voteCount)")
                                        .font(Font.body)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .foregroundColor(.white)
                                        .lineLimit(nil)
                                    Spacer()
                                    HStack{
                                        Text("Popularity: \(displayItem.popularity.kmFormatted)")
                                            .foregroundColor(.white)
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                            .font(Font.body)
                                            .lineLimit(nil)
                                        Spacer()
                                        Image(systemName: favImage)
                                            .foregroundColor(.red)
                                            .onTapGesture(perform: {
                                                if let movie = self.movie{
                                                    self.callback(movie)
                                                }else if let tv = self.tv{
                                                    self.callback(tv)
                                                }
                                            })
                                    }
                            }
                        }.frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                    }.frame(height: UIScreen.main.bounds.height*0.22)
                }
            }
        }
    }
}

/*struct ListRowCardView_Previews: PreviewProvider {
    static var previews: some View {
        ListRowCardView()
.previewInterfaceOrientation(.portrait)
    }
}*/
