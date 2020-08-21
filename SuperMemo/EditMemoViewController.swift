//
//  EditMemoViewController.swift
//  SuperMemo
//
//  Created by 周廷叡 on 2020/08/20.
//

import UIKit
import Firebase
import FirebaseDatabase


class EditMemoViewController: UIViewController {
    
    //変数
    
    //uid
    var uid: String = ""
    
    //メモの内容が入る
    var content: String = ""
    
    //対象のインデックス
    var index: Int = -1
    
    //firebase
    var ref: DatabaseReference!
    
    @IBOutlet weak var memoView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if content != ""{
            
            title = "編集"
            
            memoView.text = content
        }
        
        ref = Database.database().reference().child("users").child(uid)
        
        
    }
    
    @IBAction func save(_ sender: Any) {
        
        if memoView.text != nil{
            
            print(index)
            
            ref.child(String(index)).setValue(memoView.text)
            
            self.navigationController?.popViewController(animated: true)
            
        }
    }
    
}
