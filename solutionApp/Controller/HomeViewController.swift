//
//  HomeViewController.swift
//  SolutionApp
//
//  Created by GENKI Mac on 2021/12/11.
//

import UIKit

class HomeViewController: UIViewController {
    
    var selctId = 0
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
    
    @IBAction func tappedAirconBtn(_ sender: Any) {
        selctId = 3
        
        guard let listviewController = self.storyboard?.instantiateViewController(withIdentifier:"Lists") as? ListsViewController else { return }
        
        if let Post = Listclass.getListItem(id: selctId, list: Getlist) {
            
            listviewController.childIDs = Post.children
            listviewController.top_title = Post.title!
            
            self.navigationController?.pushViewController(listviewController,animated: true)
        }
    }
    
    
    @IBAction func tappedWatarBtn(_ sender: Any) {
        selctId = 4
        
        guard let listviewController = self.storyboard?.instantiateViewController(withIdentifier:"Lists") as? ListsViewController else { return }
        
        if let Post = Listclass.getListItem(id: selctId, list: Getlist) {
            
            listviewController.childIDs = Post.children
            listviewController.top_title = Post.title!
            
            self.navigationController?.pushViewController(listviewController,animated: true)
        }
    }
    
    
    @IBAction func tappedPcBtn(_ sender: Any) {
        selctId = 5
        
        guard let listviewController = self.storyboard?.instantiateViewController(withIdentifier:"Lists") as? ListsViewController else { return }
        
        if let Post = Listclass.getListItem(id: selctId, list: Getlist) {
            
            listviewController.childIDs = Post.children
            listviewController.top_title = Post.title!
            
            self.navigationController?.pushViewController(listviewController,animated: true)
        }
    }
    
}
