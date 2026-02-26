import SwiftUI

struct SplitsView: View {
    @EnvironmentObject var store: WorkoutStore
    @State private var showingAddSplit = false

    var body: some View {
        NavigationStack {
            Group {
                if store.splits.isEmpty {
                    emptySplitsState
                } else {
                    List {
                        ForEach(store.splits.indices, id: \.self) { index in
                            SplitRowView(
                                split: store.splits[index],
                                isToday: !store.splits.isEmpty && index == store.currentSplitIndex % store.splits.count
                            )
                        }
                        .onDelete(perform: store.deleteSplit)
                    }
                    .listStyle(.insetGrouped)
                }
            }
            .navigationTitle("Splits")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    if !store.splits.isEmpty { EditButton() }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button { showingAddSplit = true } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingAddSplit) {
                AddSplitView()
            }
        }
    }

    var emptySplitsState: some View {
        VStack(spacing: 16) {
            Image(systemName: "square.grid.2x2.fill")
                .font(.system(size: 64))
                .foregroundStyle(.blue.opacity(0.25))
            Text("No Splits Yet")
                .font(.title2).fontWeight(.semibold)
            Text("Tap + to create your first split\n(e.g. Push / Pull / Legs).")
                .multilineTextAlignment(.center)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

// MARK: – Row

struct SplitRowView: View {
    var split: WorkoutSplit
    var isToday: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(split.name)
                    .font(.headline)
                Spacer()
                if isToday {
                    Label("Today", systemImage: "calendar.badge.checkmark")
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundColor(.blue)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.blue.opacity(0.1))
                        .cornerRadius(8)
                }
            }
            if !split.workoutTypes.isEmpty {
                Text(split.workoutTypes.joined(separator: "  •  "))
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
            }
        }
        .padding(.vertical, 4)
    }
}
