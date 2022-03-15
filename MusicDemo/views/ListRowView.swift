//
//  ListRowView.swift
//  MusicDemo
//
//  Created by Pv, Unnikrishnan | Unni | IPESD on 2022/03/10.
//

import SwiftUI
import URLImage

struct ListRowView: View {
    var movie: MovieViewModel
    var favImage: String
    var callBack: (MovieViewModel) -> ()
    
    var body: some View {
        HStack{
            ZStack{
            RoundedRectangle(cornerRadius: 15, style: .continuous)
                .fill(.white)
                .shadow(radius: 10)
            GeometryReader { geo in
                RoundedRectangle(cornerRadius: 15, style: .circular)
                    .fill(.black)
                    .shadow(radius: 10)
                HStack{
                    HStack{
                        if let poster = movie.posterPath{
                            URLImage(url: URL(string:  "\(BASE_IMAGE_URL)\(poster)")!) { image in
                                image
                                    .resizable()
                                    .frame(width: geo.size.width * 0.3)
                                    .aspectRatio(contentMode: .fit)
                                    .frame(alignment: .leading)
                            }
                        }
                    }.frame(width: geo.size.width * 0.3, alignment: .leading)
                    HStack{
                        VStack{
                            Text(movie.originalTitle)
                                .font(.title)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .lineLimit(2)
                                .foregroundColor(.white)
                            Spacer()
                            Text(movie.releaseDate ?? "N/A")
                                .font(.body)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .foregroundColor(.white)
                            Spacer()
                            Text("Vote Count: \(movie.voteCount ?? 0)")
                                .font(.body)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .foregroundColor(.white)
                            Spacer()
                            Text("Popularity: \(movie.popularity)")
                                .font(.body)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .foregroundColor(.white)
                        }
                    }.frame(width: geo.size.width * 0.45, alignment: .leading)
                    HStack{
                        VStack{
                            RatingStart(rating: movie.voteAverage?.format() ?? 0, maxRating: 5)
                                .onAppear(perform: {
                                    print(movie.voteAverage?.format(), "????")
                                })
                                .frame(maxWidth: geo.size.width * 0.95, alignment: .trailing)
                            Spacer()
                            Image(systemName: favImage)
                                .resizable()
                                .frame(width:40, alignment: .trailing)
                                .aspectRatio(contentMode: .fit)
                                .foregroundColor(.red)
                                .onTapGesture(perform: {
                                    self.callBack(movie)
                                })
                        }
                    }.frame(width: geo.size.width * 0.22, alignment: .trailing)
                }.frame(maxWidth: .infinity)
            }
            }
        }.background(.black)
    }
}

/*struct ListRowView_Previews: PreviewProvider {
    static var previews: some View {
        ListRowView(movie: MovieViewModel(id: 123,
                                      originalTitle: "This is the Movie Title",
                                      popularity: 1455,
                                      posterPath: "/iQFcwSGbZXMkeyKrxbPnwnRo5fl.jpg",
            voteCount: 1234444,
            voteAverage: 7.2,
          releaseDate: "2002-05-01"),
                    callBack: {})
.previewInterfaceOrientation(.portraitUpsideDown)
    }
}*/
