//
//  DirectoriModel.swift
//  SolutionApp
//
//  Created by GENKI Mac on 2021/12/12.
//

import UIKit
import Foundation

class Directory {
    
    //pdfの名前作成
    func createPDFName(URLString: String) -> String {
        let theFileName = (URLString as NSString).lastPathComponent
        return theFileName
    }
    
    //ディレクトリーパスのアドレスの取得
    func getFileInfoListInDir(_ dirName: String) -> [String] {
        let fileManager = FileManager.default
        var files = [String]()
        
        do {
            files = try fileManager.contentsOfDirectory(atPath: dirName)
        }
        catch {
            return files
        }
        return files
    }
    
    //pdf保存
    func savePDF(URLString:String){
        
        let PDFUrl = NSURL(string: URLString)
        let pdfname = (URLString as NSString).lastPathComponent
        
        if let url = PDFUrl {
            
            let PDFData = NSData(contentsOf: url as URL)
            let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
            let directoryName = "pdf"  // 作成するディレクトリ名
            let createPath = documentsPath + "/" + directoryName
            
            do {
                try FileManager.default.createDirectory(atPath: createPath, withIntermediateDirectories: true, attributes: nil)
            }
            catch {
                // Faild to wite folder
            }
            if let data = PDFData {
                data.write(toFile: "\(createPath)/\(pdfname)", atomically: true)
            }
        }
    }
}
