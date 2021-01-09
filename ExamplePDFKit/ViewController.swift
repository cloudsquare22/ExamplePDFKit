//
//  ViewController.swift
//  ExamplePDFKit
//
//  Created by Shin Inaba on 2021/01/09.
//

import UIKit
import PDFKit

class ViewController: UIViewController {
    
    var pdfView: PDFView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.pdfView = PDFView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        self.pdfView.backgroundColor = .blue
        self.view.addSubview(self.pdfView)
    }


}

