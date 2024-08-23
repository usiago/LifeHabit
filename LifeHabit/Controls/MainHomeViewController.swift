import UIKit
import UserNotifications


class MainHomeViewController: UIViewController {
    
    @IBOutlet weak var progressBar: UIProgressView!
    
    @IBOutlet weak var progressBarNumber: UILabel!
    
    @IBOutlet weak var today: UILabel!
    
    @IBOutlet weak var mainTableView: UITableView!
    
    var habitDataManager = HabitDataManager()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // UI 세팅
        setUI()
        setTableViewDelegate_DataSource()
        
        
        // 로그인되어있지않으면 welcomeController로
        if !isLoggedIn() {
            toLoginPage()
        }
        
        setTableViewReload()
        updateProgressBar()
        setNotification()
    }
    
    
    
    /* ⬇️ 세팅 */
    func setUI() {
        view.backgroundColor = .black
        
        navigationBarSetting()
        todaySetting()
        tableViewSetting()
    }
    
    // 상단 네비게이션 세팅
    func navigationBarSetting() {
        // 네비게이션 아이템 타이틀에 로고 이미지 추가
        let logo = UIImage(named: "logoMini")
        let imageView = UIImageView(image: logo)
        imageView.contentMode = .scaleAspectFit
        
        // 컨테이너 뷰 생성
        let containerView = UIView()
        containerView.addSubview(imageView)
        
        // 오토레이아웃 설정
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 40) // 로고의 높이 설정
        ])
        
        navigationItem.titleView = containerView
        
        // 네비게이션 바 오른쪽에 + 버튼 추가
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))
        addButton.tintColor = .white // 버튼 색상을 흰색으로 설정
        navigationItem.rightBarButtonItem = addButton
        
        // 네비게이션 바 아이템 색상을 흰색으로 설정
        
        // 선을 추가할 UIView 생성
        let bottomBorder = UIView()
        bottomBorder.translatesAutoresizingMaskIntoConstraints = false
        bottomBorder.backgroundColor = .gray // 원하는 선 색상
        
        navigationController?.navigationBar.tintColor = .white
        
        // 네비게이션 바에 추가
        if let navigationBar = self.navigationController?.navigationBar {
            navigationBar.addSubview(bottomBorder)
            
            // 제약 조건 추가 (오토레이아웃)
            NSLayoutConstraint.activate([
                bottomBorder.heightAnchor.constraint(equalToConstant: 1), // 선의 두께 설정
                bottomBorder.leadingAnchor.constraint(equalTo: navigationBar.leadingAnchor),
                bottomBorder.trailingAnchor.constraint(equalTo: navigationBar.trailingAnchor),
                bottomBorder.bottomAnchor.constraint(equalTo: navigationBar.bottomAnchor)
            ])
        }
    }
    
    // Today 세팅
    func todaySetting() {
        today.textColor = .white
        today.text = printToday()
        today.sizeToFit()
        
    }
    
    func tableViewSetting() {
        mainTableView.backgroundColor = .black
        mainTableView.rowHeight = 130
        mainTableView.separatorColor = UIColor.darkGray
    }
    
    func setTableViewReload() {
        //  데이터를 로드하고 테이블뷰에 반영
        habitDataManager.loadHabitData()
        mainTableView.reloadData()
    }
    
    func setTableViewDelegate_DataSource() {
        mainTableView.delegate = self
        mainTableView.dataSource = self
    }
    
    func setNotification() {
        // 알림 권한 요청
        requestNotificationAuthorization()
        
        // 알림 등록
        scheduleAllHabitNotifications()
    }
    
    
    
    /* ⬇️ 기능 */
    // 오늘을 'yyyy년 m월 d일' 문자열형으로 반환하는 함수
    func printToday() -> String {
        // 오늘 날짜를 가져옵니다.
        let today = Date()
        
        // DateFormatter를 생성합니다.
        let dateFormatter = DateFormatter()
        
        // 날짜 형식을 설정합니다.
        dateFormatter.dateFormat = "yyyy년 M월 d일"
        
        // 오늘 날짜를 지정된 형식으로 변환합니다.
        let formattedDate = dateFormatter.string(from: today)
        
        return formattedDate
    }
    
    // 로그인 상태를 확인하여 코드
    func isLoggedIn() -> Bool {
        // 사용자의 로그인 상태를 확인하는 코드
        return false // 로그인 상태를 체크하고 필요에 따라 true/false 반환
    }
    
    // 로그인 or 회원가입 창 오픈
    func toLoginPage() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        if let welcomeVC = storyboard.instantiateViewController(withIdentifier: "WelcomeVC") as? WelcomeController {
            
            // 네비게이션 컨트롤러로 감싸기
            let welcomeNavController = UINavigationController(rootViewController: welcomeVC)
            
            // 네비게이션 컨트롤러를 모달로 present하기
            welcomeNavController.modalPresentationStyle = .fullScreen
            self.present(welcomeNavController, animated: true, completion: nil)
        }
        
    }
    
    // 오른쪽 상단 + 버튼 클릭 시 (AddhabitViewController)
    @objc func addButtonTapped() {
        guard let addHabitVC = storyboard?.instantiateViewController(withIdentifier: "AddHabitVC") as? AddHabitViewController else { return }
        addHabitVC.delegate = self
        //addHabitVC.data = "데이터전달"
        self.present(addHabitVC, animated: true, completion: nil)
    }
    
    // progress bar 업데이트
    func updateProgressBar() {
        let totalHabits = habitDataManager.getHabitData().count
        let completedHabits = habitDataManager.getHabitData().filter { $0.isCompleted }.count
        let progress = totalHabits > 0 ? Float(completedHabits) / Float(totalHabits) : 0
        
        progressBarNumber.text = progress == 0 ? "Start!" : String(format: "%.0f%%", progress * 100)
        progressBar.setProgress(progress, animated: true)
    }
    
    // 하루가 지나면 체크박스를 초기화하는 함수
    func resetHabitsForNewDay() {
        for index in habitDataManager.habitDataList.indices {
            habitDataManager.habitDataList[index].isCompleted = false
        }
        updateProgressBar()
        mainTableView.reloadData()
        
        // 마지막 초기화 날짜 저장
        UserDefaults.standard.set(Date(), forKey: "lastResetDate")
    }
    
    // 매일 자정에 초기화 작업을 스케줄하는 함수
    func scheduleDailyReset() {
        let now = Date()
        let calendar = Calendar.current
        
        // 다음 자정 시간을 계산
        if let nextMidnight = calendar.nextDate(after: now, matching: DateComponents(hour: 0, minute: 0), matchingPolicy: .nextTime) {
            
            // 다음 자정까지의 시간을 계산
            let timeInterval = nextMidnight.timeIntervalSince(now)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + timeInterval) { [weak self] in
                self?.resetHabitsForNewDay()
                self?.scheduleDailyReset()  // 다시 스케줄링하여 매일 자정에 초기화되도록 설정
            }
        }
    }
    
    // 앱이 포그라운드로 돌아올 때 자정이 지났는지 확인하여 초기화 업데이트 보장
    func sceneWillEnterForeground(_ scene: UIScene) {
        let lastResetDate = UserDefaults.standard.object(forKey: "lastResetDate") as? Date
        let now = Date()
        
        if lastResetDate == nil || Calendar.current.isDate(now, inSameDayAs: lastResetDate!) == false {
            resetHabitsForNewDay()
            UserDefaults.standard.set(now, forKey: "lastResetDate")
        }
    }

    
    // 알림 권한 요청
    func requestNotificationAuthorization() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if let error = error {
                print("알림 권한 요청 실패: \(error.localizedDescription)")
            } else if granted {
                print("알림 권한이 허용되었습니다.")
            } else {
                print("알림 권한이 거부되었습니다.")
            }
        }
    }
    
    func scheduleAllHabitNotifications() {
        for habit in habitDataManager.habitDataList where habit.isCompleted == false {
            scheduleNotification(for: habit)
        }
    }
    
    func scheduleNotification(for habit: HabitDataStructure) {
        let content = UNMutableNotificationContent()
        content.title = "까먹지마세요!"
        content.body = "\(habit.name) 할 시간입니다!"
        content.sound = .default
        
        if let date = habit.time.toDate() {
            let triggerDate = Calendar.current.dateComponents([.hour, .minute], from: date)
            let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: true) // 매일 반복
            
            let request = UNNotificationRequest(identifier: habit.id.uuidString, content: content, trigger: trigger)
            UNUserNotificationCenter.current().add(request) { error in
//                if let error = error {
//                    print("알림 등록 실패: \(error.localizedDescription)")
//                } else {
//                    print("알림 등록 성공: \(habit.name) 시간 - \(habit.time)")
//                }
            }
        } else {
            print("날짜 변환 실패: \(habit.time)")
        }
    }

    func cancelNotification(for habit: HabitDataStructure) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [habit.id.uuidString])
        print("알림 취소: \(habit.name)")
    }
    
}



extension MainHomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return habitDataManager.getHabitData().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HabitCell", for: indexPath) as! HabitTableViewCell
        let habit = habitDataManager.getHabitData()[indexPath.row]
        
        cell.habit = habit
        cell.nameLabel.text = habit.name
        cell.identityLabel.text = habit.identity
        cell.timeLabel.text = habit.time
        cell.doWhereLabel.text = habit.doWhere
        cell.rewardLabel.text = "보상 : \(habit.reward)"
        
        cell.updateUI(for: habit)
        cell.delegate = self
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedHabit = habitDataManager.getHabitData()[indexPath.row]
        
        guard let editHabitVC = storyboard?.instantiateViewController(withIdentifier: "EditHabitVC") as? EditHabitViewController else { return }
        
        editHabitVC.habit = selectedHabit
        editHabitVC.delegate = self
        
        present(editHabitVC, animated: true, completion: nil)
    }
    
}



// AddHabitViewController 델리게이트
extension MainHomeViewController: AddHabitViewControllerDelegate {
    // AddHabitViewControllerDelegate 메서드
    func didAddHabit(_ habit: HabitDataStructure) {
        habitDataManager.habitDataList.append(habit) // 새로운 습관 데이터를 배열에 추가
        habitDataManager.saveHabitData() //🍎
        mainTableView.reloadData() // 테이블뷰를 다시 로드하여 업데이트된 데이터를 반영
        updateProgressBar() // progress 업데이트
    }
    
}



// HabitTableViewCell 델리게이트
extension MainHomeViewController: HabitTableViewCellDelegate {
    
    func checkboxToggled(for habit: HabitDataStructure) {
        if let index = habitDataManager.habitDataList.firstIndex(where: { $0.id == habit.id }) {
            habitDataManager.habitDataList[index] = habit
            habitDataManager.saveHabitData() // 상태 변경 시 데이터 저장
            mainTableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
        }
        updateProgressBar()
    }
    
}



// EditHabitViewController 델리게이트
extension MainHomeViewController: EditHabitViewControllerDelegate {
    
    // 수정할 때
    func didUpdateHabit(_ updatedHabit: HabitDataStructure) {
        if let index = habitDataManager.getHabitData().firstIndex(where: { $0.id == updatedHabit.id }) { // UUID로 식별
            habitDataManager.habitDataList[index] = updatedHabit
            habitDataManager.saveHabitData()
            mainTableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
        }
    }
    
    // 삭제할 때
    func didDeleteHabit(_ habit: HabitDataStructure) {
        if let index = habitDataManager.getHabitData().firstIndex(where: { $0.id == habit.id }) {
            habitDataManager.habitDataList.remove(at: index)
            habitDataManager.saveHabitData()
            mainTableView.deleteRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
            updateProgressBar() // 삭제 후 ProgressBar 업데이트
        }
    }
}

