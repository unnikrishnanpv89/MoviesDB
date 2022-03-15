//
//  PeopleDetailView.swift
//  MusicDemo
//
//  Created by Pv, Unnikrishnan | Unni | IPESD on 2022/03/07.
//

import SwiftUI
import URLImage

struct PeopleDetailView: View {
    var castId : Int
    @State var isActive = false
    @State var person : PeopleDetail?
    
    var body: some View {
        if let person = person {
            ScrollView(showsIndicators: false){
                ZStack{
            VStack{
                HStack{
                    Group{
                        URLImage(url: URL(string:  "\(ORIGINAL_IMAGE_URL)\(person.profilePath)")!) { image in
                                    image
                                .resizable()
                                .frame(maxWidth: UIScreen.main.bounds.size.width/2,
                                       maxHeight: UIScreen.main.bounds.size.width*0.75)
                                .aspectRatio(contentMode: .fit)
                        }
                        VStack{
                            Text(person.name)
                                .bold()
                                .font(.title)
                            Spacer()
                            Group {
                                Text("Known For")
                                    .font(.title3)
                                    .bold()
                                Text(person.knownForDepartment ?? "N/A")
                                    .font(.body)
                                Spacer()
                            }
                            Group {
                                if person.alsoKnownAs.count > 0{
                                    Text("Also Known As")
                                        .font(.title3)
                                        .bold()
                                    Text(person.alsoKnownAs[0])
                                        .font(.body)
                                    Spacer()
                                }
                            }
                            Group {
                                Text("Gender")
                                    .font(.title3)
                                    .bold()
                                Text(person.gender == 2 ? "Male" : "Female")
                                    .font(.body)
                            }
                            Group {
                                Spacer()
                                Text("BirthDay")
                                    .font(.title3)
                                    .bold()
                                
                                Text(person.birthday ?? "N/A")
                                    .font(.body)
                            }
                        }.frame(maxWidth: UIScreen.main.bounds.size.width/2,
                                maxHeight: 350)
                    } //group
                }.frame(maxWidth: .infinity, minHeight: 300, alignment: .topLeading)
                Text("Biography")
                    .bold()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(.title2)
                Text(person.biography ?? "No biography available")
                    .font(.body)
                
                    }
                }
                CreditsView(personId: person.id)
            }.frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .topLeading)
        }else{
            Text("Loading...").onAppear(perform: {
                getPersonDetail(id: self.castId)
            })
        }
    }
    
    func getPersonDetail(id: Int){
        APIManager.getPersonDetail(id: id) { response in
            if let detail = response as? PeopleDetail {
                self.person = detail
            }
        }
    }
}

struct PeopleDetailView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            PeopleDetailView(castId: 1136406)
                .previewDevice("iPad (9th generation)")
            PeopleDetailView(castId: 1136406)
        }
    }
}
