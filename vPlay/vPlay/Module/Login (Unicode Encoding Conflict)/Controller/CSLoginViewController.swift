/*
 * CSLoginViewController
 * This Controller displays LoginPage which has social and Normal Login Methods.
 * @category   vplay
 * @package    com.contus.heeroz
 * @version    1.0
 * @author     Contus Team <developers@contus.in>
 * @copyright  Copyright (C) 2017 Contus. All rights reserved.
 */

import UIKit
import ObjectMapper
import FBSDKLoginKit
import FBSDKCoreKit
import GoogleSignIn
import CryptoKit
import FirebaseAuth
import AuthenticationServices
class CSLoginViewController: CSParentViewController, UIGestureRecognizerDelegate {
    // A variable to enter the Email for Signin
    @IBOutlet weak var emailTextfield: UITextField!
    // A variable to scroll the views based on content length
    @IBOutlet weak var doYouHaveAnAccount: UILabel!
    // A Variable to enter the Password for Signin
    @IBOutlet weak var passwordTextfield: UITextField!
    // A variable to get the content size of a scrollview when keyboard appears
    @IBOutlet weak var loginScrollView: UIScrollView!
    // Content view
    @IBOutlet weak var contentView: UIView!
    // Side image view
    @IBOutlet weak var sideImageView: UIImageView!
    // Logo image view
    @IBOutlet weak var logoImageView: UIImageView!
    /// OR View
    @IBOutlet weak var orView: UIView!
    /// Info View
    @IBOutlet weak var infoView: UIView!
    /// Password Image View
    @IBOutlet weak var passwordImageView: UIImageView!
    /// The passsowrd icon Outlet
    @IBOutlet weak var passwordIconViewOutlet: UIImageView!
    /// The passsowrd icon Outlet
    @IBOutlet var separatorView: [UIView]!
    /// Apple login View
    @IBOutlet weak var appleLoginView: UIView!
    /// Login parameters
    var loginParameterType = String()
    /// check view is present or dismissed
    var googleCurrentlyLoginIn = false
    /// The passsowrd visible boolean
    var isPasswordVisible: Bool = false
    /// isFromVideoDetail Page
    var isFromVideoDetail: Bool = false
    // Unhashed nonce.
    fileprivate var currentNonce: String?
    var parameters: [String: String]!
    // MARK: - Viewcontroller life cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.registerKeyboardNotifications()
        // for google plus sigin
        Profile.enableUpdatesOnAccessTokenChange(true)
        //SetNotification Status
        addGradientBackGround()
        setDarkModeNeeds()
        readLess()
        controllerTitle = NSLocalizedString("Sign In", comment: "Menu")
        addLeftBarButton()
        setAppleSignIn()
        let tapgesture = UITapGestureRecognizer(
            target: self, action: #selector(CSLoginViewController.handleTap(sender:)))
        tapgesture.delegate = self
        self.view.addGestureRecognizer(tapgesture)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        self.passwordTextfield.text = ""
        self.emailTextfield.text = ""
        self.view.endEditing(true)
        if segue.destination is CSSignupViewController {
            let controller = segue.destination as? CSSignupViewController
            controller?.delegate = self
        }
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    /// It shows or hides apple sign in based on apple sign in
    func setAppleSignIn() {
        if #available(iOS 13, *) {
            self.appleLoginView.isHidden = false
        } else {
            self.appleLoginView.isHidden = true
        }
    }
}
extension CSLoginViewController: UITextFieldDelegate {
    // MARK: - Textfield delegates and notification Methods
    func registerKeyboardNotifications() {
        NotificationCenter.default.addObserver(
            self, selector: #selector(CSLoginViewController.keyboardDidShow(notification:)),
            name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(
            self, selector: #selector(CSLoginViewController.keyboardWillHide(notification:)),
            name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    /// Scrollview's ContentInset Change on Keyboard show
    @objc func keyboardDidShow(notification: NSNotification) {
        let userInfo: NSDictionary = notification.userInfo! as NSDictionary
        let keyboardInfo = userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue
        let keyboardSize = keyboardInfo?.cgRectValue.size
        let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: (keyboardSize?.height)!, right: 0)
        loginScrollView.contentInset = contentInsets
        loginScrollView.scrollIndicatorInsets = contentInsets
    }
    /// Scrollview's ContentInset Change on Keyboard hide
    @objc func keyboardWillHide(notification: NSNotification) {
        loginScrollView.contentInset = UIEdgeInsets.zero
        loginScrollView.scrollIndicatorInsets = UIEdgeInsets.zero
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // called when 'return' key pressed. return NO to ignore.
        if textField == emailTextfield {
            self.passwordTextfield.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return true
    }
    // Set Dark Mode
    func setDarkModeNeeds() {
        logoImageView.setLogo()
        separatorView.forEach({ $0.backgroundColor = .separatorColor })
        passwordIconViewOutlet.tintColor = .contactUsIcon
        setColorByView(contentView)
        setColorByView(orView)
        setColorByView(infoView)
    }
    /// Set Color By View
    func setColorByView(_ someView: UIView) {
        for current in someView.subviews {
            if current.tag == 100 {
                let currentText = current as? UITextField
                currentText?.textColor = .textFieldTextColor
                currentText?.placeHolderColor = UIColor.disabledTextFieldTextColor
            } else if current.tag == 105 {
                let currentLabel = current as? UILabel
                currentLabel?.textColor = .labelTextColor
            }
        }
    }
}
// MARK: - Button Action
extension CSLoginViewController {
    /// this method is called when a tap is recognized
    /// Parameter:- Tap gesture
    @objc func handleTap(sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    // MARK: - Button Actions
    @IBAction func signinAction(_ sender: Any) {
        // end editing
        self.view.endEditing(true)
        ///validate Creditiant
        validatetheUserCreditiant()
    }
    /// - Parameter sender: The button object
    @IBAction func passwordViewAction(_ sender: Any) {
        if !isPasswordVisible {
            passwordIconViewOutlet.image = #imageLiteral(resourceName: "passwordViewIcon")
        } else {
            passwordIconViewOutlet.image  = #imageLiteral(resourceName: "PasswordHideIcon")
        }
        passwordTextfield.togglePasswordVisibility()
        isPasswordVisible = !isPasswordVisible
    }
    /// Method Sigin in with Face book button action
    @IBAction func signInWithFacebook(_ sender: Any) {
        self.passwordTextfield.text = ""
        self.emailTextfield.text = ""
        self.view.endEditing(true)
        let fbLoginManager: LoginManager = LoginManager()
        fbLoginManager.logIn(permissions: ["email"], from: self) { (result, error) -> Void in
            if error == nil {
                let fbloginresult: LoginManagerLoginResult = result!
                if fbloginresult.isCancelled { return }
                if fbloginresult.grantedPermissions.contains("email") {
                    ///  Adding Loader
                    self.startLoading()
                    /// getting user data from login
                    self.getFBUserData()
                } else {
                    self.showToastMessageTop(message: NSLocalizedString("Update a email id",
                                                                        comment: "Email"))
                }
            } else {
                self.showToastMessageTop(message: error?.localizedDescription)
            }
        }
    }
    ///   Method Sigin in with Google plus button action
    @IBAction func signInWithGooglePlus(_ sender: Any) {
        self.passwordTextfield.text = ""
        self.emailTextfield.text = ""
        self.view.endEditing(true)
        GIDSignIn.sharedInstance().presentingViewController = self
        GIDSignIn.sharedInstance().clientID = LibraryAPI.sharedInstance.googleClientId()
        GIDSignIn.sharedInstance().signIn()
        googleCurrentlyLoginIn = false
    }
    ///   Method Sigin in with Apple Signin button action
    @IBAction func signInWithAppleSignIn(_ sender: Any) {
        self.passwordTextfield.text = ""
        self.emailTextfield.text = ""
        self.loginParameterType = "fb"
        self.view.endEditing(true)
        if #available(iOS 13.0, *) {
            startSignInWithAppleFlow()
        } else {
            // Fallback on earlier versions
        }
    }
    /// Read More Read Less Button Action
    @IBAction func tapLabel(gesture: UITapGestureRecognizer) {
        let text = (doYouHaveAnAccount.text)!
        let signUp = (text as NSString).range(of: NSLocalizedString("Sign Up", comment: "Login"))
        if gesture.didTapAttributedTextInLabel(label: doYouHaveAnAccount, inRange: signUp) {
            self.performSegue(withIdentifier: "signUp", sender: "")
        }
    }
}
// MARK: - Private Method
extension CSLoginViewController {
    /// Method name validatetheUserCreditiant = validate the User credentials
    func validatetheUserCreditiant() {
        if !CSUserValidation.validateEmail(textField: emailTextfield,
                                           viewController: self) { return }
        if !CSUserValidation.validatePassword(textField: passwordTextfield,
                                              viewController: self) {return}
        loginParameterType = "normal"
        /// call api
        self.siginInfuction(email: emailTextfield.text!,
                            password: passwordTextfield.text!.trim())
    }
    /// Facebook logout delegate method for getting user details
    func loginButtonDidLogOut(_ loginButton: FBLoginButton!) {
    }
    // MARK: - Google Plus delegates Method
    /// google plus delegate method for getting user details
    func sign(inWillDispatch signIn: GIDSignIn!, error: Error!) {
        //myActivityIndicator.stopAnimating()
    }
    /// Present a view that prompts the user to sign in with Google
    func sign(_ signIn: GIDSignIn!,
              present viewController: UIViewController!) {
        self.present(viewController, animated: true, completion: nil)
    }
    // Dismiss the "Sign in with Google" view
    func sign(_ signIn: GIDSignIn!,
              dismiss viewController: UIViewController!) {
        self.dismiss(animated: true, completion: nil)
    }
    ///google sign in responce data
    ///
    /// - Parameter credential: get the credential for google
    func googleLogin(_ credential: GIDGoogleUser) {
        self.loginParameterType = "google+"
        if !CSUserValidation.validateTextEmail(emailText: credential.profile.email,
                                               viewController: self) { return }
        self.socialLoginInfuction(
            email: credential.profile.email, userName: credential.profile.name,
            profilePicture: credential.profile.imageURL(withDimension: 128 * 128).absoluteString,
            socialLoginId: credential.userID, tokenSocial: credential.authentication.idToken)
        GIDSignIn.sharedInstance().signOut()
    }
    // MARK: - Facebook responce data
    func getFBUserData() {
        let fbLoginManager: LoginManager = LoginManager()
        GraphRequest.init(
            graphPath: "me",
            parameters: ["fields": "first_name,email, last_name, picture.type(large)"])
            .start { ( _, result, error) -> Void in
                if error != nil {
                    // Process error
                    self.stopLoading()
                    self.showToastMessageTop(message: error?.localizedDescription)
                } else {
                    let response = (result as? NSDictionary)!
                    let contentinMutDict: NSMutableDictionary = NSMutableDictionary(dictionary: response)
                    guard let userName = contentinMutDict.value(forKey: "first_name") as? String,
                        let userEmail = contentinMutDict.value(forKey: "email") as? String,
                        let userID: String = contentinMutDict.value(forKey: "id") as? String else {
                            self.stopLoading()
                            self.showToastMessageTop(message:
                                NSLocalizedString("Please update an email in your facebook account",
                                                  comment: "Email"))
                            return
                    }
                    var image = String()
                    if let imageURL = ((contentinMutDict.value(forKey: "picture") as
                        AnyObject).value(forKey: "data") as AnyObject).value(forKey: "url") as? String {
                        image = imageURL
                    }
                    self.loginParameterType = "fb"
                    let accessToken = AccessToken.current
                    let token = accessToken?.tokenString
                    self.socialLoginInfuction(email: userEmail, userName: userName,
                                              profilePicture: image, socialLoginId: userID,
                                              tokenSocial: token!)
                    fbLoginManager.logOut()
                }
        }
    }
    /// Completion Handler For Both Social And Normal Login
    func completionHandlerForLogin(_ userData: ResponseData) {
        LibraryAPI.sharedInstance.setUserDefaults(key: "planName", value: userData.subscription.planName)
        LibraryAPI.sharedInstance.setUserDefaults(key: "EmailID", value: userData.userEmail)
        LibraryAPI.sharedInstance.setUserDefaults(key: "PhoneNumber", value: userData.userPhone)
        LibraryAPI.sharedInstance.setUserDefaults(key: "Name", value: userData.userName)
        LibraryAPI.sharedInstance.setUserDefaults(key: "imageUrl", value: userData.profilePicture)
        LibraryAPI.sharedInstance.setUserDefaults(key: "Token", value: userData.accessToken)
        LibraryAPI.sharedInstance.setUserDefaults(key: "UserID", value: String(userData.userId))
        LibraryAPI.sharedInstance.setUserDefaults(key: "notificationCount", value: "0")
        LibraryAPI.sharedInstance.setUserDefaults(key: "dateOfBirth", value: userData.userDob)
        LibraryAPI.sharedInstance.setUserDefaults(key: "videoId", value: "0")
        LibraryAPI.sharedInstance.setUserDefaults(key: "videoDuration", value: "0")
        LibraryAPI.sharedInstance.setUserBoolDefaults(key: "AutoPlayStatus", value: true)
        LibraryAPI.sharedInstance.setUserBoolDefaults(key: "Notificationstatus", value: true)
        LibraryAPI.sharedInstance.setUserDefaults(key: "isSubscribed", value: String(userData.isUserSubscribed))
        setUserInfoForCrashAnalystics()
        let count = (self.navigationController?.viewControllers.count ?? 0) - 2
        if isFromVideoDetail && !LibraryAPI.sharedInstance.isUserSubscibed() {
            let login = subscriptionStoryBoard.instantiateViewController(withIdentifier:
                "CSSubscriptionViewController")
            self.navigationController?.pushViewController(login, animated: true)
            return
        }
        if let controller = self.navigationController?.viewControllers[count],
            controller is CSParentViewController {
            let previousController = controller as? CSParentViewController
            previousController?.callApi()
        }
        self.navigationController?.popViewController(animated: true)
    }
    /// Set Data of User on crash
    func setUserInfoForCrashAnalystics() {
        // Crashlytics.sharedInstance().setUserEmail(LibraryAPI.sharedInstance.getUserEmailId())
        // Crashlytics.sharedInstance().setUserName(LibraryAPI.sharedInstance.getUserName())
        // Crashlytics.sharedInstance().setUserIdentifier(LibraryAPI.sharedInstance.getUserId())
    }
}
// MARK: - Delegate
extension CSLoginViewController: CSLoginDelegate {
    func loginIsDone(_ viewController: UIViewController) {
        let count = (self.navigationController?.viewControllers.count ?? 0) - 2
        if let controller = self.navigationController?.viewControllers[count],
            controller is CSParentViewController {
            let previousController = controller as? CSParentViewController
            previousController?.callApi()
            viewController.navigationController?.popToViewController(previousController!, animated: true)
        } else {
            UIApplication.setRootControllerBasedOnLogin()
        }
    }
}
// MARK: - API CAll Methods
extension CSLoginViewController {
    /// Normal Login Api Call
    func siginInfuction(email: String, password: String) {
        /// parameter set
        let paramet: [String: String] = [
            "email": email, "password": password, "acesstype": "mobile",
            "login_type": self.loginParameterType, "token": "", "social_user_id": "",
            "device_type": "IOS", "name": "", "profile_picture": "",
            "device_token": LibraryAPI.sharedInstance.getDeviceToken()]
        CSLoginApiModel.loginRequest(parentView: self,
                                     parameters: paramet,
                                     completionHandler: { user in
                                        LibraryAPI.sharedInstance.setUserBoolDefaults(key: "SocialLogin", value: false)
                                        self.completionHandlerForLogin(user.responseRequired)
        })
    }
    /// Social Login Api Call
    func socialLoginInfuction(email: String, userName: String,
                              profilePicture: String, socialLoginId: String, tokenSocial: String) {
        /// parameter set
        let paramet: [String: String] = [
            "email": email, "password": "", "acesstype": "mobile", "device_type": "IOS",
            "login_type": self.loginParameterType, "social_user_id": socialLoginId, "name": userName,
            "profile_picture": profilePicture, "token": tokenSocial,
            "device_token": LibraryAPI.sharedInstance.getDeviceToken()
        ]
        CSLoginApiModel.loginRequest(parentView: self,
                                     parameters: paramet,
                                     completionHandler: { user in
                                        LibraryAPI.sharedInstance.setUserBoolDefaults(key: "SocialLogin", value: true)
                                        self.completionHandlerForLogin(user.responseRequired)
        })
    }
    // Adapted from https://auth0.com/docs/api-auth/tutorials/nonce#generate-a-cryptographically-random-nonce
    private func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        let charset: Array<Character> =
            Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        var result = ""
        var remainingLength = length
        
        while remainingLength > 0 {
            let randoms: [UInt8] = (0 ..< 16).map { _ in
                var random: UInt8 = 0
                let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
                if errorCode != errSecSuccess {
                    fatalError("Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)")
                }
                return random
            }
            
            randoms.forEach { random in
                if remainingLength == 0 {
                    return
                }
                
                if random < charset.count {
                    result.append(charset[Int(random)])
                    remainingLength -= 1
                }
            }
        }
        
        return result
    }

    @available(iOS 13, *)
    func startSignInWithAppleFlow() {
      let nonce = randomNonceString()
      currentNonce = nonce
      let appleIDProvider = ASAuthorizationAppleIDProvider()
      let request = appleIDProvider.createRequest()
      request.requestedScopes = [.fullName, .email]
      request.nonce = sha256(nonce)

      let authorizationController = ASAuthorizationController(authorizationRequests: [request])
      authorizationController.delegate = self
      authorizationController.presentationContextProvider = self
      authorizationController.performRequests()
    }

    @available(iOS 13, *)
    private func sha256(_ input: String) -> String {
      let inputData = Data(input.utf8)
      let hashedData = SHA256.hash(data: inputData)
      let hashString = hashedData.compactMap {
        return String(format: "%02x", $0)
      }.joined()

      return hashString
    }
}
@available(iOS 13.0, *)
extension CSLoginViewController: ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
      if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
        if appleIDCredential.email != nil {
           LibraryAPI.sharedInstance.setUserDefaults(key: "appleID", value: appleIDCredential.email ?? "")
         }
        guard let nonce = currentNonce else {
          fatalError("Invalid state: A login callback was received, but no login request was sent.")
        }
        guard let appleIDToken = appleIDCredential.identityToken else {
          print("Unable to fetch identity token")
          return
        }
        guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
          print("Unable to serialize token string from data: \(appleIDToken.debugDescription)")
          return
        }
        // Initialize a Firebase credential.
        let credential = OAuthProvider.credential(withProviderID: "apple.com",
                                                  idToken: idTokenString,
                                                  rawNonce: nonce)
        // Sign in with Firebase.
        Auth.auth().signIn(with: credential) { (authResult, error) in
            if (error == nil) {
                if Auth.auth().currentUser?.displayName != nil {
                    self.parameters = ["email": (authResult?.user.email ?? LibraryAPI.sharedInstance.getAppleID()) as String,
                                       "password": "", "acesstype": "mobile", "device_type": "IOS",
                                       "login_type": self.loginParameterType,
                                       "social_user_id": (authResult?.user.uid ?? appleIDCredential.user) as String,
                                       "name": (Auth.auth().currentUser?.displayName ?? "Heeroz-user") as String,
                                       "profile_picture": "",
                                       "token": (authResult?.user.refreshToken ?? idTokenString) as String,
                                       "device_token": LibraryAPI.sharedInstance.getDeviceToken()
                    ]
                } else {
                    self.parameters = ["email": (authResult?.user.email ?? LibraryAPI.sharedInstance.getAppleID()) as String,
                                       "password": "", "acesstype": "mobile", "device_type": "IOS",
                                       "login_type": self.loginParameterType,
                                       "social_user_id": (authResult?.user.uid ?? appleIDCredential.user) as String,
                                       "name": "Heeroz-user",
                                       "profile_picture": "",
                                       "token": (authResult?.user.refreshToken ?? idTokenString) as String,
                                       "device_token": LibraryAPI.sharedInstance.getDeviceToken()
                    ]
                }
                CSLoginApiModel.loginRequest(parentView: self,
                                             parameters: self.parameters,
                                             completionHandler: { user in
                                                LibraryAPI.sharedInstance.setUserBoolDefaults(key: "SocialLogin", value: true)
                                                self.completionHandlerForLogin(user.responseRequired)
                })
                return
          }
          // User is signed in to Firebase with Apple.
          // ...
        }
      }
    }

    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
      // Handle error.
      print("Sign in with Apple errored: \(error)")
    }
    
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        self.view.window!
    }
}

extension CSLoginViewController {
    /// Read Less text
    func readLess() {
        let textData =
            NSLocalizedString("Don't have an account? Please ", comment: "Login") +
                NSLocalizedString("Sign Up", comment: "Login")
        doYouHaveAnAccount.attributedText =
            textData.attributeTextProperty(appendtext: NSLocalizedString("Sign Up", comment: "Login"),
                                           color: .readMoreReadLessColor(), font: UIFont.fontBold())
        doYouHaveAnAccount.textAlignment = .center
    }
}
