//
//  ListsViewController.swift
//  SolutionApp
//
//  Created by GENKI Mac on 2021/12/11.
//

import UIKit

class ListsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource,UINavigationControllerDelegate,UISearchBarDelegate{
    
    //定義
    var selct_id:Int = 0
    var childIDs:[ListItem] = []
    var can_post = Int()
    var top_title = String()
    
    //検索結果
    var searchResult:[ListItem] = []
    //検索初期値
    var serchRecet:[ListItem] = []
    
    
    @IBOutlet weak var tableview: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //検索初期値代入
        serchRecet = childIDs
        
        //delegateの設定
        tableview.delegate = self
        tableview.dataSource = self
        navigationController?.delegate = self
        
        // xib Identifierを設定
        tableview.register(UINib(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: "Cell")
        
        //ナビゲーションバーのタイトル
        self.navigationItem.title = top_title
    }
    
    //===========================
    // Tableview の処理
    // ==========================
    
    // numberOfRowsInSection section　->  cell に表示する項目数 list.count分 表示
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return childIDs.count
    }
    
    // cellForRowAt indexPath -> cell に表示する値の生成
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //cell を xib TableViewCell
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! TableViewCell
        tableview.rowHeight = 75
        cell.name.numberOfLines = 0
        cell.name.text = childIDs[indexPath.row].title
        cell.updata_at.text = "更新日時　" + childIDs[indexPath.row].updated_at!

        return cell
    }
    
    // didSelectRowAt indexPath -> cell を押した時の動き
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // セルの選択を解除
        tableview.deselectRow(at: indexPath, animated: true)
        
        //最下位の高層の ChiLdまでlist表示
        if  !childIDs[indexPath.row].children.isEmpty{
            
            guard let listviewController = self.storyboard?.instantiateViewController(withIdentifier:"Lists") as? ListsViewController else { return }
            
            listviewController.childIDs = childIDs[indexPath.row].children
            listviewController.top_title = childIDs[indexPath.row].title!
            
            //画面遷移
            self.navigationController?.pushViewController(listviewController,animated: true)
        }
        
        //動画がある時_動画ページへ
        if  childIDs[indexPath.row].video_url != nil {
            
            guard let MovieViewController = self.storyboard?.instantiateViewController(withIdentifier:"Movie") as? MovieViewController else { return }
            
            //動画URLを渡す
            MovieViewController.get_video_url = childIDs[indexPath.row].video_url!
            
            //画面遷移
            self.navigationController?.pushViewController(MovieViewController, animated: true)
        }
        
        //最下位までいき　PDFがあればPDF表示
        if  childIDs[indexPath.row].pdf_url != nil {
            
            guard let pdfviewController = self.storyboard?.instantiateViewController(withIdentifier:"PDF") as? PDFViewController else { return }
            
            //PDFURLを渡す
            pdfviewController.pdf_url = childIDs[indexPath.row].pdf_url
            pdfviewController.top_title = childIDs[indexPath.row].title!
            
            //画面遷移
            self.navigationController?.pushViewController(pdfviewController,animated: true)
        }
    }
    

    //===========================
    // 検索機能↓
    // ==========================
    
    //searchBar設置
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let searchBar = UISearchBar()
        //プレースホルダーの文字設定
        searchBar.placeholder = "リスト検索"
        
        //デリゲート先を自分に設定する
        searchBar.delegate = self
        
        //何も入力されていなくてもReturnキーを押せるようにする。
        searchBar.enablesReturnKeyAutomatically = false
        return searchBar
        
    }
    
    //searchBarの幅に合わせる為に必要な処理
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }
    
    // 検索バー編集開始時にキャンセルボタン有効化
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar){
        searchBar.setShowsCancelButton(true, animated: true)
    }
    
    // キャンセルボタンでキャセルボタン非表示
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        searchBar.setShowsCancelButton(false, animated: true)
    }
    
    //検索ボタン押下時の呼び出しメソッド
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        //キーボードを閉じる。
        searchBar.endEditing(true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        //検索結果配列を空にする。
        searchResult.removeAll()
        
        if(searchBar.text == "") {
            //検索文字列が空の場合は初期データを表示する。
            childIDs = serchRecet
        }
        else {
            //検索文字列を含むデータを検索結果配列に追加する。
            for data in serchRecet {
                if (data.title?.contains(searchBar.text!))! {
                    searchResult.append(data)
                }
            }
            //childIDsに入れる
            childIDs = searchResult
        }
        //テーブルを再読み込みする。
        self.tableview.reloadData()
    }
}
