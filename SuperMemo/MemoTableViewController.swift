//
//  MemoTableViewController.swift
//  SuperMemo
//
//  Created by 周廷叡 on 2020/08/20.
//

import UIKit
import Firebase
import FirebaseDatabase

class MemoTableViewController: UITableViewController {
    
    //変数
    //firebase
    var ref: DatabaseReference!
    
    //ユーザーid
    var uid: String!
    
    //メモリスト
    var memoData: Array<String> = []
    
    //タイトルリスト
    var titleData: Array<String> = []
    
    var i = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        print("USER ID")
        print(uid)

        //firebase
        ref = Database.database().reference().child("users")
        
        let _ = ref.child(uid).observe(DataEventType.value, with: { (snapshot) in
            let postDict = snapshot.value as? Array<String> ?? []
            
            //arrayを初期化
            self.memoData = []
            self.titleData = []
            
            for data in postDict {
                
                let content = data.replacingOccurrences(of: "\n", with: "\n")
                print(content)
                
                //メモのデータを取得
                self.memoData.append(content)
                
                //メモのタイトルを取得
                let titleText = content.components(separatedBy: " \n ").first
                
                self.titleData.append(titleText ?? "読み込みエラー")
                
            }
            
            
            //タイトルを逆順に
            self.titleData.reverse()
            
            //もし初めてだったら(何もない時)
            if self.titleData == [] {
                
                self.ref.child(self.uid).child("0").setValue("メモへ、ようこそ \n ~このメモの使い方~ \n メモ一覧の右下にある青いボタンからメモを新規追加することができます。 \n また、すでにあるメモをタップすることでそのメモを確認、編集することができます。")
                
                //postDict = snapshot.value as? [Int : String] ?? [:]
                
                for data in postDict {
                    
                    let content = data.replacingOccurrences(of: "\n", with: "\n")
                    print(content)
                    
                    //メモのデータを取得
                    self.memoData.append(content)
                    
                    //メモのタイトルを取得
                    let titleText = content.components(separatedBy: " \n ").first
                    
                    self.titleData.append(titleText ?? "読み込みエラー")
                    
                }
                
            }
            
            self.tableView.reloadData()
            
        })
        
        print("DATAS")
        print(memoData)
        print(titleData)
        
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        i = 0
        
        tableView.reloadData()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        //リスナーの削除
        //ref.removeAllObservers()
        
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        //セルの数
        
        return titleData.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        //セクションの数
        
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell.init(style: .default, reuseIdentifier: "cell")
        
        cell.textLabel?.text = titleData[i]
        
        print(indexPath.row)
        
        i += 1
        
        return cell
    }
    
    //セルがタップされた
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
        //めもデータのインデックス
        let index: Int = memoData.count - indexPath.row - 1
        
        let content: String = memoData[index]
        
        //遷移する(親ビューの関数実行)
        let parent = self.parent as! MemosViewController
        
        parent.moveToEdit(content, index: index, makeOrEdit: false)
        
        
    }
    
    
    //インデックスを返す
    func wantNumber() -> Int{
        
        return memoData.count
    }
    
    
}
