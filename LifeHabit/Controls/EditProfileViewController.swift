import UIKit


protocol EditProfileViewControllerDelegate: AnyObject {
    func didUpdateProfile(name: String, age: String, gender: String, profileImage: UIImage?)
}

class EditProfileViewController: UIViewController {
    
    @IBOutlet private weak var editImage: UIImageView!
    
    @IBOutlet private weak var changeImageButton: UIButton!
    
    @IBOutlet private weak var maleButton: UIButton!
    
    @IBOutlet private weak var femaleButton: UIButton!
    
    @IBOutlet private weak var isConfirmedButton: UIButton!
    
    @IBOutlet private weak var cancelButton: UIButton!
    
    @IBOutlet private weak var nameTextField: UITextField!
    
    @IBOutlet private weak var ageTextField: UITextField!
    
    
    weak var delegate: EditProfileViewControllerDelegate?
    
    private var delegateData: ProfileDataStructure?
    
    private var gender: String = "남자"
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        setUI()
        setDelegate()
        setKeyboard()
        setAddTarget()
        // Do any additional setup after loading the view.
    }
    
    
    
    // MARK: - ⬇️ UI Setting
    private func setUI() {
        view.backgroundColor = .black
        
        editImageSetting()
        cancelButtonSetting()
        textFieldSetting()
        isConfirmedButtonSetting()
    }
    
    // 이미지뷰 세팅, 탭 제스쳐 addTarget -> imageViewTapped() 호출
    private func editImageSetting() {
        editImage.image = UIImage(systemName: "person.crop.circle.fill")
        editImage.tintColor = .lightGray
        
        // 뷰가 레이아웃된 후에도 원형 모양을 유지
        editImage.layer.cornerRadius = editImage.frame.size.width / 2
        editImage.layer.masksToBounds = true
        
        editImage.contentMode = .scaleAspectFill
        
        // 이미지뷰에 탭 제스처 추가
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(imageViewTapped))
        editImage.isUserInteractionEnabled = true
        editImage.addGestureRecognizer(tapGesture)
    }
    
    // 이미지뷰가 탭 되었을 때 갤러리 오픈
    @objc func imageViewTapped() {
        changeImageButtonTapped(changeImageButton)
    }
    
    private func cancelButtonSetting() {
        cancelButton.layer.borderWidth = 2
        cancelButton.layer.borderColor = #colorLiteral(red: 1, green: 0.4549019608, blue: 0.03921568627, alpha: 1)
        cancelButton.backgroundColor = .clear
    }
    
    private func textFieldSetting() {
        configureTextField(nameTextField, placeholder: "이름을 입력해주세요", keyboardType: .default, returnKeyType: .next)
        configureTextField(ageTextField, placeholder: "나이를 입력해주세요", keyboardType: .numberPad, returnKeyType: .done)
    }
    
    // TextField 세팅 함수
    private func configureTextField(_ textField: UITextField, placeholder: String, keyboardType: UIKeyboardType, returnKeyType: UIReturnKeyType) {
        textField.backgroundColor = .darkGray
        textField.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        textField.textColor = .white
        textField.keyboardType = keyboardType
        textField.layer.borderWidth = 2
        textField.layer.borderColor = #colorLiteral(red: 1, green: 0.4549019608, blue: 0.03921568627, alpha: 1)
        textField.returnKeyType = returnKeyType
    }
    
    private func isConfirmedButtonSetting() {
        isConfirmedButton.layer.borderWidth = 2
        isConfirmedButton.layer.borderColor = #colorLiteral(red: 1, green: 0.4549019608, blue: 0.03921568627, alpha: 1)
        isConfirmedButton.backgroundColor = .clear
        isConfirmedButton.setTitleColor(#colorLiteral(red: 1, green: 0.4549019608, blue: 0.03921568627, alpha: 1), for: .normal)
    }
    
    
    
    private func setDelegate() {
        [nameTextField, ageTextField].forEach {
            $0.delegate = self
        }
    }
    
    private func setKeyboard() {
        // 키보드 나타날 때 화면 조정
        keyboardObserver()
    }
    
    // addTarget -> textFieldsDidChange() 호출
    private func setAddTarget() {
        nameTextField.addTarget(self, action: #selector(textFieldsDidChange), for: .editingChanged)
        ageTextField.addTarget(self , action: #selector(textFieldsDidChange), for: .editingChanged)
    }
    
    // 텍스트필드의 값이 변경될 때 호출되는 메서드 -> updateButtonState() 호출
    @objc private func textFieldsDidChange(_ textField: UITextField) {
        //     텍스트필드가 모두 채워지면 버튼 색상 변경
        updateButtonState()
    }
    
    // 텍스트필드가 모두 채워지면 버튼 색상 변경
    private func updateButtonState() {
        // idTextField와 pwTextField가 모두 비어 있지 않다면 버튼의 색깔을 변경
        if let nameTextField = nameTextField.text, !nameTextField.isEmpty,
           let ageTextField = ageTextField.text, !ageTextField.isEmpty {
            isConfirmedButton.backgroundColor = #colorLiteral(red: 1, green: 0.4549019608, blue: 0.03921568627, alpha: 1) // 원하는 색으로 변경
            isConfirmedButton.titleLabel?.textColor = .white // 원하는 색으로 변경
            isConfirmedButton.setTitleColor(.white, for: .normal)
            isConfirmedButton.isEnabled = true
        } else {
            isConfirmedButtonSetting()
        }
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
    // 사진 변경 버튼
    @IBAction private func changeImageButtonTapped(_ sender: UIButton) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.allowsEditing = true // 이미지 편집 허용
        present(imagePickerController, animated: true, completion: nil)
    }
    
    // 성별 선택
    @IBAction private func genderButtonTapped(_ sender: UIButton) {
        
        if sender == maleButton {
            maleButton.setImage(UIImage(systemName: "checkmark.circle.fill"), for: .normal)
            femaleButton.setImage(UIImage(systemName: "checkmark.circle"), for: .normal)
            gender = "남자"
        } else if sender == femaleButton {
            maleButton.setImage(UIImage(systemName: "checkmark.circle"), for: .normal)
            femaleButton.setImage(UIImage(systemName: "checkmark.circle.fill"), for: .normal)
            gender = "여자"
        }
    }
    
    // 확인 버튼
    @IBAction private func isConfirmedButtonTapped(_ sender: UIButton) {
        guard let name = nameTextField.text, !name.isEmpty,
              let age = ageTextField.text, !age.isEmpty else {
            
            let alert = UIAlertController(title: "오류", message: "입력해주세요!", preferredStyle: .alert) // .actionSheet 은 아래에 뜨는 얼럿창
            let success = UIAlertAction(title: "확인", style: .default) { action in
            }
            alert.addAction(success)
            // 실제 띄우기
            self.present(alert, animated: true, completion: nil)
            
            return
        }
        
        // Delegate 메서드 호출하여 데이터 전달
        delegate?.didUpdateProfile(name: name, age: age, gender: gender, profileImage: editImage.image)
        dismiss(animated: true, completion: nil)
    }
    
    // 취소 버튼
    @IBAction private func cancelButtonTapped(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
}


// MARK: - ⬇️ extension UIImagePickerControllerDelegate, UINavigationControllerDelegate
extension EditProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // UIImagePickerControllerDelegate 메서드
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        
        if let editedImage = info[.editedImage] as? UIImage {
            // 편집된 이미지가 있다면, 이미지 뷰에 적용
            editImage.image = editedImage
        } else if let originalImage = info[.originalImage] as? UIImage {
            // 원본 이미지가 있다면, 이미지 뷰에 적용
            editImage.image = originalImage
        }
        
        // 이미지뷰를 다시 원형으로
        editImage.layer.cornerRadius = editImage.frame.size.width / 2
        editImage.layer.masksToBounds = true
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}


// MARK: - ⬇️ extension UITextFieldDelegate
extension EditProfileViewController: UITextFieldDelegate {
    // 키보드 리턴키 눌렸을 때 id면 pw로 키보드 전환, pw면 로그인 버튼 눌림
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == nameTextField {
            ageTextField.becomeFirstResponder() // 키보드 내려지게 FirstResponder 해제
        } else if textField == ageTextField {
            ageTextField.resignFirstResponder()
        }
        return true
    }
}
