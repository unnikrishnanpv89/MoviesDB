//
//  ListMovies.swift
//  MusicDemo
//
//  Created by Pv, Unnikrishnan | Unni | IPESD on 2022/02/17.
//

import SwiftUI
import RealmSwift
import ObjectMapper

struct ListTVs: View {
    var genreId: Int = 0
    var isMovie: Bool = true
    var searchString: String = ""
    @State var isActive = false
    @State var movieId = 0
    @State var favList = [Int]()
    @ObservedObject var tvobserved = TVListViewModel()
    
    init(genreId: Int){
        self.genreId = genreId
    }
    init(searchString: String){
        self.searchString = searchString
    }
    
    var body: some View {
        if tvobserved.emptyList {
            Text("OOPS, no results found for search!")
                .foregroundColor(.red)
                .font(.title)
                .lineLimit(nil)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
        }
        List{
            ForEach(Array(tvobserved.tvlist.enumerated()), id: \.offset){ index, vm in
                NavigationLink(destination:
                                TVDetailView(tvId: movieId).navigationBarHidden(false),
                               isActive: $isActive){
                    ListRowCardView(isMovie: false, favImage: getFavImage(id: vm.id), callback: addToFavourites, tv: vm)
                        .onTapGesture(perform: {
                            isActive = true
                            movieId = vm.id
                        })
                /*ZStack {
                    RoundedRectangle(cornerRadius: 15, style: .circular)
                        .fill(.black)
                        .shadow(radius: 10)
                    HStack{
                        if let poster = vm.tv.posterPath{
                            URLImage(url: URL(string:  "\(BASE_IMAGE_URL)\(poster)")!) { image in
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                            }.overlay(alignment: .bottom,
                                      content: {
                                RatingStart(rating: vm.tv.voteAverage.format(), maxRating: 5)
                            })
                        }
                        VStack {
                            HStack {
                                Text(vm.tv.originalName)
                                    .foregroundColor(.cyan)
                                    .fontWeight(.bold)
                                    .font(.headline)
                                Spacer()
                            }
                            HStack {
                                Text(vm.tv.firstAirDate ?? "N/A")
                                    .foregroundColor(.white)
                                    .font(Font.body)
                                Spacer()
                            }
                            HStack {
                                Text("Vote count: \(vm.tv.voteCount)")
                                    .font(Font.body)
                                    .foregroundColor(.white)
                                    .lineLimit(nil)
                                Spacer()
                            }
                            HStack {
                                Text("Popularity: \(vm.tv.popularity.kmFormatted)")
                                    .foregroundColor(.white)
                                    .font(Font.body)
                                    .lineLimit(nil)
                                Spacer()
                            }
                        }
                    }.onTapGesture(perform: {
                        isActive = true
                        movieId = vm.tv.id
                    })
                    .frame(height: UIScreen.main.bounds.height*0.22)
                    .onAppear {
                        if index%paginIndex == 0{
                            loadTVSeries(index: index)
                        }
                    }
                }
                .overlay(alignment: .bottomTrailing,
                     content: {
                    Image(systemName: getFavImage(id: vm.tv.id))
                        .foregroundColor(.red)
                            .padding([.bottom, .trailing], 5)
                            .onTapGesture(perform: {
                               addToFavourites(tvserial: vm)
                            })
                    }
                )*/
                }//navigationLink
            }
        }.navigationBarHidden(false)
        .onAppear {
            if self.genreId > 0{
                tvobserved.getTVSeries(genreId: self.genreId)
            }else{
                tvobserved.getTVSeries(searchString: self.searchString)
            }
        }
    }
    
    func loadTVSeries(index: Int){
        if index/paginIndex == tvobserved.pageNum{
            print(index, paginIndex, tvobserved.pageNum)
            if self.genreId > 0{
                tvobserved.getTVSeries(genreId: self.genreId)
            }else{
                tvobserved.getTVSeries(searchString: self.searchString)
            }
        }
    }
    
    func getFavImage(id: Int) -> String{
        if favList.contains(id){
            return "heart.fill"
        } else{
            return "heart"
        }
    }
    
    func addToFavourites(tvVM: Any){
        if let tvVM = tvVM as? TVViewModel{
            if let index = favList.firstIndex(of: tvVM.id) {
                if let tv = realm.objects(TVDetails.self).filter("id  == \(tvVM.id)").first {
                    try! realm.write {
                        realm.delete(tv)
                    }
                }
                favList.remove(at: index)
            }else{
                realm.beginWrite()
                realm.create(TVDetails.self, value: tvVM.tv, update: Realm.UpdatePolicy.modified)
                 if realm.isInWriteTransaction {
                      try! realm.commitWrite()
                 }
                favList.append(tvVM.id)
            }
        }
    }
    
    func getFavorites(){
        let realm = try! Realm()
        let favTvList = realm.objects(TVDetails.self)
        for tv in favTvList{
            favList.append(tv.id)
        }
    }
    
}

struct ListTV_Previews: PreviewProvider {
    static var previews: some View {
        ListTVs(genreId: 16)
    }
}



class TVListViewModel : ObservableObject{
    @Published var tvlist = [TVViewModel]()
    @Published var loading = false
    @Published var emptyList = false
    var genreId: Int
    var searchString: String
    var pageNum: Int = 0
    var total_page: Int = 1
    
    init(genreId: Int? = nil, searchString: String? = nil){
        if let id = genreId{
            loading = true
            self.genreId = id
            self.searchString = ""
        }else if let query = searchString{
            self.searchString = query
            loading = true
            self.genreId = 0
        }else{
            self.tvlist = [TVViewModel]()
            self.genreId = 0
            self.searchString = ""
        }
    }
    
    func getTVSeries(genreId: Int? = nil){
        if genreId == 0{
            return
        }
        pageNum += 1
        if pageNum > total_page || pageNum < 1{
            return
        }
        print("Fetching page: ", pageNum)
        if let gId = genreId{
            if gId > 0 {
                APIManager.getMovies(category: .TV, genreId: gId, pageNum: pageNum) { [weak self](response) in
                        if let tvlist = response as? TvList{
                            self?.pageNum = tvlist.page
                            self?.total_page = tvlist.totalPages
                            self?.tvlist.append(contentsOf: tvlist.results.map(TVViewModel.init))
                            self?.loading = false
                            self?.emptyList =  tvlist.totalResults > 0 ? false : true
                    }
                }
            }
        }
    }
    
    func getTVSeries(searchString: String? = nil){
        if (searchString ?? "").isEmpty{
            return
        }
        pageNum += 1
        if pageNum > total_page || pageNum < 1{
            return
        }
        print("Fetching page: ", pageNum)
        if let search = searchString {
            if !search.isEmpty{
                APIManager.searchMovies(category: .TV, query: search, pageNum: pageNum) { [weak self](response) in
                    if let tvlist = response as? TvList{
                        self?.pageNum = tvlist.page
                        self?.total_page = tvlist.totalPages
                        self?.tvlist.append(contentsOf: tvlist.results.map(TVViewModel.init))
                        self?.loading = false
                        self?.emptyList =  tvlist.totalResults > 0 ? false : true
                    }
                }
            }
        }
    }
}

class TVViewModel{
    
    var tv: TVDetails
       
       init(tv: TVDetails){
           self.tv = tv
       }
       
       var id: Int{
           self.tv.id
       }
    
    static func == (lhs: TVViewModel, rhs: TVViewModel) -> Bool {
        lhs.id == rhs.id
    }
}

