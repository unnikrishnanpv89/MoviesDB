//
//  HomeScreen.swift
//  MusicDemo
//
//  Created by Pv, Unnikrishnan | Unni | IPESD on 2022/03/01.
//

import SwiftUI

struct HomeScreen: View {

    var body: some View {
        NavigationView {
            ScrollView(.vertical){
                VStack{
                    PopularScreen().navigationBarHidden(true)
                    FreeToWatch().navigationBarHidden(true)
                    TrailerView().navigationBarHidden(true)
                    TrendingView().navigationBarHidden(true)
                    Spacer()
                }.frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .topLeading)
            }
        }.navigationViewStyle(StackNavigationViewStyle())
    }
}

struct HomeScreen_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            HomeScreen()
            HomeScreen()
                .previewDevice("iPhone 12")
        }
    }
}
