//
//  HomeViewController.swift
//  SolutionApp
//
//  Created by GENKI Mac on 2021/12/11.
//

import UIKit

class HomeViewController: UIViewController {
    
    var selct_id = 0
    var Getlist:[ListItem] = []
    var Listclass = ListModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //用意したJson　デコード処理
        let path = Bundle.main.path(forResource: "LIST_JSON", ofType: "json")
        let url = URL(fileURLWithPath: path!)
        let rawdata = try? Data(contentsOf: url)
        let jsonData = try? JSONDecoder().decode(List.self, from: rawdata!)
        
        if let ListData = jsonData {
            Getlist = ListData.success
        }
    }
    
    @IBAction func airconBtnTap(_ sender: Any) {
        selct_id = 3
        
        guard let listviewController = self.storyboard?.instantiateViewController(withIdentifier:"Lists") as? ListsViewController else { return }
        
        if let Post = Listclass.getListItem(id: selct_id, list: Getlist) {
            
            listviewController.childIDs = Post.children
            listviewController.top_title = Post.title!
            
            self.navigationController?.pushViewController(listviewController,animated: true)
        }
    }
    
    
    @IBAction func watarBtnTap(_ sender: Any) {
        selct_id = 4
        
        guard let listviewController = self.storyboard?.instantiateViewController(withIdentifier:"Lists") as? ListsViewController else { return }
        
        if let Post = Listclass.getListItem(id: selct_id, list: Getlist) {
            
            listviewController.childIDs = Post.children
            listviewController.top_title = Post.title!
            
            self.navigationController?.pushViewController(listviewController,animated: true)
        }
    }
    
    
    @IBAction func pcBtnTap(_ sender: Any) {
        
        selct_id = 5
        
        guard let listviewController = self.storyboard?.instantiateViewController(withIdentifier:"Lists") as? ListsViewController else { return }
        
        if let Post = Listclass.getListItem(id: selct_id, list: Getlist) {
            
            listviewController.childIDs = Post.children
            listviewController.top_title = Post.title!
            
            self.navigationController?.pushViewController(listviewController,animated: true)
        }
    }
    
}
