import UIKit


class WelcomeController: UIViewController {
    
    @IBOutlet private weak var loginButton: UIButton!
    
    @IBOutlet private weak var signUpButton: UIButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        // Do any additional setup after loading the view.
    }
    
    
    // MARK: - ⬇️ UI Setting
    private func setUI() {
        view.backgroundColor = .black
        
        loginButtonSetting()
        signUpButtonSetting()
    }
    
    private func loginButtonSetting() {
        loginButton.setTitle("로그인", for: .normal)
        loginButton.backgroundColor = #colorLiteral(red: 1, green: 0.4549019608, blue: 0.03921568627, alpha: 1)
        loginButton.tintColor = .white
    }
    
    private func signUpButtonSetting() {
        signUpButton.setTitle("회원가입", for: .normal)
        signUpButton.backgroundColor = .clear
        signUpButton.tintColor = .white
        signUpButton.layer.cornerRadius = 5
        signUpButton.layer.borderWidth = 1
        signUpButton.layer.borderColor = #colorLiteral(red: 1, green: 0.4558857679, blue: 0.04058742523, alpha: 1)
    }
    
    
    
    // MARK: - ⬇️ Function
    // 로그인버튼 클릭 -> 화면 전환 (LoginViewController)
    @IBAction private func loginButtonTapped(_ sender: UIButton) {
        
        guard let loginViewController = storyboard?.instantiateViewController(withIdentifier: "LoginVC") as? LoginViewController else { return }
        
        //secondViewController.data = "데이터전달"
        
        // 내비게이션 컨트롤러를 통해 화면 전환
        self.navigationController?.pushViewController(loginViewController, animated: true)
    }
    
    // 회원가입 버튼 클릭 -> 화면 전환 (SignUpViewController)
    @IBAction private func signUpButtonTapped(_ sender: UIButton) {
        guard let signUpViewController = storyboard?.instantiateViewController(withIdentifier: "SignUpVC") as? SignUpViewController else { return }
        
        //secondViewController.data = "데이터전달"
        
        // 내비게이션 컨트롤러를 통해 화면 전환
        self.navigationController?.pushViewController(signUpViewController, animated: true)
    }
    
}
