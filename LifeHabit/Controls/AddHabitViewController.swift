import UIKit
import UserNotifications


protocol AddHabitViewControllerDelegate: AnyObject {
    func didAddHabit(_ habit: HabitDataStructure)
}

class AddHabitViewController: UIViewController {
    
    @IBOutlet private weak var habitNameTextField: UITextField!
    
    @IBOutlet private weak var habitIdentityTextField: UITextField!
    
    @IBOutlet private weak var doWhere: UITextField!
    
    @IBOutlet private weak var reward: UITextField!
    
    
    
    @IBOutlet private weak var alramButton: UIButton!
    
    @IBOutlet private weak var datePicker: UIDatePicker!

    @IBOutlet private weak var createButton: UIButton!
    
    weak var delegate: AddHabitViewControllerDelegate?

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        setDelegate()
        setTextFieldAddTarget()
        setTextField()
        setKeyboard()

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
        createButtonSetting()
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
    
    private func createButtonSetting() {
        createButton.setTitle("습관 생성", for: .normal)
        createButton.setTitleColor(.white, for: .normal)
        createButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 22)
        createButton.layer.borderWidth = 1
        createButton.layer.borderColor = #colorLiteral(red: 1, green: 0.4549019608, blue: 0.03921568627, alpha: 1)
        createButton.backgroundColor = .clear
    }
    
    private func setTextField() {
        configureTextField(habitNameTextField, placeholder: "5분 명상", returnKeyType: .next)
        configureTextField(habitIdentityTextField, placeholder: "마음을 정리하는 사람", returnKeyType: .next)
        configureTextField(doWhere, placeholder: "집에서 기상 직후", returnKeyType: .next)
        configureTextField(reward, placeholder: "시원한 물 한잔", returnKeyType: .done)
    }

    // 키보드 나타날 때 화면 조정 옵저버
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
    
    
    
    /* ⬇️ 기능 */
    // 알람 버튼 눌렸을 때
    @IBAction private func alramButtonTapped(_ sender: UIButton) {

        // 알람 끄기
        if alramButton.isSelected == true{
            // 체크박스가 선택되었을 때 DatePicker 표시
            // 알람 없음으로 변경
//            datePicker.isHidden = true
            alramButton.setImage(UIImage(systemName: "checkmark.square"), for: .normal)
            alramButton.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            
            
        } else { // 알람 켜기
            // 체크박스가 선택 해제되었을 때 DatePicker 숨기기
//            datePicker.isHidden = false
            
            alramButton.setImage(UIImage(systemName: "checkmark.square.fill"), for: .normal)
            alramButton.tintColor = #colorLiteral(red: 1, green: 0.4549019608, blue: 0.03921568627, alpha: 1)
        }

        alramButton.isSelected.toggle() // 체크박스 상태 변경
    }
    
    // create 버튼 눌렸을 때
    @IBAction private func createButtonTapped(_ sender: UIButton) {
        // 입력된 데이터를 가져와서 새로운 습관 데이터를 생성
        guard let name = habitNameTextField.text, !name.isEmpty,
              let identity = habitIdentityTextField.text, !identity.isEmpty,
              let whereToDo = doWhere.text, !whereToDo.isEmpty,
              let rewardText = reward.text, !rewardText.isEmpty else {
            return
        }
        
        let newHabit = HabitDataStructure(
            name: name,
            identity: identity,
            time: DateFormatter.localizedString(from: datePicker.date, dateStyle: .none, timeStyle: .short),
            doWhere: whereToDo,
            reward: rewardText,
            startDate: datePicker.date,
            isCompleted: false
        )
        
        // Delegate를 통해 데이터를 전달
        delegate?.didAddHabit(newHabit)

        // 🍎 알람 등록
        if alramButton.isSelected {
            scheduleNotification(for: newHabit)
        }
        
        dismiss(animated: true)
    }

    //텍스트필드가 모두 채워지면 버튼 색상 변경
    private func updateButtonState() {
        // idTextField와 pwTextField가 모두 비어 있지 않다면 버튼의 색깔을 변경
        if let habitNameTextField = habitNameTextField.text, !habitNameTextField.isEmpty,
           let habitIdentityTextField = habitIdentityTextField.text, !habitIdentityTextField.isEmpty,
           let doWhere = doWhere.text, !doWhere.isEmpty,
           let reward = reward.text, !reward.isEmpty {
            createButton.backgroundColor = #colorLiteral(red: 1, green: 0.4549019608, blue: 0.03921568627, alpha: 1) // 원하는 색으로 변경
//            createButton.isEnabled = true
        } else {
            createButtonSetting()
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
    
}




extension AddHabitViewController: UITextFieldDelegate {
    
    // 키보드 리턴키 눌렸을 때 id면 pw로 키보드 전환, pw면 로그인 버튼 눌림
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == habitNameTextField {
            habitIdentityTextField.becomeFirstResponder() // 키보드 내려지게 FirstResponder 해제
        } else if textField == habitIdentityTextField {
            habitIdentityTextField.resignFirstResponder()
        } else if textField == doWhere {
            reward.becomeFirstResponder()
        } else {
            reward.resignFirstResponder()
        }
        return true
    }

}
