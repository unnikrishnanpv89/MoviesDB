//
//  ListMovies.swift
//  MusicDemo
//
//  Created by Pv, Unnikrishnan | Unni | IPESD on 2022/02/17.
//

import SwiftUI
import URLImage
import RealmSwift

let realm = try! Realm()

struct FavouriteListTV: View {

    struct TVItem: Hashable {
        var id: Int
        var originalName: String
        var popularity: Double
        var posterPath: String?
        var voteCount: Int
        var voteAverage: Double
        var firstAirDate: String
    }
    
    private var favItems: Results<TVDetails> = realm.objects(TVDetails.self)
    @State var didAppear = false
    //@ObservedObject var tvobserved = FavTVListModel()
    @State private var favTvList: [TVItem] = []
    
    func updateItems() {
        favTvList = favItems.map {
                TVItem(id: $0.id,
                       originalName: $0.originalName,
                       popularity: $0.popularity,
                       posterPath: $0.posterPath,
                       voteCount: $0.voteCount,
                       voteAverage: $0.voteAverage,
                       firstAirDate: $0.firstAirDate ?? "N/A")
            }
    }
    
    var body: some View {
        List{
            ForEach(favTvList, id: \.self){tv in
                ZStack {
                    RoundedRectangle(cornerRadius: 15, style: .circular)
                        .fill(.black)
                        .shadow(radius: 10)
                    HStack{
                        if let poster = tv.posterPath{
                            URLImage(url: URL(string:  "\(BASE_IMAGE_URL)\(poster)")!) { image in
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                            }
                        }
                        VStack {
                            HStack {
                                Text(tv.originalName)
                                    .foregroundColor(.cyan)
                                    .fontWeight(.bold)
                                    .font(.headline)
                                Spacer()
                            }
                            HStack {
                                Text(tv.firstAirDate ?? "N/A")
                                    .foregroundColor(.white)
                                    .font(Font.body)
                                Spacer()
                                /*Text("Rate: \(tv.voteAverage.format())")
                                    .foregroundColor(.red)
                                    .font(Font.body)*/
                                RatingStart(rating: tv.voteAverage.format(), maxRating: 5)
                            }
                            HStack {
                                Text("Vote count: \(tv.voteCount)")
                                    .font(Font.body)
                                    .foregroundColor(.white)
                                    .lineLimit(nil)
                                Spacer()
                            }
                            HStack {
                                Text("Popularity: \(tv.popularity.kmFormatted)")
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
                                if let index = favTvList.firstIndex(of: tv){
                                    deleteRow(index: index)
                                }
                            })
                    }
                )
            }
        }
        .frame(maxHeight: .infinity, alignment: .topLeading)
        .navigationBarHidden(false)
        .onAppear(){
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

struct FavListTV_Previews: PreviewProvider {
    static var previews: some View {
        FavouriteListTV()
    }
}
