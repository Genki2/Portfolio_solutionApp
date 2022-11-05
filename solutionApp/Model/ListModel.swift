//
//  ListModel.swift
//  SolutionApp
//
//  Created by GENKI Mac on 2021/12/09.
//

import Foundation

struct List : Codable {
    var success:[ListItem]
    
    init(success:[ListItem]) {
        self.success = success
    }
}

struct ListItem : Codable {
    let id:Int
    var title:String?
    var updated_at:String?
    var children:[ListItem]
    var pdf_url:String?
    var video_url:String?
}

class ListModel {
    
    func getListItem(id:Int, list:[ListItem]) -> ListItem? {
        
        let itemList = list
        let matchingItems = itemList.filter { $0.id == id }
        if matchingItems.count >= 1 {
            //子要素にhitするものがあればそれを返す
            return matchingItems[0]
        }
        else {
            //子要素にhitするものがなかったら更にその子要素を検索
            var matchingItem:ListItem?
            
            for item in itemList {
                //Children がある
                if !item.children.isEmpty {
                    if let match:ListItem = getListItem(id:id, list:item.children){
                        matchingItem = match
                    }
                }
                if matchingItem != nil {break}
            }
            
            if matchingItem != nil {
                return matchingItem!
            }
        }
        return nil
    }
}
