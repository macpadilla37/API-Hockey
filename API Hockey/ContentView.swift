//
//  ContentView.swift
//  API Hockey
//
//  Created by Mac Padilla on 9/19/23.
//

import SwiftUI

struct NationalHockeyLeague: Codable, Identifiable {
    var id: Int { return UUID().hashValue }
    let copyright: String
    let teams: [Team]

}

struct Team: Codable, Identifiable {
    let id: Int
    let name: String
    let abbreviation: String
    let firstYearOfPlay: String
    let officialSiteUrl: String
}


struct TeamsView: View {
    let DarkRed = Color(red: 125/255, green: 23/255, blue: 23/255)
    let lightBlue = Color(red: 215/255, green: 242/255, blue: 1)
    let weirdOrange = Color(red: 255/255, green: 210/255, blue: 84/255)
    @State var NHL =  [Team]()
    @State var isLoading = false
    
    func getAllTeams() async {
        do {
            isLoading = true
            
            let url = URL(string: "https://statsapi.web.nhl.com/api/v1/teams")!
            let (data, _) = try await URLSession.shared.data(from: url)
            
            NHL = try JSONDecoder().decode(NationalHockeyLeague.self, from: data).teams
        } catch {
            print("Error: \(error.localizedDescription)")
        }
    }
    
    var body: some View {
        NavigationView {
            List(NHL) { team in
                VStack(alignment: .leading){
                    NavigationLink {
                        ZStack {
                            Color(DarkRed)
                                .ignoresSafeArea()
                        VStack{
                            Text("Team:")
                                .foregroundColor(Color(weirdOrange))
                            Text(team.name)
                                .padding(EdgeInsets(top: 0, leading: 10, bottom: 20, trailing: 10))
                                .foregroundColor(Color(lightBlue))
                            Text("Abbreviation:")
                                .foregroundColor(Color(weirdOrange))
                            Text(team.abbreviation)
                                .padding(EdgeInsets(top: 0, leading: 10, bottom: 20, trailing: 10))
                                .foregroundColor(Color(lightBlue))
                            Text("First Year Team Played:")
                                .foregroundColor(Color(weirdOrange))
                            Text(team.firstYearOfPlay)
                                .padding(EdgeInsets(top: 0, leading: 10, bottom: 20, trailing: 10))
                                .foregroundColor(Color(lightBlue))
                            Link("Site URL", destination: URL(string: team.officialSiteUrl)!)
                            
                        }
                    }
                    }label: {
                        Text(team.name)
                        
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .listRowBackground(Color(lightBlue))
            }
            .task {
                await getAllTeams()
                
            }.foregroundColor(Color(DarkRed))
            .navigationTitle("Teams")
        }
    }
}

struct TeamView_Previews: PreviewProvider {
    static var previews: some View {
        TeamsView()
    }
}

