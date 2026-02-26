import SwiftUI

struct AddSplitView: View {
    @EnvironmentObject var store: WorkoutStore
    @Environment(\.dismiss) var dismiss

    @State private var name: String       = ""
    @State private var exercises: [String] = [""]

    let presets = ["Push", "Pull", "Legs", "Upper", "Lower", "Full Body", "Cardio", "Rest Day"]

    var body: some View {
        NavigationStack {
            Form {
                nameSection
                exercisesSection
            }
            .navigationTitle("New Split")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        store.addSplit(WorkoutSplit(
                            name: name.trimmingCharacters(in: .whitespaces),
                            workoutTypes: exercises
                                .map { $0.trimmingCharacters(in: .whitespaces) }
                                .filter { !$0.isEmpty }
                        ))
                        dismiss()
                    }
                    .fontWeight(.semibold)
                    .disabled(name.trimmingCharacters(in: .whitespaces).isEmpty)
                }
            }
        }
    }

    // MARK: – Sections

    var nameSection: some View {
        Section("Split Name") {
            TextField("e.g. Push, Pull, Legs…", text: $name)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(presets, id: \.self) { preset in
                        Button(preset) { name = preset }
                            .buttonStyle(ChipButtonStyle(selected: name == preset))
                    }
                }
                .padding(.vertical, 6)
            }
        }
    }

    var exercisesSection: some View {
        Section("Exercises in this Split") {
            ForEach(exercises.indices, id: \.self) { i in
                TextField("Exercise \(i + 1)", text: $exercises[i])
            }
            .onDelete { exercises.remove(atOffsets: $0) }

            Button {
                exercises.append("")
            } label: {
                Label("Add Exercise", systemImage: "plus")
            }
        }
    }
}
