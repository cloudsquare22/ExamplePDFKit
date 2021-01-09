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
        
        self.createPDFView()
        self.loadDocument(bookurl: Bundle.main.url(forResource: "progit.ja", withExtension: "pdf")!)
    }
    
    func createPDFView() {
        self.pdfView = PDFView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        self.pdfView.backgroundColor = .blue
        self.view.addSubview(self.pdfView)
        
        self.pdfView.translatesAutoresizingMaskIntoConstraints = false
        self.pdfView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        self.pdfView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        self.pdfView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        self.pdfView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
    }
    
    func loadDocument(bookurl: URL) {
        self.pdfView.document = PDFDocument(url: bookurl)
    }
}
