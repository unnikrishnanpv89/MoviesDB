//
//  CastView.swift
//  MusicDemo
//
//  Created by Pv, Unnikrishnan | Unni | IPESD on 2022/03/04.
//

import SwiftUI
import URLImage

struct CastView: View {
    var movieId: Int = 0
    var isMovie: Bool = true
    @State var isActive = false
    @State var castCrew = [CastElement]()
    @State var castId = 0
    
    var body: some View {
        VStack{
            HStack{
            Text("Cast")
                .font(.title)
                .frame(maxWidth: .infinity, alignment: .leading)
            }
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack{
                    ForEach(castCrew, id: \.id) { cast in
                        NavigationLink(destination: PeopleDetailView(castId: castId),
                                       isActive: $isActive){
                        if let poster = cast.profile_path{
                            ZStack {
                                RoundedRectangle(cornerRadius: 5, style: .continuous)
                                    .fill(.white)
                                VStack{
                                    URLImage(url: URL(string:  "\(ORIGINAL_IMAGE_URL)\(poster)")!) { image in
                                                image
                                            .resizable()
                                            .frame(width: UIScreen.main.bounds.size.width*0.25,
                                                height: UIScreen.main.bounds.size.width*0.40)
                                            .aspectRatio(contentMode: .fit)
                                    }
                                    Text(cast.character ?? "N/A")
                                        .bold()
                                        .offset(y: -3)
                                        .frame(width: UIScreen.main.bounds.size.width*0.20)
                                        .font(.body)
                                    Text("(\(cast.original_name))")
                                        .font(.body)
                                        .frame(width: UIScreen.main.bounds.size.width*0.25)
                                        .font(.body)
                                }.background(.white)
                            }.frame(height: UIScreen.main.bounds.size.width*0.55)
                                .onTapGesture(perform: {
                                    isActive = true
                                    self.castId = cast.id
                                })
                        }
                    }
                    }//navigationLink
                }
                }
        }.onAppear(perform: {
            getCast(id: self.movieId, isMovie: self.isMovie)
        })
    }
    
    func getCast(id: Int, isMovie: Bool){
        print("Inside")
        APIManager.getCredits(category: isMovie == true ? .MOVIES : .TV, movieId: id) { response in
            if let cast = response as? Cast {
                self.castCrew = cast.cast
            }
        }
    }
}


struct CastView_Previews: PreviewProvider {
    static var previews: some View {
        CastView(movieId: 634649, isMovie: true)
    }
}
