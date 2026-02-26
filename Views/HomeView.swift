import SwiftUI

struct HomeView: View {
    @EnvironmentObject var store: WorkoutStore

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    todaySplitCard
                    progressCard
                    recentWorkoutsCard
                }
                .padding()
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("GymTracker")
            .navigationBarTitleDisplayMode(.large)
        }
    }

    // MARK: – Today's Split

    var todaySplitCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "calendar")
                    .foregroundColor(.blue)
                Text("Today's Split")
                    .font(.headline)
                Spacer()
                if !store.splits.isEmpty {
                    Text("\(store.currentSplitIndex % store.splits.count + 1)/\(store.splits.count)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }

            if let split = store.todaySplit {
                Text(split.name)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.blue)

                VStack(alignment: .leading, spacing: 6) {
                    ForEach(split.workoutTypes, id: \.self) { exercise in
                        HStack(spacing: 8) {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.green)
                                .font(.subheadline)
                            Text(exercise)
                                .font(.subheadline)
                        }
                    }
                }

                Button(action: { store.advanceSplit() }) {
                    Label("Done – Next Split", systemImage: "arrow.right.circle.fill")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                .padding(.top, 4)
            } else {
                Text("No splits defined yet. Go to the Splits tab to add one.")
                    .foregroundColor(.secondary)
                    .font(.subheadline)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.07), radius: 8, x: 0, y: 2)
    }

    // MARK: – Progress

    var progressCard: some View {
        let goal = 20
        let progress = min(Double(store.workouts.count) / Double(goal), 1.0)

        return VStack(alignment: .leading, spacing: 14) {
            HStack {
                Image(systemName: "chart.bar.fill")
                    .foregroundColor(.orange)
                Text("Progress")
                    .font(.headline)
                Spacer()
            }

            HStack(spacing: 0) {
                statItem(value: "\(store.workouts.count)", label: "Logged")
                Divider().frame(height: 36)
                statItem(value: "\(store.workouts.filter { $0.isFavorite }.count)", label: "Favourites")
                Divider().frame(height: 36)
                statItem(value: "\(thisWeekCount)", label: "This Week")
            }

            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text("Goal: \(goal) workouts")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Spacer()
                    Text("\(Int(progress * 100))%")
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundColor(.orange)
                }
                GeometryReader { geo in
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 4)
                            .fill(Color(.systemGray5))
                        RoundedRectangle(cornerRadius: 4)
                            .fill(Color.orange)
                            .frame(width: geo.size.width * CGFloat(progress))
                    }
                    .frame(height: 8)
                }
                .frame(height: 8)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.07), radius: 8, x: 0, y: 2)
    }

    // MARK: – Recent Workouts

    var recentWorkoutsCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "clock.fill")
                    .foregroundColor(.purple)
                Text("Recent Workouts")
                    .font(.headline)
                Spacer()
            }

            let recent = Array(store.workouts.sorted { $0.date > $1.date }.prefix(3))
            if recent.isEmpty {
                Text("No workouts logged yet.")
                    .foregroundColor(.secondary)
                    .font(.subheadline)
            } else {
                ForEach(recent) { workout in
                    VStack(spacing: 0) {
                        HStack {
                            VStack(alignment: .leading, spacing: 2) {
                                HStack(spacing: 4) {
                                    Text(workout.type)
                                        .font(.subheadline)
                                        .fontWeight(.medium)
                                    if workout.isFavorite {
                                        Image(systemName: "star.fill")
                                            .font(.caption2)
                                            .foregroundColor(.yellow)
                                    }
                                }
                                Text("\(workout.sets) sets × \(workout.reps) reps @ \(workout.weight, specifier: "%.1f") kg")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            Spacer()
                            Text(workout.date, style: .date)
                                .font(.caption2)
                                .foregroundColor(.secondary)
                        }
                        .padding(.vertical, 6)
                        if workout.id != recent.last?.id {
                            Divider()
                        }
                    }
                }
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.07), radius: 8, x: 0, y: 2)
    }

    // MARK: – Helpers

    @ViewBuilder
    func statItem(value: String, label: String) -> some View {
        VStack(spacing: 4) {
            Text(value)
                .font(.title2)
                .fontWeight(.bold)
            Text(label)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
    }

    var thisWeekCount: Int {
        let calendar = Calendar.current
        let weekStart = calendar.date(from: calendar.dateComponents(
            [.yearForWeekOfYear, .weekOfYear], from: Date()))!
        return store.workouts.filter { $0.date >= weekStart }.count
    }
}
