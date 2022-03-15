//
//  favoriteList.swift
//  MusicDemo
//
//  Created by Pv, Unnikrishnan | Unni | IPESD on 2022/02/24.
//

import SwiftUI
import URLImage
import RealmSwift

struct favoriteList: View {
    
    @State var isMovie: Bool
    //this is to save state of movie bool., we cannot reuse isMovie
    //since it is already used for state of toggle view
    struct FavItem: Hashable {
        var id: Int
        var originalTitle: String
        var popularity: Double
        var posterPath: String?
        var voteCount: Int
        var voteAverage: Double?
        var releaseDate: String?
    }
    
    init(isMovie: Bool){
        self.isMovie = isMovie
    }
    
    
    @State private var favMovieList: [FavItem] = []
    
    func updateItems() {
        if isMovie{
            let favItemsMovie = realm.objects(MovieDetail.self)
            favMovieList = favItemsMovie.map {
                FavItem(id: $0.id,
                          originalTitle: $0.originalTitle,
                          popularity: $0.popularity,
                          posterPath: $0.posterPath,
                          voteCount: $0.voteCount,
                          voteAverage: $0.voteAverage,
                          releaseDate: $0.releaseDate ?? "N/A")
            }
        } else{
            let favItemsMovie = realm.objects(TVDetails.self)
            favMovieList = favItemsMovie.map {
                FavItem(id: $0.id,
                          originalTitle: $0.originalName,
                          popularity: $0.popularity,
                          posterPath: $0.posterPath,
                          voteCount: $0.voteCount,
                          voteAverage: $0.voteAverage,
                          releaseDate: $0.firstAirDate ?? "N/A")
            }
        }
    }
    
    var body: some View {
        VStack{
            CustomToggleView(toggleOn: 0, options: ["Movies", "TV"], toggleCallback: self.toggleMovieFav)
                .frame(maxHeight:60)
            List{
                    ForEach(favMovieList, id: \.self){ movie in
                    ZStack {
                        RoundedRectangle(cornerRadius: 15, style: .circular)
                            .fill(.black)
                            .shadow(radius: 10)
                        HStack{
                            if let poster = movie.posterPath{
                                URLImage(url: URL(string:  "\(BASE_IMAGE_URL)\(poster)")!) { image in
                                    image
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                }
                            }
                            VStack {
                                HStack {
                                    Text(movie.originalTitle)
                                        .foregroundColor(.cyan)
                                        .fontWeight(.bold)
                                        .font(.headline)
                                    Spacer()
                                }
                                HStack {
                                    Text(movie.releaseDate ?? "N/A")
                                        .foregroundColor(.white)
                                        .font(Font.body)
                                    Spacer()
                                    RatingStart(rating: movie.voteAverage?.format() ?? 0, maxRating: 5)
                                }
                                HStack {
                                    Text("Vote count: \(movie.voteCount)")
                                        .font(Font.body)
                                        .foregroundColor(.white)
                                        .lineLimit(nil)
                                    Spacer()
                                }
                                HStack {
                                    Text("Popularity: \(movie.popularity.kmFormatted)")
                                        .foregroundColor(.white)
                                        .font(Font.body)
                                        .lineLimit(nil)
                                    Spacer()
                                }
                                Spacer()
                            }
                        }
                        .frame(height: 125)
                        .onTapGesture(perform: {
                            print("Tapped")
                        })
                    }
                    .overlay(alignment: .bottomTrailing,
                         content: {
                        Image(systemName: "heart.fill")
                            .foregroundColor(.red)
                                .padding([.bottom, .trailing], 5)
                                .onTapGesture(perform: {
                                    if let index = favMovieList.firstIndex(of: movie){
                                        deleteRow(index: index)
                                    }
                                })
                        }
                    )
                }
            }
            .navigationBarHidden(true)
            .onAppear(){
                updateItems()
            }
        }.frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .topLeading)
    }
    
    func toggleMovieFav(index: Int) {
        self.isMovie = !self.isMovie
        updateItems()
    }
    
    private func deleteRow(index: Int){
        if isMovie{
            let favItemsMovie = realm.objects(MovieDetail.self)
            try! realm.write {
                realm.delete(favItemsMovie[index])
            }
        }else{
            let favItemsTV = realm.objects(TVDetails.self)
            try! realm.write {
                realm.delete(favItemsTV[index])
            }
        }
        updateItems()
    }
}

struct favoriteList_Previews: PreviewProvider {
    static var previews: some View {
        favoriteList(isMovie: true)
    }
}
