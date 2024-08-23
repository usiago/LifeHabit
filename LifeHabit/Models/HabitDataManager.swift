import Foundation

class HabitDataManager {
    
    // Example DataList
    var habitDataList: [HabitDataStructure] = [
        HabitDataStructure(
            name: "물 200ml 마시기",
            identity: "아침 활기차게 시작",
            time: "6:00 AM",
            doWhere: "집",
            reward: "심호흡",
            startDate: Date(),
            isCompleted: false
        ),
        HabitDataStructure(
            name: "아침 10분 조깅",
            identity: "런닝은 유산소 명상",
            time: "7:00 AM",
            doWhere: "공원",
            reward: "식사",
            startDate: Date(),
            isCompleted: false
        ),
        HabitDataStructure(
            name: "독서 30분",
            identity: "지식 습득",
            time: "8:00 AM",
            doWhere: "서재",
            reward: "커피 한 잔",
            startDate: Date(),
            isCompleted: false
        ),
        HabitDataStructure(
            name: "점심 후 산책",
            identity: "소화 돕기",
            time: "1:00 PM",
            doWhere: "근처 공원",
            reward: "상쾌함",
            startDate: Date(),
            isCompleted: false
        ),
        HabitDataStructure(
            name: "저녁 스트레칭",
            identity: "유연성 유지",
            time: "9:00 PM",
            doWhere: "거실",
            reward: "편안한 잠",
            startDate: Date(),
            isCompleted: false
        )
    ]
    
    init() {
        loadHabitData()
    }

    // 데이터를 UserDefaults에 저장하는 메서드
    func saveHabitData() {
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(habitDataList)
            UserDefaults.standard.set(data, forKey: "habitDataList")
        } catch {
            print("❗️습관 데이터를 저장하는 데 실패했습니다: \(error.localizedDescription)")
        }
    }

    // 데이터를 UserDefaults에서 로드하는 메서드
    func loadHabitData() {
        if let data = UserDefaults.standard.data(forKey: "habitDataList") {
            do {
                let decoder = JSONDecoder()
                habitDataList = try decoder.decode([HabitDataStructure].self, from: data)
            } catch {
                print("❗️습관 데이터를 불러오는 데 실패했습니다: \(error.localizedDescription)")
            }
        }
    }

    // 정렬된 습관 데이터를 반환하는 메서드
    func getHabitData() -> [HabitDataStructure] {
        return habitDataList.sorted { habit1, habit2 in
            guard let date1 = habit1.time.toDate(), let date2 = habit2.time.toDate() else { return false }
            return date1 < date2
        }
    }
    
    
}


extension String {
    func toDate() -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm a"
        return dateFormatter.date(from: self)
    }
}
