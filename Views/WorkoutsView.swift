import SwiftUI

struct WorkoutsView: View {
    @EnvironmentObject var store: WorkoutStore
    @State private var showingAddWorkout = false
    @State private var workoutToEdit: Workout?
    @State private var searchText = ""

    var sortedWorkouts: [Workout] {
        store.workouts.sorted { $0.date > $1.date }
    }

    var filteredWorkouts: [Workout] {
        guard !searchText.isEmpty else { return sortedWorkouts }
        return sortedWorkouts.filter { $0.type.localizedCaseInsensitiveContains(searchText) }
    }

    var body: some View {
        NavigationStack {
            Group {
                if store.workouts.isEmpty {
                    emptyState
                } else {
                    List {
                        ForEach(filteredWorkouts) { workout in
                            NavigationLink(destination: WorkoutDetailView(workout: workout)) {
                                WorkoutRowView(workout: workout)
                            }
                            .swipeActions(edge: .leading, allowsFullSwipe: true) {
                                Button {
                                    store.toggleFavorite(workout)
                                } label: {
                                    Label(
                                        workout.isFavorite ? "Unfavourite" : "Favourite",
                                        systemImage: workout.isFavorite ? "star.slash.fill" : "star.fill"
                                    )
                                }
                                .tint(.yellow)
                            }
                            .swipeActions(edge: .trailing) {
                                Button(role: .destructive) {
                                    if let i = store.workouts.firstIndex(where: { $0.id == workout.id }) {
                                        store.deleteWorkout(at: IndexSet([i]))
                                    }
                                } label: {
                                    Label("Delete", systemImage: "trash")
                                }
                                Button {
                                    workoutToEdit = workout
                                } label: {
                                    Label("Edit", systemImage: "pencil")
                                }
                                .tint(.blue)
                            }
                        }
                    }
                    .searchable(text: $searchText, prompt: "Search exercises")
                    .listStyle(.insetGrouped)
                }
            }
            .navigationTitle("Workouts")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button { showingAddWorkout = true } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingAddWorkout) {
                AddWorkoutView(editingWorkout: nil)
            }
            .sheet(item: $workoutToEdit) { workout in
                AddWorkoutView(editingWorkout: workout)
            }
        }
    }

    var emptyState: some View {
        VStack(spacing: 16) {
            Image(systemName: "dumbbell.fill")
                .font(.system(size: 64))
                .foregroundStyle(.blue.opacity(0.25))
            Text("No Workouts Yet")
                .font(.title2)
                .fontWeight(.semibold)
            Text("Tap + to log your first workout.")
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

// MARK: – Row

struct WorkoutRowView: View {
    var workout: Workout

    var body: some View {
        HStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(Color.blue.opacity(0.12))
                    .frame(width: 44, height: 44)
                Image(systemName: "dumbbell.fill")
                    .foregroundColor(.blue)
                    .font(.subheadline)
            }
            VStack(alignment: .leading, spacing: 3) {
                HStack(spacing: 4) {
                    Text(workout.type)
                        .font(.headline)
                    if workout.isFavorite {
                        Image(systemName: "star.fill")
                            .font(.caption2)
                            .foregroundColor(.yellow)
                    }
                }
                Text("\(workout.sets) sets × \(workout.reps) reps @ \(workout.weight, specifier: "%.1f") kg")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            Spacer()
            Text(workout.date, style: .date)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding(.vertical, 4)
    }
}
