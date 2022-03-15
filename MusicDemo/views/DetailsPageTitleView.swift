//
//  DetailsPageTitleView.swift
//  MusicDemo
//
//  Created by Pv, Unnikrishnan | Unni | IPESD on 2022/03/04.
//

import SwiftUI

struct DetailsPageTitleView: View {
    
    var title: String?
    var genres: [Genre]?
    var runtime: Int?
    
    var body: some View {
        VStack{
            if let title = title{
                Text(title)
                    .font(.title)
                    .bold()
            }
            HStack(spacing: 10){
                HStack{
                    if let genres = genres{
                        ForEach(genres, id: \.id) { genre in
                            NavigationLink(destination:
                                            ListMovies(genreId: genre.id)){
                                Text(genre.name)
                                    .font(.body)
                                    .background(.yellow)
                                    .lineLimit(1)
                            }
                        }
                    }
                }.frame(alignment:.leading)
                HStack{
                    Image(systemName: "clock.circle")
                    
                    if let runtime = runtime {
                        Text("\(runtime)m")
                            .font(.body)
                    }
                }.frame(alignment:.trailing)
            }
        }
    }
}

struct DetailsPageTitleView_Previews: PreviewProvider {
    static var previews: some View {
        DetailsPageTitleView(title: "Sample Title",
                             genres: [Genre(id: 123, name: "Sample1"),
                                      Genre(id: 123, name: "Sample2"),
                                      Genre(id: 123, name: "Sample4")],
                             runtime: 55)
    }
}
