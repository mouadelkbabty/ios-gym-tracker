import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            HomeView()
                .tabItem { Label("Home",     systemImage: "house.fill") }

            WorkoutsView()
                .tabItem { Label("Workouts", systemImage: "list.bullet") }

            SplitsView()
                .tabItem { Label("Splits",   systemImage: "square.grid.2x2.fill") }
        }
        .accentColor(.blue)
    }
}
