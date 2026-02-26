import SwiftUI

struct AddWorkoutView: View {
    @EnvironmentObject var store: WorkoutStore
    @Environment(\.dismiss) var dismiss

    var editingWorkout: Workout?

    @State private var type: String      = ""
    @State private var sets: Int         = 3
    @State private var reps: Int         = 10
    @State private var weight: Double    = 60.0
    @State private var date: Date        = Date()
    @State private var isFavorite: Bool  = false

    var isEditing: Bool { editingWorkout != nil }

    let commonExercises = [
        "Bench Press", "Incline Dumbbell Press", "Overhead Press",
        "Tricep Dips", "Pull-ups", "Barbell Row", "Bicep Curls",
        "Squat", "Deadlift", "Leg Press", "Lunges", "Lat Pulldown"
    ]

    // MARK: – Body

    var body: some View {
        NavigationStack {
            Form {
                exerciseSection
                detailsSection
                optionsSection
            }
            .navigationTitle(isEditing ? "Edit Workout" : "Log Workout")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button(isEditing ? "Save" : "Add") {
                        commit()
                        dismiss()
                    }
                    .fontWeight(.semibold)
                    .disabled(type.trimmingCharacters(in: .whitespaces).isEmpty)
                }
            }
            .onAppear(perform: prefill)
        }
    }

    // MARK: – Sections

    var exerciseSection: some View {
        Section("Exercise") {
            TextField("Exercise name", text: $type)
                .autocorrectionDisabled()

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(commonExercises, id: \.self) { ex in
                        Button(ex) { type = ex }
                            .buttonStyle(ChipButtonStyle(selected: type == ex))
                    }
                }
                .padding(.vertical, 6)
            }
        }
    }

    var detailsSection: some View {
        Section("Details") {
            Stepper("Sets: \(sets)", value: $sets, in: 1...20)
            Stepper("Reps: \(reps)", value: $reps, in: 1...100)
            HStack {
                Text("Weight (kg)")
                Spacer()
                TextField("kg", value: $weight, format: .number.precision(.fractionLength(1)))
                    .keyboardType(.decimalPad)
                    .multilineTextAlignment(.trailing)
                    .frame(width: 80)
            }
            DatePicker("Date", selection: $date, displayedComponents: .date)
        }
    }

    var optionsSection: some View {
        Section("Options") {
            Toggle(isOn: $isFavorite) {
                Label("Mark as Favourite", systemImage: "star.fill")
            }
            .tint(.yellow)
        }
    }

    // MARK: – Helpers

    func prefill() {
        guard let w = editingWorkout else { return }
        type       = w.type
        sets       = w.sets
        reps       = w.reps
        weight     = w.weight
        date       = w.date
        isFavorite = w.isFavorite
    }

    func commit() {
        let trimmedType = type.trimmingCharacters(in: .whitespaces)
        if isEditing, var updated = editingWorkout {
            updated.type       = trimmedType
            updated.sets       = sets
            updated.reps       = reps
            updated.weight     = weight
            updated.date       = date
            updated.isFavorite = isFavorite
            store.updateWorkout(updated)
        } else {
            store.addWorkout(Workout(
                type: trimmedType,
                sets: sets, reps: reps,
                weight: weight, date: date,
                isFavorite: isFavorite))
        }
    }
}

// MARK: – Chip Button Style

struct ChipButtonStyle: ButtonStyle {
    var selected: Bool

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.caption)
            .padding(.horizontal, 10)
            .padding(.vertical, 6)
            .background(selected ? Color.blue : Color(.systemGray6))
            .foregroundColor(selected ? .white : .primary)
            .cornerRadius(8)
            .opacity(configuration.isPressed ? 0.75 : 1)
    }
}
