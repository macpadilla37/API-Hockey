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
            
            let url = URL(string: "https://run.mocky.io/v3/c63cc6a0-bcfc-49d6-ba3d-7a1331e9f1a2")!
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
    @State private var selectedTeamIndex = 0
    @Environment(\.dismiss) var dismiss
    
    func getAllTeams() async {
        do {
            isLoading = true
            
            let url = URL(string: "https://run.mocky.io/v3/c63cc6a0-bcfc-49d6-ba3d-7a1331e9f1a2")!
            let (data, _) = try await URLSession.shared.data(from: url)
            
            NHL = try JSONDecoder().decode(NationalHockeyLeague.self, from: data).teams
        } catch {
            print("Error: \(error.localizedDescription)")
        }
    }
    
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                Text("Abbreviation: \(NHL.first?.abbreviation ?? "")")
                Text("City: \(NHL.first?.city ?? "")")
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
