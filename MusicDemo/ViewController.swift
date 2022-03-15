//
//  ViewController.swift
//  MusicDemo
//
//  Created by Pv, Unnikrishnan | Unni | IPESD on 2022/02/03.
//

import UIKit
import RealmSwift
import LocalAuthentication
import SwiftUI


class ViewController: UIViewController {

    let realm = try! Realm()
    @IBOutlet weak var usernameTf: UITextField!
    @IBOutlet weak var signInBtn: UIButton!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var userNameSV: UIStackView!
    @IBOutlet weak var faceidSV: UIStackView!
    @IBOutlet weak var btnSignUp: UIButton!
    @IBOutlet weak var faceidIV: UIImageView!
    var radius = 10.0
    var onetime = false
    var currentUser: String = ""
    enum BiometricType {
        case none
        case touch
        case face
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.showHideView()
        usernameTf.layer.cornerRadius = CGFloat(radius)
        passwordTF.layer.cornerRadius = CGFloat(radius)
        signInBtn.layer.cornerRadius = CGFloat(radius)
        usernameTf.text = "upv"
        passwordTF.text = "RoSe!234"
    }
    
    private func showHideView(showUsername: Bool = false){
        if self.read() == true &&  !showUsername{
            biometricType()
            userNameSV.isHidden = true
            faceidSV.isHidden = false
            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(onFaceIdTouch(tapGestureRecognizer:)))
            faceidIV.isUserInteractionEnabled = true
            faceidIV.addGestureRecognizer(tapGestureRecognizer)
        }else{
            userNameSV.isHidden = false
            faceidSV.isHidden = true
        }
    }
    
    @IBAction func login(_ sender: Any) {
        if Connectivity.isConnectedToInternet(){
            if let _ = sender as? UIButton{
                if userNameSV.isHidden{
                    showHideView(showUsername: true)
                    return
                }
            }
            if let userName = usernameTf.text {
                if let passWord = passwordTF.text {
                    currentUser = userName
                    APIManager.getRequestTokenMethod(username: userName, password: passWord, onCompletion: self.onLoginResponse)
                }else{
                    passwordTF.layer.borderWidth = 1.0
                    passwordTF.layer.borderColor = UIColor.systemRed.cgColor
                }
            }else{
                usernameTf.layer.borderWidth = 1.0
                usernameTf.layer.borderColor = UIColor.systemRed.cgColor
            }
        }else{
            showOfflineAlert()
        }
        return
    }
    
    @IBAction func onFaceIdTouch(tapGestureRecognizer: UITapGestureRecognizer) {
        self.faceIdAuth()
    }
    
    @IBAction func signUp(_ sender: Any) {
        if Connectivity.isConnectedToInternet(){
            APIManager.guestSession(onCompletion: self.onGuestsession)
        }else{
            self.showOfflineAlert()
        }
    }
    
    private func onGuestsession(response: Any){
        if let sessionResponse = response as? GuestSession{
            if ifExist() == false {
                let userInfo = UserLoggedIn.create(username: currentUser, requestToken: sessionResponse.guest_session_id,
                                                   expiresAt: sessionResponse.expires_at)
                try! realm.write {
                    realm.add(userInfo)
                }
            }else{
                update(columnName: "expireAt", value: sessionResponse.expires_at)
            }
            //create guest session
            showHomeScreen()
            print(sessionResponse)
        }else if let errorResponse = response as? ErrorResponse{
            let alertController = UIAlertController(title: "Error", message: errorResponse.status_message, preferredStyle: .alert)
               
            // Create OK button
            let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
            }
            alertController.addAction(OKAction)
            self.present(alertController, animated: true, completion:nil)
        }
    }
    
    private func biometricType() -> BiometricType {
        let authContext = LAContext()
        if #available(iOS 11, *) {
            let _ = authContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil)
            switch(authContext.biometryType) {
            case .none:
                return .none
            case .touchID:
                faceidIV.image = UIImage(systemName: "touchid")
                return .touch
            case .faceID:
                return .face
            @unknown default:
                return .none
            }
        } else {
            return authContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil) ? .touch : .none
        }
    }
    
    private func showBiometricAlert(){
        let name = Bundle.main.object(forInfoDictionaryKey: "CFBundleName") as? String ?? ""
        let alertController = UIAlertController(title: name, message: "Do you want to allow '\(name)' to use Biometric login?", preferredStyle: .alert)
           
        // Create OK button
        let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
            self.update(columnName: "faceIDAuth", value: true)
            self.faceIdAuth()
        }
        alertController.addAction(OKAction)

        // Create Cancel button
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action:UIAlertAction!) in
            self.showHomeScreen()
        }
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion:nil)
    }
    
    private func showOfflineAlert(){
        let alertController = UIAlertController(title: "Offline", message: "Do you want to continue use app in offline mode?", preferredStyle: .alert)
           
        // Create OK button
        let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
            self.showHomeScreen()
        }
        alertController.addAction(OKAction)

        // Create Cancel button
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action:UIAlertAction!) in
            exit(0)
        }
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion:nil)
    }
    
    private func faceIdAuth(){
        let context = LAContext()
        let reason = "Please autherize with biometric"
        context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics,
                               localizedReason: reason) { [weak self] success, error in
            DispatchQueue.main.async {
                guard success, error == nil else {
                    print("error", error ?? "Unknown error")
                    return
                }
                //other screen: success
                self?.login(self)
            }
        }
    }
    
    func showHomeScreen(){
        if let window = UIApplication.shared.windows.first {
                window.rootViewController = UIHostingController(rootView: HomeScreenView())
                window.makeKeyAndVisible()
        }
    }
    
    func onLoginResponse(response: Any){
        if let userAuth = response as? UserAuth{
            print(biometricType())
            if (biometricType() != .none) && !getFaceIdAuth(){
                showBiometricAlert()
            }
            if ifExist() == false {
                let userInfo = UserLoggedIn.create(username: currentUser, requestToken: userAuth.request_token, expiresAt: userAuth.expires_at)
                try! realm.write {
                    realm.add(userInfo)
                }
            }else{
                update(columnName: "expireAt", value: userAuth.expires_at)
                showHomeScreen()
            }
        }else if let errorResponse = response as? ErrorResponse{
            print("Unable to auth user")
            let alertController = UIAlertController(title: "Error", message: errorResponse.status_message, preferredStyle: .alert)
               
            // Create OK button
            let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
            }
            alertController.addAction(OKAction)
            self.present(alertController, animated: true, completion:nil)
        }
    }
    
    private func read() -> Bool {
        let data = realm.objects(UserLoggedIn.self)
        if let userdata = data.first {
            print(userdata)
            return userdata.faceIDAuth
        }
        return false
    }
    
    private func update(columnName: String, value: Any) {
        // Update data
        if let userInfo = realm.objects(UserLoggedIn.self).filter("userName  == '\(String(describing: currentUser))'").first {
            try! realm.write {
                switch columnName{
                case "expireAt":
                    print("updating expiration time")
                    userInfo.expireAt = value as? String
                    break;
                case "requestToken":
                    print("updating requestToken time")
                    userInfo.requestToken = value as? String
                    break;
                case "faceIDAuth":
                    print("updating faceIDAuth time")
                    userInfo.faceIDAuth = value as! Bool
                    break;
                default:
                    break;
                }
            }
            print(realm.objects(UserLoggedIn.self).first!)
        }
    }
    
    private func ifExist() -> Bool{
        if realm.objects(UserLoggedIn.self).filter("userName  == '\(String(describing: currentUser))'").first != nil {
            return true
        }
        return false
    }
    
    private func getRequestToken() -> String?{
        let utcDateFormatter =  DateFormatter()
        utcDateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss 'UTC'"
        utcDateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        if let userInfo = realm.objects(UserLoggedIn.self).filter("userName  == '\(String(describing: currentUser))'").first {
            if let expiredAt = utcDateFormatter.date(from: userInfo.expireAt!), Date() <= expiredAt {
                self.login(self)
            }else{
                print("not expired")
            }
        }
        return nil
    }
    
    private func getFaceIdAuth() -> Bool{
        if let userInfo = realm.objects(UserLoggedIn.self).filter("userName  == '\(String(describing: currentUser))'").first {
            return userInfo.faceIDAuth
            }
        return false
    }
    
    private func delete() {
        if let userInfo = realm.objects(UserLoggedIn.self).filter("userName  == '\(String(describing: currentUser))'").first {
            try! realm.write {
                realm.delete(userInfo)
            }
        }
    }
    
    
}

