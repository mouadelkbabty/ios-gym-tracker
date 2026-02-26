import Foundation
import Combine

class WorkoutStore: ObservableObject {

    @Published var workouts: [Workout] = [] {
        didSet { saveWorkouts() }
    }

    @Published var splits: [WorkoutSplit] = [] {
        didSet { saveSplits() }
    }

    @Published var currentSplitIndex: Int = 0 {
        didSet {
            UserDefaults.standard.set(currentSplitIndex, forKey: "currentSplitIndex")
        }
    }

    private let workoutsKey = "gymtracker_workouts"
    private let splitsKey   = "gymtracker_splits"

    // MARK: – Init

    init() {
        loadWorkouts()
        loadSplits()
        currentSplitIndex = UserDefaults.standard.integer(forKey: "currentSplitIndex")
    }

    // MARK: – Computed

    var todaySplit: WorkoutSplit? {
        guard !splits.isEmpty else { return nil }
        return splits[currentSplitIndex % splits.count]
    }

    // MARK: – Actions

    func advanceSplit() {
        guard !splits.isEmpty else { return }
        currentSplitIndex = (currentSplitIndex + 1) % splits.count
    }

    func addWorkout(_ workout: Workout) {
        workouts.append(workout)
    }

    func updateWorkout(_ workout: Workout) {
        guard let index = workouts.firstIndex(where: { $0.id == workout.id }) else { return }
        workouts[index] = workout
    }

    func deleteWorkout(at offsets: IndexSet) {
        workouts.remove(atOffsets: offsets)
    }

    func toggleFavorite(_ workout: Workout) {
        guard let index = workouts.firstIndex(where: { $0.id == workout.id }) else { return }
        workouts[index].isFavorite.toggle()
    }

    func addSplit(_ split: WorkoutSplit) {
        splits.append(split)
    }

    func deleteSplit(at offsets: IndexSet) {
        splits.remove(atOffsets: offsets)
    }

    // MARK: – Persistence

    private func saveWorkouts() {
        if let data = try? JSONEncoder().encode(workouts) {
            UserDefaults.standard.set(data, forKey: workoutsKey)
        }
    }

    private func loadWorkouts() {
        guard let data = UserDefaults.standard.data(forKey: workoutsKey),
              let decoded = try? JSONDecoder().decode([Workout].self, from: data)
        else { return }
        workouts = decoded
    }

    private func saveSplits() {
        if let data = try? JSONEncoder().encode(splits) {
            UserDefaults.standard.set(data, forKey: splitsKey)
        }
    }

    private func loadSplits() {
        if let data = UserDefaults.standard.data(forKey: splitsKey),
           let decoded = try? JSONDecoder().decode([WorkoutSplit].self, from: data) {
            splits = decoded
        } else {
            // Seed default PPL splits on first launch
            splits = [
                WorkoutSplit(name: "Push",  workoutTypes: ["Bench Press", "Overhead Press", "Tricep Dips"]),
                WorkoutSplit(name: "Pull",  workoutTypes: ["Pull-ups", "Barbell Row", "Bicep Curls"]),
                WorkoutSplit(name: "Legs",  workoutTypes: ["Squat", "Deadlift", "Leg Press"])
            ]
        }
    }
}
