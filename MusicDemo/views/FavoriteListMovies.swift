//
//  ListMovies.swift
//  MusicDemo
//
//  Created by Pv, Unnikrishnan | Unni | IPESD on 2022/02/17.
//

import SwiftUI
import URLImage
import RealmSwift

struct FavouriteListMovies: View {

    struct MovieItem: Hashable {
        var id: Int
        var originalTitle: String
        var popularity: Double
        var posterPath: String?
        var voteCount: Int
        var voteAverage: Double
        var releaseDate: String?
    }
    
    private var favItems: Results<MovieDetail> = realm.objects(MovieDetail.self)
    @State private var favMovieList: [MovieItem] = []
    
    func updateItems() {
        favMovieList = favItems.map {
                MovieItem(id: $0.id,
                          originalTitle: $0.originalTitle,
                          popularity: $0.popularity,
                          posterPath: $0.posterPath,
                          voteCount: $0.voteCount,
                          voteAverage: $0.voteAverage,
                          releaseDate: $0.releaseDate ?? "N/A")
            }
    }
    
    var body: some View {
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
                                Text("Rate: \(movie.voteAverage.format())")
                                    .foregroundColor(.red)
                                    .font(Font.body)
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
        .frame(alignment: SwiftUI.Alignment.topLeading)
        .navigationBarHidden(false)
        .foregroundColor(.red)
        .onAppear(){
            print("Appear")
            updateItems()
        }
    }
    
    private func deleteRow(index: Int){
        try! realm.write {
            realm.delete(self.favItems[index])
        }
        updateItems()
    }
}

struct FavListMovie_Previews: PreviewProvider {
    static var previews: some View {
        FavouriteListMovies()
    }
}
