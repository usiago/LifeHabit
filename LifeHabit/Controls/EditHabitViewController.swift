import UIKit

protocol EditHabitViewControllerDelegate: AnyObject {
    func didUpdateHabit(_ habit: HabitDataStructure)
    func didDeleteHabit(_ habit: HabitDataStructure)
}

class EditHabitViewController: UIViewController {
    
    @IBOutlet private weak var habitNameTextField: UITextField!
    
    @IBOutlet private weak var habitIdentityTextField: UITextField!
    
    @IBOutlet private weak var doWhere: UITextField!
    
    @IBOutlet private weak var reward: UITextField!
    
    
    @IBOutlet private weak var alramButton: UIButton!
    
    @IBOutlet private weak var datePicker: UIDatePicker!
    
    @IBOutlet private weak var editButton: UIButton!
    
    @IBOutlet private weak var removeButton: UIButton!
    
    var habit: HabitDataStructure?
    
    weak var delegate: EditHabitViewControllerDelegate?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        setDelegate()
        setTextFieldAddTarget()
        setTextField()
        setKeyboard()
        
        loadHabitData()
        
        // Do any additional setup after loading the view.
    }
    
    
    
    /* ⬇️ 세팅 */
    private func setTextFieldAddTarget() {
        [habitNameTextField, habitIdentityTextField, doWhere, reward].forEach {
            $0.addTarget(self, action: #selector(textFieldsDidChange), for: .editingChanged)
        }
    }
    
    private func setDelegate() {
        [habitNameTextField, habitIdentityTextField, doWhere, reward].forEach {
            $0.delegate = self
        }
    }
    
    private func setUI() {
        view.backgroundColor = .black
        datePickerSetting()
        alramButtonSetting()
        editButtonSetting()
        removeButtonSetting()
        setTextField()
    }
    
    private func setKeyboard() {
        keyboardObserver()
    }
    
    
    private func datePickerSetting() {
        datePicker.overrideUserInterfaceStyle = .dark
    }
    
    private func alramButtonSetting() {
        alramButton.isSelected = true
        alramButton.tintColor = #colorLiteral(red: 1, green: 0.4549019608, blue: 0.03921568627, alpha: 1)
    }
    
    private func editButtonSetting() {
        editButton.layer.borderWidth = 1
        editButton.layer.borderColor = #colorLiteral(red: 1, green: 0.4549019608, blue: 0.03921568627, alpha: 1)
        editButton.backgroundColor = .clear
    }
    
    private func removeButtonSetting() {
        removeButton.layer.borderWidth = 1
        removeButton.layer.borderColor = #colorLiteral(red: 1, green: 0.4549019608, blue: 0.03921568627, alpha: 1)
        removeButton.backgroundColor = .clear
    }
    
    
    private func setTextField() {
        configureTextField(habitNameTextField, placeholder: "5분 명상", returnKeyType: .next)
        configureTextField(habitIdentityTextField, placeholder: "마음을 정리하는 사람", returnKeyType: .next)
        configureTextField(doWhere, placeholder: "집에서 기상 직후", returnKeyType: .next)
        configureTextField(reward, placeholder: "시원한 물 한잔", returnKeyType: .done)
    }
    
    // 키보드 나타날 때 화면 조정
    private func keyboardObserver() {
        // 키보드가 나타날 때 호출되는 메서드 등록
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        // 키보드가 사라질 때 호출되는 메서드 등록
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    // TextField 세팅 함수
    private func configureTextField(_ textField: UITextField, placeholder: String, returnKeyType: UIReturnKeyType) {
        textField.backgroundColor = .darkGray
        textField.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        textField.textColor = .white
        textField.keyboardType = .default
        textField.layer.borderWidth = 2
        textField.layer.borderColor = #colorLiteral(red: 1, green: 0.4549019608, blue: 0.03921568627, alpha: 1)
        textField.returnKeyType = returnKeyType
    }
    
    // 초기값 받아오기 함수
    private func loadHabitData() {
        guard let habit = habit else { return }
        habitNameTextField.text = habit.name
        habitIdentityTextField.text = habit.identity
        doWhere.text = habit.doWhere
        reward.text = habit.reward
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm a" // 시간 포맷 (예: "6:00 AM")
        
        if let date = dateFormatter.date(from: habit.time) {
            datePicker.date = date
        } else {
            print("Invalid time format")
        }
    }
    
    
    
    /* ⬇️ 기능 */
    // 알람 버튼 눌렸을 때
    @IBAction private func alramButtonTapped(_ sender: UIButton) {
        
        if alramButton.isSelected == true{
            // 체크박스가 선택되었을 때 DatePicker 표시
            // 알람 없음으로 변경
            //            datePicker.isHidden = true
            alramButton.setImage(UIImage(systemName: "checkmark.square"), for: .normal)
            alramButton.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        } else {
            // 체크박스가 선택 해제되었을 때 DatePicker 숨기기
            //            datePicker.isHidden = false
            alramButton.setImage(UIImage(systemName: "checkmark.square.fill"), for: .normal)
            alramButton.tintColor = #colorLiteral(red: 1, green: 0.4549019608, blue: 0.03921568627, alpha: 1)
        }
        
        alramButton.isSelected.toggle() // 체크박스 상태 변경
    }
    
    // 수정버튼 클릭
    @IBAction func saveButtonTapped(_ sender: UIButton) {
        guard var habit = habit else { return }

        // 데이터 업데이트
        habit.name = habitNameTextField.text ?? habit.name
        habit.identity = habitIdentityTextField.text ?? habit.identity
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm a"
        habit.time = dateFormatter.string(from: datePicker.date)
        habit.doWhere = doWhere.text ?? habit.doWhere
        habit.reward = reward.text ?? habit.reward

        
        // 🍎 기존 알람 취소
        cancelNotification(for: habit)
        
        // 🍎 새로운 알람 등록
        if alramButton.isSelected {
            scheduleNotification(for: habit)
        }
        
        
        // Delegate를 통해 수정된 habit 전달
        delegate?.didUpdateHabit(habit)
        dismiss(animated: true, completion: nil)
    }
    
    // 삭제버튼 클릭
    @IBAction func removeButtonTapped(_ sender: UIButton) {
        guard let habit = habit else { return }
        
        // 🍎
        cancelNotification(for: habit)
        
        // Delegate를 통해 삭제 알리기
        delegate?.didDeleteHabit(habit)
        
        // 현재 화면 닫기
        dismiss(animated: true, completion: nil)
    }
    
    //텍스트필드가 모두 채워지면 버튼 색상 변경
    private func updateButtonState() {
        // idTextField와 pwTextField가 모두 비어 있지 않다면 버튼의 색깔을 변경
        if let habitNameTextField = habitNameTextField.text, !habitNameTextField.isEmpty,
           let habitIdentityTextField = habitIdentityTextField.text, !habitIdentityTextField.isEmpty,
           let doWhere = doWhere.text, !doWhere.isEmpty,
           let reward = reward.text, !reward.isEmpty {
            editButton.backgroundColor = #colorLiteral(red: 1, green: 0.4549019608, blue: 0.03921568627, alpha: 1) // 원하는 색으로 변경
            editButton.titleLabel?.textColor = .white // 원하는 색으로 변경
            //            createButton.isEnabled = true
        } else {
            editButtonSetting()
        }
    }
    
    // 텍스트필드의 값이 변경될 때 호출되는 메서드 -> updateButtonState
    @objc private func textFieldsDidChange(_ textField: UITextField) {
        updateButtonState()
    }
    
    // 키보드가 나타날 때 화면 조정(addTarget 자동호출함수)
    @objc private func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            // 키보드가 나타날 때 텍스트 필드를 가리지 않도록 뷰를 위로 이동
            if view.frame.origin.y == 0 {
                view.frame.origin.y -= keyboardSize.height / 2
            }
        }
    }
    
    // 키보드가 사라질 때 화면 조정 (addTarget 자동호출함수)
    @objc private func keyboardWillHide(notification: NSNotification) {
        // 키보드가 사라질 때 뷰를 원래 위치로 이동
        if view.frame.origin.y != 0 {
            view.frame.origin.y = 0
        }
    }
    
    // 앱의 화면 터치하면 키보드 내려가게
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    // 옵저버 해제
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // 상단바 알림 설정
    func scheduleNotification(for habit: HabitDataStructure) {
        let content = UNMutableNotificationContent()
        content.title = "까먹지마세요!"
        content.body = "\(habit.name) 할 시간입니다!"
        content.sound = .default
        
        let triggerDate = Calendar.current.dateComponents([.hour, .minute], from: datePicker.date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: true)
        
        let request = UNNotificationRequest(identifier: habit.id.uuidString, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request) { error in
//            if let error = error {
//                print("알림 등록 실패: \(error.localizedDescription)")
//            } else {
//                print("알림 등록 성공: \(habit.name) 시간 - \(habit.time)")
//            }
        }
    }
    
    // 알림 삭제
    func cancelNotification(for habit: HabitDataStructure) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [habit.id.uuidString])
        print("알림 취소: \(habit.name)")
    }
    
}



extension EditHabitViewController: UITextFieldDelegate {
    
    // 리턴키 누르면 다음 텍스트필드로
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == habitNameTextField {
            habitIdentityTextField.becomeFirstResponder() // 키보드 내려지게 FirstResponder 해제
        } else if textField == habitIdentityTextField {
            habitIdentityTextField.resignFirstResponder()
        } else if textField == doWhere {
            reward.becomeFirstResponder()
        } else {
            reward.resignFirstResponder()
            //            self.createButtonTapped(createButton)
        }
        return true
    }
    
}
