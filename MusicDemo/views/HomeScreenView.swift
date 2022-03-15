//
//  HomeScreenView.swift
//  MusicDemo
//
//  Created by Pv, Unnikrishnan | Unni | IPESD on 2022/02/14.
//

import SwiftUI

struct HomeScreenView: View {
    
    @ObservedObject var observed = GenreListObserver(category: .MOVIES)
    @State private var searchKeyEntered = false
    @State private var searchString: String = ""
    @State private var selection: Int?
    @State private var isMovie: Bool = true
    var body: some View {
        VStack {
            TabView {
                    HomeScreen()
                    .font(.system(size: 30, weight: .bold, design: .rounded))
                    .tabItem {
                        Image(systemName: "house.fill")
                        Text("Home")
                }
                NavigationView{
                    List{
                        NavigationLink(destination: getDestination(searchString: $searchString.wrappedValue),
                                       isActive: $searchKeyEntered) {}
                        .opacity(0)
                        .background(
                            HStack {
                                TextField("Search", text: $searchString,
                                          onCommit: {
                                            searchKeyEntered = true
                                    })
                                    .background(Color(.systemGray6))
                                    .cornerRadius(8)
                                Spacer()
                                Image(systemName: "magnifyingglass")
                              }
                            .foregroundColor(.gray)
                                .onTapGesture {
                                    if !$searchString.wrappedValue.isEmpty{
                                        searchKeyEntered = true
                                    } else{
                                        searchKeyEntered = false
                                    }
                                }
                        )
                        CustomToggleView(toggleOn: isMovie ? 0 : 1, options: ["Movies", "TV"], toggleCallback: self.toggleMovieSearch)
                        Spacer()
                        ForEach(observed.genreCategory, id: \.id) { genre in
                            NavigationLink(destination: getDestination(genreId: genre.id))
                            {
                                Text(genre.name)
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                    .navigationBarHidden(true)
                    .onAppear(
                        perform: {
                            toggleMovieSearch(index: 0)
                        }
                    )
                }.navigationViewStyle(StackNavigationViewStyle())
                .font(.system(size: 30, weight: .bold, design: .rounded))
                .tabItem {
                    Image(systemName: "magnifyingglass")
                    Text("Search")
                }
                
                favoriteList(isMovie: true)
                    .font(.system(size: 30, weight: .bold, design: .rounded))
                    .tabItem {
                        Image(systemName: "heart.fill")
                        Text("Favorite")
                }
             
                SettingsView()
                    .font(.system(size: 30, weight: .bold, design: .rounded))
                    .tabItem {
                        Image(systemName: "gearshape")
                        Text("Settings")
                }
            }
            .accentColor(.black)
        }
    }
    
    func getDestination(genreId: Int) -> AnyView {
        if self.isMovie {
            return AnyView(ListMovies(genreId: genreId))
        } else {
            return AnyView(ListTVs(genreId: genreId))
        }
    }
    
    func getDestination(searchString: String) -> AnyView {
        if self.isMovie {
            return AnyView(ListMovies(searchString: searchString))
        } else {
            return AnyView(ListTVs(searchString: searchString))
        }
    }
    
    func toggleMovieSearch(index: Int) {
        self.isMovie = index == 0 ? true : false
        observed.getCategory(category: self.isMovie ? GenreParent.MOVIES : .TV)
    }
}

struct HomeScreenView_Previews: PreviewProvider {
    static var previews: some View {
        HomeScreenView()
    }
}

enum GenreParent: String{
    case MOVIES = "movie"
    case TV = "tv"
}

class GenreListObserver : ObservableObject{
    @Published var genreCategory : [Genre]
    var category : GenreParent
    
    init(category: GenreParent){
        self.genreCategory = [Genre]()
        self.category = category
        self.getCategory(category: self.category)
    }
    
    func getCategory(category: GenreParent){
        APIManager.getAllGenre(category: category){  [weak self](response) in
            self?.genreCategory = response.genres
        }
    }
    
    
}
