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
    let city: String
}


struct TeamsView: View {
    @State var NHL =  [Team]()
    @State var isLoading = false
    @State private var showingSheet = false
    
    func getAllTeams() async {
        do {
            isLoading = true
            
            let url = URL(string: "https://run.mocky.io/v3/3c4f07b8-2d8b-4c20-9fb4-812b2438768c")!
            let (data, _) = try await URLSession.shared.data(from: url)
            
            NHL = try JSONDecoder().decode(NationalHockeyLeague.self, from: data).teams
        } catch {
            print("Error: \(error.localizedDescription)")
        }
    }
    
    var body: some View {
        NavigationView {
            List(NHL) { team in
                VStack(alignment: .leading) {
                    Button(team.name){
                            showingSheet = true
                                    }
                                    .sheet(isPresented: $showingSheet) {
                                        SheetView()
                                    }
                                }
            }
            .task {
                await getAllTeams()
            }
        }
        .navigationTitle("Team")
    }
}

struct TeamView_Previews: PreviewProvider {
    static var previews: some View {
        TeamsView()
    }
}

struct SheetView: View {
    @State var NHL =  [Team]()
    @State var isLoading = false
    @Environment(\.dismiss) var dismiss
    
    func getAllTeams() async {
        do {
            isLoading = true
            
            let url = URL(string: "https://run.mocky.io/v3/3c4f07b8-2d8b-4c20-9fb4-812b2438768c")!
            let (data, _) = try await URLSession.shared.data(from: url)
            
            NHL = try JSONDecoder().decode(NationalHockeyLeague.self, from: data).teams
        } catch {
            print("Error: \(error.localizedDescription)")
        }
    }
    
    
    var body: some View {
        NavigationView {
            List(NHL) { team in
                VStack(alignment: .leading) {
                    Text(team.abbreviation)
                    Text(team.city)
                }
                }
            .task {
                await getAllTeams()
            }
        }
        Button("Press to Dismiss") {
            dismiss()
        }
    }
}
