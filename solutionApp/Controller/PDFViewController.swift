//
//  PDFViewController.swift
//  SolutionApp
//
//  Created by GENKI Mac on 2021/12/12.
//

import UIKit
import PDFKit

class PDFViewController: UIViewController,UINavigationControllerDelegate,UISearchBarDelegate{
    
    @IBOutlet weak var Seachbar: UISearchBar!
    
    var pdfUrl :String?
    var topTitle :String?
    var DirectoryClass = Directory()
    
    //ページを格納する
    var pageArry:[Int] = []
    var pdfview2 = PDFView()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //タイトル表示
        self.navigationItem.title = topTitle
        
        //デリケート
        navigationController?.delegate = self
        Seachbar.delegate = self
        
        
        //=========================
        // PDF表示　↓
        //========================
        
        let pdfviewDP = PDFView(frame: CGRect(x:0, y:Seachbar.frame.size.height*2, width: view.frame.size.width, height: view.frame.size.height))
        
        if let pdfUrl = pdfUrl {
            
            //PDFをディレクトリーから表示
            let pdfname = DirectoryClass.createPDFName(URLString: pdfUrl)
            let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] + "/pdf/" + pdfname
            let pdfURL = NSURL(fileURLWithPath: documentsPath)
            
            if let document = PDFDocument(url: pdfURL as URL){
                pdfviewDP.document = document
                pdfviewDP.backgroundColor = .lightGray
                pdfviewDP.autoScales = true
                pdfviewDP.displayMode = .singlePageContinuous
                view.addSubview(pdfviewDP)
            }
            //PDFをダウンロードしてない場合、ディレクトリーに保存する。初回はダウンロードして表示
            else {
                //ディレクトリー へ保存処理
                DirectoryClass.savePDFInDir(URLString: pdfUrl)
                
                let url = URL(string: pdfUrl)!
                let data = try! Data(contentsOf: url)
                let document = PDFDocument(data: data)
                pdfviewDP.document = document
                pdfviewDP.backgroundColor = .lightGray
                pdfviewDP.autoScales = true
                pdfviewDP.displayMode = .singlePageContinuous
                view.addSubview(pdfviewDP)
            }
        }
        pdfview2 = pdfviewDP
    }
    
    
    //========================
    // PDF文字検索　↓
    //========================
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar){
        
        //ハイライト消す
        removeAllAnnotations()
        pageArry = []
        
        //キーボード閉じる
        self.Seachbar.endEditing(true)
        
        let text = Seachbar.text
        if !(text == ""){
            find(text: text!)
        }
    }
    
    
    func find(text: String) {
        
        let selections = pdfview2.document?.findString(text, withOptions: .caseInsensitive)
        
        for i in 0..<selections!.count{
            guard let page = selections![i].pages.first else { return }
            
            selections?.forEach { selection in
                let highlight = PDFAnnotation(bounds: selection.bounds(for: page), forType: .highlight, withProperties: nil)
                highlight.endLineStyle = .square
                page.addAnnotation(highlight)
            }
        }
        
        //ハイライトがあるページを格納する
        for i in 0..<pdfview2.document!.pageCount {
            if let page = pdfview2.document!.page(at: i) {
                let annotations = page.annotations
                if annotations.count >= 1{
                    pageArry.append(i)
                }
            }
        }
        
        //検索した文字が無かった場合
        if pageArry.isEmpty{
            let alert = UIAlertController(title: "確認", message: "検索ワードが見つかりませんでした", preferredStyle: .alert)
            //ここから追加
            let ok = UIAlertAction(title: "OK", style: .default)
            alert.addAction(ok)
            //ここまで追加
            present(alert, animated: true, completion: nil)
        }
        print(pageArry)
    }
    
    //seachBarキャンセルボタン
    func searchBar(_ searchBar: UISearchBar,textDidChange searchText: String){
        removeAllAnnotations()
    }
    
    //ハイライトを消す
    func removeAllAnnotations() {
        guard let document = pdfview2.document else { return }
        
        for i in 0..<document.pageCount {
            if let page = document.page(at: i) {
                let annotations = page.annotations
                for annotation in annotations {
                    page.removeAnnotation(annotation)
                }
            }
        }
    }
    
    
    @IBAction func gotopage(_ sender: Any) {
        
        guard let document = pdfview2.document else { return }
        
        //現在のページを取得　Int型
        let curentPage = document.index(for: pdfview2.currentPage!)
  
        for i in 0..<pageArry.count{
            
            //最後のページで次を押したら最初のページ
            if pageArry[pageArry.count-1] == curentPage{
                pdfview2.go(to:pdfview2.document!.page(at:pageArry[0])!)
                break
            }
            
            if pageArry[i] >= curentPage{
                
                if pageArry.count == 1{
                    pdfview2.go(to:pdfview2.document!.page(at:pageArry[i])!)
                    break
                }
                else {
                    pdfview2.go(to:pdfview2.document!.page(at:pageArry[i+1])!)
                    break
                }
            }
        }
    }
    
    
    @IBAction func backtopage(_ sender: Any) {
        
        guard let document = pdfview2.document else { return }
        
        //現在のページを取得　Int型
        let curentPage = document.index(for: pdfview2.currentPage!)
        
        for i in 0..<pageArry.count{
            //最初のページで戻るを押したら最後のページへ
            if pageArry[0] == curentPage{
                
                if pageArry.count == 1{
                    pdfview2.go(to:pdfview2.document!.page(at:pageArry[i])!)
                    break
                }
                else{
                    pdfview2.go(to:pdfview2.document!.page(at:pageArry[pageArry.count-1])!)
                    break
                }
            }
            
            if pageArry[i] <= curentPage{
                pdfview2.go(to:pdfview2.document!.page(at:pageArry[i])!)
                break
            }
        }
    }
}
