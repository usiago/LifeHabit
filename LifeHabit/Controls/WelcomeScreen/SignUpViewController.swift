import UIKit


class SignUpViewController: UIViewController {
    
    @IBOutlet private weak var idTextField: UITextField!
    
    @IBOutlet private weak var pwTextField: UITextField!
    
    @IBOutlet private weak var pwCheckTextField: UITextField!
    
    @IBOutlet private weak var signUpButton: UIButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        setDelegate()
        setAddTarget()
        setKeyboard()

        // Do any additional setup after loading the view.
    }
    
    
    // MARK: - ⬇️ UI Setting
    private func setUI() {
        view.backgroundColor = .black
        
        // back 버튼 수정
        navigationController?.navigationBar.tintColor =  #colorLiteral(red: 1, green: 0.4549019608, blue: 0.03921568627, alpha: 1)
        
        textFieldSetting()
        signUpButtonSetting()
    }
    
    // idTextField, pwTextField, pwCheckTextField 세팅
    private func textFieldSetting() {
        configureTextField(idTextField, placeholder: "아이디", returnKeyType: .next)
        configureTextField(pwTextField, placeholder: "비밀번호", returnKeyType: .next)
        configureTextField(pwCheckTextField, placeholder: "비밀번호 확인", returnKeyType: .done)
        pwTextField.isSecureTextEntry = true
        pwCheckTextField.isSecureTextEntry = true
    }
    
    // TextField 세팅
    private func configureTextField(_ textField: UITextField, placeholder: String, returnKeyType: UIReturnKeyType) {
        textField.backgroundColor = .darkGray
        textField.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        textField.textColor = .white
        textField.keyboardType = .default
        textField.layer.borderWidth = 2
        textField.layer.borderColor = #colorLiteral(red: 1, green: 0.4549019608, blue: 0.03921568627, alpha: 1)
        textField.returnKeyType = returnKeyType
    }

    // signUpButton 세팅
    private func signUpButtonSetting() {
//        signUpButton.isEnabled = false
        signUpButton.setTitle("회원가입", for: .normal)
        signUpButton.backgroundColor = .clear
        signUpButton.setTitleColor(.white, for: .normal)
        signUpButton.layer.cornerRadius = 5
        signUpButton.layer.borderWidth = 1
        signUpButton.layer.borderColor = #colorLiteral(red: 1, green: 0.4558857679, blue: 0.04058742523, alpha: 1)
    }

    
    private func setDelegate() {
        [idTextField, pwTextField, pwCheckTextField].forEach {
            $0.delegate = self
        }
    }
    
    // addTarget -> textFieldsDidChange() 호출
    private func setAddTarget() {
        // 텍스트필드에 addTarget 설정
        idTextField.addTarget(self, action: #selector(textFieldsDidChange), for: .editingChanged)
        pwTextField.addTarget(self, action: #selector(textFieldsDidChange), for: .editingChanged)
        pwCheckTextField.addTarget(self, action: #selector(textFieldsDidChange), for: .editingChanged)
    }
    
    // 텍스트필드의 값이 변경될 때 호출되는 메서드 -> updateButtonState() 호출
    @objc private func textFieldsDidChange(_ textField: UITextField) {
        updateButtonState()
    }
    
    // 텍스트필드가 모두 채워지면 버튼 색상 변경
    private func updateButtonState() {
        //         idTextField와 pwTextField가 모두 비어 있지 않다면 버튼의 색깔을 변경
        if let idText = idTextField.text, !idText.isEmpty,
           let pwText = pwTextField.text, !pwText.isEmpty,
           let pwCheckText = pwCheckTextField.text, !pwCheckText.isEmpty,
           pwTextField.text == pwCheckTextField.text {
            signUpButton.backgroundColor = #colorLiteral(red: 1, green: 0.4549019608, blue: 0.03921568627, alpha: 1) // 원하는 색으로 변경
            signUpButton.isEnabled = true
        } else {
            signUpButtonSetting()
        }
    }
    
    private func setKeyboard() {
        keyboardObserver()
    }
    

    // 키보드 유무에 따른 화면 조정 addObserver
    private func keyboardObserver() {
        // 키보드가 나타날 때 호출되는 메서드 등록
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        // 키보드가 사라질 때 호출되는 메서드 등록
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
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

    deinit {
        // 옵저버 해제
        NotificationCenter.default.removeObserver(self)
    }
    
    
    
    // MARK: - ⬇️ Function
    // 회원가입 버튼 클릭
    @IBAction private func signUpButtonTapped(_ sender: UIButton) {
        
        // 회원가입을 성공했을 시
        // + 회원 데이터베이스화
        
        let alert = UIAlertController(title: "회원가입 성공", message: "", preferredStyle: .alert) // .actionSheet 은 아래에 뜨는 얼럿창
        let success = UIAlertAction(title: "로그인", style: .default) { action in
            self.navigationController?.popViewController(animated: true)
            
            
            guard let loginVC = self.storyboard?.instantiateViewController(withIdentifier: "LoginVC") as? LoginViewController else { return }
            // loginVC.data = "데이터전달"
            // 내비게이션 컨트롤러를 통해 화면 전환
            self.navigationController?.pushViewController(loginVC, animated: true)
        }
        alert.addAction(success)
        
        // 실제 띄우기
        self.present(alert, animated: true, completion: nil)
        
    }

}


// MARK: - ⬇️ extension UITextFieldDelegate
extension SignUpViewController: UITextFieldDelegate {
    
    // 키보드 리턴키 눌렸을 때 id면 pw로 키보드 전환, pw면 로그인 버튼 눌림
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == idTextField {
            pwTextField.becomeFirstResponder() // 키보드 내려지게 FirstResponder 해제
        } else if textField == pwTextField {
            pwCheckTextField.becomeFirstResponder()
        } else if textField == pwCheckTextField {
            pwCheckTextField.resignFirstResponder()
            signUpButtonTapped(signUpButton)
        }
        return true
    }

}

