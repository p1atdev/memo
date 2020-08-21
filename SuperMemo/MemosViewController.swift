//
//  MemosViewController.swift
//  SuperMemo
//
//  Created by 周廷叡 on 2020/08/20.
//

import UIKit
import Firebase
import FirebaseAuth

class MemosViewController: UIViewController {
    
    //値
    var uid: String = ""
    
    //新規作成モード
    var isMake: Bool = true
    
    //渡す内容
    var content: String = ""
    
    //渡す位置
    var index: Int = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //戻るボタンを非表示
        self.navigationItem.hidesBackButton = true
        
        //title = uid
        
        //値を渡したい処理で以下を実行
        //let tableVC = self.children[0] as! MemoTableViewController
        
        print("USER ID")
        print(uid)
        
    }
    
    
    //遷移で値を渡す
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "tableEmb"{
            
            let tableVC = segue.destination as! MemoTableViewController
            
            tableVC.uid = uid
            
        }else if segue.identifier == "toEditor"{
            
            let editor = segue.destination as! EditMemoViewController
            
            //編集モード
            if isMake == false{
                
                editor.content = self.content
                
            }
            
            editor.index = index
            
            editor.uid = uid
            
        }
        
        
    }
    
    
    //サインアウト
    @IBAction func signout(_ sender: Any) {
        
        let firebaseAuth = FirebaseAuth.Auth.auth()
        do {
            try firebaseAuth.signOut()
            
            dismiss(animated: true, completion: nil)
            
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
        
        self.navigationController?.popViewController(animated: true)
        
    }
    
    //遷移する
    func moveToEdit(_ content: String, index: Int, makeOrEdit isMake: Bool){
        
        //新規作成で移動
        if isMake == true{
           
            
            self.index = index
            
            
            //編集で移動
        }else{
            
            //渡す内容
            self.content = content
            self.index = index
            
            self.isMake = isMake
        }
        
        self.performSegue(withIdentifier: "toEditor", sender: nil)
        
    }
    
    @IBAction func createNewMemo(_ sender: Any) {
        
        let child = self.children[0] as! MemoTableViewController
        
        index = child.wantNumber()
        
        isMake = true
        
        self.performSegue(withIdentifier: "toEditor", sender: nil)
        
    }
    
    
    
}
