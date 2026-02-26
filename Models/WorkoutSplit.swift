import Foundation

struct WorkoutSplit: Identifiable, Codable, Hashable {
    var id: UUID = UUID()
    var name: String
    var workoutTypes: [String]
}
