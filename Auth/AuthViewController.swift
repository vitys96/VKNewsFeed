
import UIKit

class AuthViewController: UIViewController {

    private var authService: AuthService! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        authService = AppDelegate.shared().authService
    }
    

    @IBAction func signInButton(_ sender: UIButton) {
        authService.wakeUpSession()
    }

}
