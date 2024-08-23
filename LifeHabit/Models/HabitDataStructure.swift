import Foundation

struct HabitDataStructure: Codable {
    var id: UUID = UUID()
    var name: String
    var identity: String
    var time: String
    var doWhere: String
    var reward: String
    var startDate: Date
    var isCompleted: Bool
}
