import UIKit

class SettingViewController: UIViewController {
    
    @IBOutlet private weak var accountView: UIView!
    
    @IBOutlet private weak var accountImage: UIImageView!
    
    @IBOutlet private weak var accountName: UILabel!
    
    @IBOutlet private weak var accountAge: UILabel!
    
    @IBOutlet private weak var accountGender: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        setUI()
        loadAndDisplayProfileData()  // 앱 실행 시 프로필 데이터 로드 및 표시
        // Do any additional setup after loading the view.
    }
    
    
    
    /* ⬇️ 세팅 */
    private func setUI() {
        view.backgroundColor = .black
        
        accountViewSetting()
        accountImageSetting()
        accountNameSetting()
        accountAgeSetting()
        accountGenderSetting()
    }
    
    
    private func accountViewSetting() {
        accountView.layer.cornerRadius = 10
        accountView.layer.masksToBounds = true
    }
    
    private func accountImageSetting() {
        accountImage.image = UIImage(systemName: "person.crop.circle.fill")
        accountImage.tintColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        
        // 뷰가 레이아웃된 후에도 원형 모양을 유지
        accountImage.layer.cornerRadius = accountImage.frame.size.width / 2
        accountImage.layer.masksToBounds = true
        
        accountImage.contentMode = .scaleAspectFill
        
    }
    
    private func accountNameSetting() {
        accountName.text = "이름"
        accountName.sizeToFit()
    }
    
    private func accountAgeSetting() {
        accountAge.text = "나이"
        accountAge.font = UIFont.systemFont(ofSize: 16)
        accountAge.sizeToFit()
    }
    
    private func accountGenderSetting() {
        accountGender.text = "성별"
        accountGender.font = UIFont.systemFont(ofSize: 16)
        accountGender.sizeToFit()
    }
    
    
    
    /* ⬇️ 기능 */
    @objc private func imageViewTapped() {
        // 이미지뷰가 탭 되었을 때 갤러리 열기
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.allowsEditing = true // 이미지 편집 허용
        present(imagePickerController, animated: true, completion: nil)
    }
    
    // 프로필 수정 버튼 클릭
    @IBAction private func editProfileButtonTapped(_ sender: Any) {
        let editProfileVC = storyboard?.instantiateViewController(withIdentifier: "EditProfileVC") as? EditProfileViewController
        // 타입 캐스팅 필요(UIViewController 타입으로 반환하기 때문)
        // 귀찮으면 as! 로 캐스팅
        //secondVC.modalPresentationStyle = .fullScreen
        editProfileVC?.delegate = self
        
        if let editProfileVC {
            present(editProfileVC, animated: true)
        }
        
    }
    
    // 로그아웃 버튼 클릭
    @IBAction func logoutButtonTapped(_ sender: UIButton) {
        if let tabBarController = self.tabBarController {
            tabBarController.selectedIndex = 0
        }
        
        let loginVC = storyboard?.instantiateViewController(withIdentifier: "LoginVC") as? LoginViewController
        // 타입 캐스팅 필요(UIViewController 타입으로 반환하기 때문)
        // 귀찮으면 as! 로 캐스팅
        
        if let loginVC {
            loginVC.modalPresentationStyle = .fullScreen
            present(loginVC, animated: true)
        }
        
    }
    
    // 데이터 로드 및 UI 업데이트 함수
    private func loadAndDisplayProfileData() {
        if let profile = loadProfileData() {
            accountName.text = profile.name
            accountAge.text = profile.age + "세"
            accountGender.text = profile.gender
            
            // Data 타입의 이미지를 UIImage로 변환
            if let imageData = profile.profileImage {
                accountImage.image = UIImage(data: imageData)
            }
        }
    }

    // 프로필 데이터를 저장하는 함수
    func saveProfileData(_ profile: ProfileDataStructure) {
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(profile)
            UserDefaults.standard.set(data, forKey: "profileData")
        } catch {
            print("❗️프로필 데이터를 저장하는 데 실패했습니다: \(error.localizedDescription)")
        }
    }

    // 프로필 데이터를 로드하는 함수
    func loadProfileData() -> ProfileDataStructure? {
        if let data = UserDefaults.standard.data(forKey: "profileData") {
            do {
                let decoder = JSONDecoder()
                return try decoder.decode(ProfileDataStructure.self, from: data)
            } catch {
                print("❗️프로필 데이터를 불러오는 데 실패했습니다: \(error.localizedDescription)")
            }
        }
        return nil
    }
    
}



extension SettingViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // UIImagePickerControllerDelegate 메서드
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        
        if let editedImage = info[.editedImage] as? UIImage {
            // 편집된 이미지가 있다면, 이미지 뷰에 적용
            accountImage.image = editedImage
        } else if let originalImage = info[.originalImage] as? UIImage {
            // 원본 이미지가 있다면, 이미지 뷰에 적용
            accountImage.image = originalImage
        }
        
        // 이미지뷰를 다시 원형으로
        accountImage.layer.cornerRadius = accountImage.frame.size.width / 2
        accountImage.layer.masksToBounds = true
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}


extension SettingViewController: EditProfileViewControllerDelegate {
    
    func didUpdateProfile(name: String, age: String, gender: String, profileImage: UIImage?) {
        accountName.text = name
        accountAge.text = age + "세"
        accountGender.text = gender
        
        if let image = profileImage {
            accountImage.image = image
        }

        // 프로필 데이터를 저장 (이미지를 Data로 변환)
        let profileData = ProfileDataStructure(
            name: name,
            age: age,
            gender: gender,
            profileImage: profileImage // UIImage를 ProfileDataStructure 내부에서 Data로 변환
        )
        saveProfileData(profileData)
    }
}
