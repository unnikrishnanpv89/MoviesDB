//
//  ListMovies.swift
//  MusicDemo
//
//  Created by Pv, Unnikrishnan | Unni | IPESD on 2022/02/17.
//

import SwiftUI
import RealmSwift
import URLImage
import ObjectMapper

let BASE_IMAGE_URL = "https://image.tmdb.org/t/p/w220_and_h330_face/"
let paginIndex = 15
let realm = try! Realm()

struct ListMovies: View {
    var genreId: Int = 0
    var isMovie: Bool = true
    var searchString: String = ""
    @State var movieId = 0
    @State var isActive = false
    @State var favList = [Int]()
    @ObservedObject var observed = MovieListViewModel()
    
    init(genreId: Int){
        self.genreId = genreId
    }
    init(searchString: String){
        self.searchString = searchString
    }
    
    var body: some View {
        if observed.emptyList {
            Text("OOPS, no results found for search!")
                .foregroundColor(.red)
                .font(.title)
                .lineLimit(nil)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
        }else{
            ScrollView {
                VStack(spacing: 20) {
                    ForEach(Array(observed.movies.enumerated()), id: \.offset){index, vm in
                        NavigationLink(destination:
                                    MovieDetailView(movieId: movieId)
                                    .navigationBarHidden(false),
                                   isActive: $isActive){
                            ListRowCardView(isMovie: true, favImage: getFavImage(id: vm.id),
                                            callback: addToFavourites, movie: vm)
                                .onTapGesture(perform: {
                                    isActive = true
                                    movieId = vm.id
                                }).onAppear(perform: {
                                    //if index % paginIndex == 0{
                                      // loadMovies(index: index)
                                   //}
                                })
                        }
                    }
                }
            }.onAppear {
                if self.genreId > 0{
                    observed.getMovies(genreId: self.genreId)
                }else{
                    observed.getMovies(searchString: self.searchString)
                }
                getFavorites()
            }
            .frame(maxHeight: .infinity)
        }
    }
    
    func loadMovies(index: Int){
        if index/paginIndex == observed.pageNum{
            print(index, paginIndex, observed.pageNum)
            if self.genreId > 0{
                observed.getMovies(genreId: self.genreId)
            }else{
                observed.getMovies(searchString: self.searchString)
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
    
    func addToFavourites(movieVm: Any){
        if let movieVm = movieVm as? MovieViewModel{
            if let index = favList.firstIndex(of: movieVm.id) {
                if let movie = realm.objects(MovieDetail.self).filter("id  == \(movieVm.id)").first {
                    try! realm.write {
                        realm.delete(movie)
                    }
                }
                favList.remove(at: index)
            }else{
                realm.beginWrite()
                realm.create(MovieDetail.self, value: movieVm.movie, update: Realm.UpdatePolicy.modified)
                 if realm.isInWriteTransaction {
                      try! realm.commitWrite()
                 }
                favList.append(movieVm.id)
            }
        }
    }
    
    func getFavorites(){
        let realm = try! Realm()
        let favTvList = realm.objects(MovieDetail.self)
        for tv in favTvList{
            favList.append(tv.id)
        }
    }
    
}

extension Array{
    var paginationIndex : MovieViewModel? {
        get {
            if let mvm = self[15] as? MovieViewModel{
                return mvm
            }else {
                return nil
            }
        }
    }
}

extension Double {
    func format() -> CGFloat {
        return CGFloat(truncating: NumberFormatter().number(from: String(format: "%.2f",self))!)/2
    }
    
    var kmFormatted: String {
        if self >= 10000, self <= 999999 {
            return String(format: "%.1fK", locale: Locale.current,self/1000).replacingOccurrences(of: ".0", with: "")
        }

        if self > 999999 {
            return String(format: "%.1fM", locale: Locale.current,self/1000000).replacingOccurrences(of: ".0", with: "")
        }

        return String(format: "%.0f", locale: Locale.current,self)
    }
}

struct ListMovies_Previews: PreviewProvider {
    static var previews: some View {
        ListMovies(genreId: 16)
    }
}

class MovieListViewModel : ObservableObject{
    @Published var movies = [MovieViewModel]()
    @Published var loading = false
    @Published var emptyList = false
    var genreId: Int
    var searchString: String
    var pageNum: Int = 0
    var total_page: Int = 1
    
    init(genreId: Int? = nil, searchString: String? = nil){
        if let id = genreId{
            print("id is set ", id)
            loading = true
            self.genreId = id
            self.searchString = ""
        }else if let query = searchString{
            print("searchString is set ", searchString)
            self.searchString = query
            loading = true
            self.genreId = 0
        }else{
            self.movies = [MovieViewModel]()
            self.genreId = 0
            self.searchString = ""
        }
    }
    
    func getMovies(genreId: Int? = nil){
        if genreId == 0{
            return
        }
        pageNum += 1
        if pageNum > total_page || pageNum < 1{
            return
        }
        if let gId = genreId{
            if gId > 0 {
                APIManager.getMovies(category: .MOVIES, genreId: gId, pageNum: pageNum) { [weak self](response) in
                        if let movielist = response as? MovieList{
                            self?.pageNum = movielist.page
                            self?.total_page = movielist.totalPages
                            self?.movies.append(contentsOf: movielist.results.map(
                                MovieViewModel.init
                            ))
                            self?.loading = false
                            self?.emptyList =  movielist.totalResults > 0 ? false : true
                            print(self?.movies.count)
                        }
                }
            }
        }
    }
    
    func getMovies(searchString: String? = nil){
        if (searchString ?? "").isEmpty{
            return
        }
        pageNum += 1
        if pageNum > total_page || pageNum < 1{
            return
        }
        if let search = searchString {
            if !search.isEmpty{
                APIManager.searchMovies(category: .MOVIES, query: search, pageNum: pageNum) { [weak self](response) in
                    if let movielist = response as? MovieList{
                        self?.pageNum = movielist.page
                        self?.total_page = movielist.totalPages
                        self?.movies.append(contentsOf: movielist.results.map(
                            MovieViewModel.init
                        ))
                        self?.loading = false
                        self?.emptyList =  movielist.totalResults > 0 ? false : true
                    }
                }
            }
        }
    }
    
}

class MovieViewModel {
    
    var movie: MovieDetail
       
       init(movie: MovieDetail){
           self.movie = movie
       }
       
       var id: Int{
           self.movie.id
       }
    
    static func == (lhs: MovieViewModel, rhs: MovieViewModel) -> Bool {
        return lhs.id == rhs.id ? true : false
    }
    
    
}
