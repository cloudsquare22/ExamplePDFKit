//
//  ViewController.swift
//  ExamplePDFKit
//
//  Created by Shin Inaba on 2021/01/09.
//

import UIKit
import PDFKit

class ViewController: UIViewController {
    
    @IBOutlet weak var baseView: UIView!

    var pdfView: PDFView!
    var turnPageCount: Int = 1
    var nowPage: Int = 1

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let notification = NotificationCenter.default
        notification.addObserver(self, selector: #selector(self.orientationDidChangeNotification(_:)), name: UIDevice.orientationDidChangeNotification, object: nil)
    }
    
    @objc func orientationDidChangeNotification(_ notification: Notification) {
        guard self.shouldAutorotate else {
            return
        }
        let device = UIDevice.current
        print("Device orientation:\(device.orientation.toString())")
        self.createPDFView(orientation: device.orientation)
        self.loadDocument(bookurl: Bundle.main.url(forResource: "progit.ja", withExtension: "pdf")!)
        self.goPage()
    }
    
    func addGesture() {
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(self.turnPage(sender:)))
        swipeLeft.direction = .left
        self.pdfView.addGestureRecognizer(swipeLeft)

        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.turnPage(sender:)))
        swipeRight.direction = .right
        self.pdfView.addGestureRecognizer(swipeRight)
    }

    @objc func turnPage(sender: UISwipeGestureRecognizer) {
        let direction = sender.direction
        switch direction {
        case .left:
            if let page = self.pdfView.currentPage?.pageRef?.pageNumber {
                self.nowPage = page + self.turnPageCount
                if self.nowPage > self.pdfView.document!.pageCount {
                    self.nowPage = self.pdfView.document!.pageCount
                }
            }
        case .right:
            if let page = self.pdfView.currentPage?.pageRef?.pageNumber {
                self.nowPage = page - self.turnPageCount
                if self.nowPage < 1 {
                    self.nowPage = 1
                }
            }
        default:
            break
        }
        self.goPage()
    }

    func createPDFView(orientation: UIDeviceOrientation) {
        guard orientation != .faceUp && orientation != .faceDown && orientation != .unknown else {
            return
        }
        self.clearSunView(view: self.baseView)

        self.pdfView = PDFView(frame: CGRect(x: 0, y: 0, width: self.baseView.frame.width, height: self.baseView.frame.height))
        self.baseView.addSubview(self.pdfView)

        switch orientation {
        case .portrait, .portraitUpsideDown:
            self.pdfView.displayMode = .singlePage
            self.turnPageCount = 1
        case .landscapeLeft, .landscapeRight:
            self.pdfView.displayMode = .twoUp
            self.turnPageCount = 2
        default:
            break
        }
        self.pdfView.autoScales = true
        
        self.addConstraintPDFView()
        self.addGesture()
    }
    
    func loadDocument(bookurl: URL) {
        self.pdfView.document = PDFDocument(url: bookurl)
    }
    
    func clearSunView(view: UIView) {
        for subview in view.subviews {
            subview.removeFromSuperview()
        }
    }
    
    func addConstraintPDFView() {
        self.pdfView.translatesAutoresizingMaskIntoConstraints = false
        self.pdfView.topAnchor.constraint(equalTo: self.baseView.topAnchor).isActive = true
        self.pdfView.bottomAnchor.constraint(equalTo: self.baseView.bottomAnchor).isActive = true
        self.pdfView.leadingAnchor.constraint(equalTo: self.baseView.leadingAnchor).isActive = true
        self.pdfView.trailingAnchor.constraint(equalTo: self.baseView.trailingAnchor).isActive = true
    }
    
    func goPage() {
        let pdfPage = self.pdfView.document?.page(at: self.nowPage - 1)
        self.pdfView.go(to: pdfPage!)
    }

}
