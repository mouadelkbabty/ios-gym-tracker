import SwiftUI

struct WorkoutDetailView: View {
    @EnvironmentObject var store: WorkoutStore
    @State private var showingEdit = false

    var workout: Workout

    /// Always read the live (possibly mutated) version from the store.
    var live: Workout {
        store.workouts.first { $0.id == workout.id } ?? workout
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                headerCard
                statsRow
                volumeCard
                if live.isFavorite {
                    favouriteLabel
                }
            }
            .padding()
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle("Detail")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                HStack(spacing: 14) {
                    Button {
                        store.toggleFavorite(live)
                    } label: {
                        Image(systemName: live.isFavorite ? "star.fill" : "star")
                            .foregroundColor(.yellow)
                    }
                    Button("Edit") { showingEdit = true }
                }
            }
        }
        .sheet(isPresented: $showingEdit) {
            AddWorkoutView(editingWorkout: live)
        }
    }

    // MARK: – Sub-views

    var headerCard: some View {
        ZStack {
            LinearGradient(
                colors: [.blue, .blue.opacity(0.65)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing)
            .cornerRadius(20)

            VStack(spacing: 10) {
                Image(systemName: "dumbbell.fill")
                    .font(.system(size: 44))
                    .foregroundColor(.white.opacity(0.8))
                Text(live.type)
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                Text(live.date, style: .date)
                    .foregroundColor(.white.opacity(0.8))
            }
            .padding()
        }
        .frame(height: 168)
    }

    var statsRow: some View {
        HStack(spacing: 14) {
            statCard(title: "Sets",   value: "\(live.sets)",                            icon: "arrow.clockwise",   color: .blue)
            statCard(title: "Reps",   value: "\(live.reps)",                            icon: "repeat",            color: .green)
            statCard(title: "Weight", value: "\(live.weight, specifier: "%.1f") kg",   icon: "scalemass.fill",    color: .orange)
        }
    }

    var volumeCard: some View {
        let vol = Double(live.sets) * Double(live.reps) * live.weight
        return VStack(alignment: .leading, spacing: 6) {
            Label("Total Volume", systemImage: "bolt.fill")
                .font(.headline)
                .foregroundColor(.purple)
            Text("\(vol, specifier: "%.0f") kg")
                .font(.system(size: 40, weight: .bold, design: .rounded))
                .foregroundColor(.purple)
            Text("Sets × Reps × Weight")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.07), radius: 6, x: 0, y: 2)
    }

    var favouriteLabel: some View {
        HStack {
            Image(systemName: "star.fill").foregroundColor(.yellow)
            Text("Marked as Favourite").foregroundColor(.secondary)
        }
        .font(.subheadline)
    }

    func statCard(title: String, value: String, icon: String, color: Color) -> some View {
        VStack(spacing: 8) {
            Image(systemName: icon).foregroundColor(color).font(.title3)
            Text(value).font(.title3).fontWeight(.bold)
            Text(title).font(.caption).foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(14)
        .shadow(color: .black.opacity(0.07), radius: 6, x: 0, y: 2)
    }
}
