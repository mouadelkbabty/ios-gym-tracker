import Foundation

struct Workout: Identifiable, Codable, Hashable {
    var id: UUID = UUID()
    var type: String
    var sets: Int
    var reps: Int
    var weight: Double
    var date: Date
    var isFavorite: Bool = false
}
