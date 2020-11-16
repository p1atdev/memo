//
//  ViewController.swift
//  SuperMemo
//
//  Created by 周廷叡 on 2020/08/19.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class ViewController: UIViewController, UITextFieldDelegate {
    
    //MARK: outlet
    
    //メール
    @IBOutlet weak var emailTextView: UITextField!
    
    //パスワード
    @IBOutlet weak var passwordTextView: UITextField!
    
    //タイトル
    @IBOutlet weak var titleLabel: UILabel!
    
    var ref: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailTextView.delegate = self
        passwordTextView.delegate = self
        
        //FirebaseApp.configure()
        
        if FirebaseAuth.Auth.auth().currentUser != nil {
            //ログイン済みの時
            //遷移
            self.performSegue(withIdentifier: "toMemos", sender: nil)  //画面遷移
            
            
        } else {
            //ログインしていない時
            
            
        }
        
        ref = Database.database().reference().child("users")
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        //リスナーの削除
        ref.removeAllObservers()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
    }
    
    //遷移の時に値を渡す
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "toMemos" {
            let nextVC = segue.destination as! MemosViewController
            
            print("USER ID")
            print((FirebaseAuth.Auth.auth().currentUser?.uid)!)
            
            nextVC.uid = (FirebaseAuth.Auth.auth().currentUser?.uid)!  //ここで値渡し
        }
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    //アカウント作成
    func createAccount(email: String, password: String){
        
        //これでアカウントのログイン
        FirebaseAuth.Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            
            //guard let strongSelf = self else { return }
            
            print("USER ID")
            print((authResult?.user.uid)!)
            
            self.performSegue(withIdentifier: "toMemos", sender: nil)  //画面遷移
            
        }
        
        
    }
    
    //ログイン
    func loginAuth(email: String, password: String){
        FirebaseAuth.Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
            guard let strongSelf = self else { return }
            
            print(authResult?.user.uid)
            self!.performSegue(withIdentifier: "toMemos", sender: nil)  //画面遷移
            
        }
    }
    
    //TODO: 匿名ログイン
    func anonymousLogin(){
        
        FirebaseAuth.Auth.auth().signInAnonymously() { (authResult, error) in
            
            self.performSegue(withIdentifier: "toMemos", sender: nil)  //画面遷移
            
        }
        
        
    }
    
    //キーボードを閉じれる様に
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // キーボードを閉じる
        textField.resignFirstResponder()
        return true
    }
    
    
    @IBAction func makeAccount(_ sender: Any) {
        
        let email = emailTextView.text
        let password = passwordTextView.text
        
        if email != nil && password != nil{
            
            createAccount(email: email!, password: password!)
            
        }
        
    }
    
    @IBAction func login(_ sender: Any) {
        
        let email = emailTextView.text
        let password = passwordTextView.text
        
        if email != "" && password != ""{
            
            loginAuth(email: email!, password: password!)
            
        }else{
            
            print("ERROR")
            
        }
        
        print("login button")
        
    }
    
    //匿名認証
    @IBAction func skipCreate(_ sender: Any) {
        
        anonymousLogin()
        
    }
    
    
}

