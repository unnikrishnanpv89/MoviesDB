//
//  CreditsView.swift
//  MusicDemo
//
//  Created by Pv, Unnikrishnan | Unni | IPESD on 2022/03/07.
//

import SwiftUI
import URLImage

struct CreditsView: View {
    @State var isActive = false
    @State var personId: Int = 0
    @State var movieId: Int = 0
    @State private var creditList: [CreditItem] = []
    @State private var isMovie = false
    
    struct CreditItem: Hashable {
        var id: Int
        var media: String
        var originalTitle: String
        var posterPath: String?
        var voteAverage: Double
        var releaseDate: String?
    }
    
    var body: some View {
        VStack{
        Text("Known For:")
            .font(.title)
            .frame(maxWidth: .infinity, alignment: .leading)
            ScrollView(.horizontal, showsIndicators: false){
                HStack{
                    ForEach(creditList, id: \.id){movie in
                        NavigationLink(destination: getDestination(type: self.isMovie),
                                       isActive: $isActive){
                            VStack{
                                if let poster = movie.posterPath{
                                    URLImage(url: URL(string:  "\(BASE_IMAGE_URL)\(poster)")!) { image in
                                        image
                                            .resizable()
                                            .frame(width: UIScreen.main.bounds.size.width*0.25,
                                                height: UIScreen.main.bounds.size.width*0.45)
                                            .aspectRatio(contentMode: .fit)
                                            .overlay(
                                                RatingView(rating: movie.voteAverage.formatCircle()).offset(y:25)
                                                ,alignment: .bottomLeading)
                                    }
                                }
                                Spacer()
                                Text(movie.originalTitle)
                                    .font(.body)
                                    .frame(width: UIScreen.main.bounds.size.width*0.30)
                                    .lineLimit(2)
                                    .frame(alignment:.bottom)
                            }.frame(maxHeight: UIScreen.main.bounds.size.width*0.55)
                                .onTapGesture(perform: {
                                    isActive = true
                                    self.movieId = movie.id
                                    self.isMovie = movie.media == "movie" ? true : false
                                })
                        }
                    }
                }
        }.onAppear(perform: {
            getCredits(id: self.personId)
        })
        }
    }
    
    func getDestination(type: Bool)->AnyView{
        return type ? AnyView(MovieDetailView(movieId: self.movieId)) :
                        AnyView(TVDetailView(tvId: self.movieId))
    }
    
    func getCredits(id: Int){
        APIManager.getPersonCombCredits(id: id) { response in
            if let credit = response as? Credits {
                creditList = credit.cast.map {
                    CreditItem(id: $0.id, media: $0.mediaType,
                               originalTitle: $0.originalTitle ?? "N/A",
                              posterPath: $0.posterPath,
                              voteAverage: $0.voteAverage,
                              releaseDate: $0.releaseDate ?? "N/A")
                }
            }
        }
    }
    
}

struct CreditsView_Previews: PreviewProvider {
    static var previews: some View {
        CreditsView(personId: 1136406)
    }
}
