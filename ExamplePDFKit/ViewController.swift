//
//  ViewController.swift
//  ExamplePDFKit
//
//  Created by Shin Inaba on 2021/01/09.
//

import UIKit
import PDFKit
import UniformTypeIdentifiers

class ViewController: UIViewController {
    
    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var menuView: UIView!
    @IBOutlet weak var menuIcon: UIButton!
    @IBOutlet weak var menuFile: UIButton!
    
    var pdfView: PDFView!
    var turnPageCount: Int = 1
    var nowPage: Int = 1
    var nowOrientation: UIInterfaceOrientation = .unknown

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.menuView.isHidden = true
        self.menuView.backgroundColor = UIColor.systemGray.withAlphaComponent(0.3)
        
        let notification = NotificationCenter.default
        notification.addObserver(self, selector: #selector(self.orientationDidChangeNotification(_:)), name: UIDevice.orientationDidChangeNotification, object: nil)
    }
    
    @IBAction func tapMenuIcon(_ sender: Any) {
        print(#function)
        self.menuControl()
    }
    
    @IBAction func tapMenuFile(_ sender: Any) {
        let documentPicker = UIDocumentPickerViewController(forOpeningContentTypes: [UTType.pdf])
        documentPicker.delegate = self
        self.present(documentPicker, animated: true, completion: nil)
    }
    
    @objc func orientationDidChangeNotification(_ notification: Notification) {
        print("UIApplication.shared.windows.first?.windowScene?.interfaceOrientation")
        print("isPortrait:\(UIApplication.shared.windows.first!.windowScene!.interfaceOrientation.isPortrait)")
        print("isLandscape:\(UIApplication.shared.windows.first!.windowScene!.interfaceOrientation.isLandscape)")
        print("rawValue:\(UIApplication.shared.windows.first!.windowScene!.interfaceOrientation.rawValue)")
        print("UIDevice.current.orientation")
        print("isPortrait:\(UIDevice.current.orientation.isPortrait)")
        print("isLandscape:\(UIDevice.current.orientation.isLandscape)")
        print("rawValue:\(UIDevice.current.orientation.rawValue)")
        let device = UIDevice.current
        let orientation = UIApplication.shared.windows.first!.windowScene!.interfaceOrientation
        guard self.shouldAutorotate else {
            return
        }
        guard self.nowOrientation != orientation else {
            return
        }
        print("Device orientation:\(device.orientation.description)")
        print("Application orientation:\(orientation.description)")
        guard orientation != .unknown else {
            return
        }
        self.createPDFView(orientation: orientation)
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
        
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(self.swipeDown(sender:)))
        swipeDown.direction = .down
        self.pdfView.addGestureRecognizer(swipeDown)

        let tapPDFView = UITapGestureRecognizer(target: self, action: #selector(self.tapPDFView(sender:)))
        tapPDFView.numberOfTapsRequired = 1
//        pdfView.addGestureRecognizer(tapPDFView)

//        print(pdfView.gestureRecognizers!.count)
//        for gesture in pdfView.gestureRecognizers! {
//            print(gesture)
//        }

    }

    @objc func tapPDFView(sender: UITapGestureRecognizer) {
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
        self.pdfView.scaleFactor = self.pdfView.scaleFactorForSizeToFit
    }

    @objc func swipeDown(sender: UISwipeGestureRecognizer) {
        print(#function)
        self.menuControl()
    }
    
    func menuControl() {
        switch !self.menuView.isHidden {
        case true:
            self.menuView.alpha = 1.0
            UIView.animate(withDuration: 0.5,animations: {
                self.menuView.alpha = 0.0
                self.menuIcon.transform = CGAffineTransform(rotationAngle: CGFloat.pi/180*180)
                },
            completion: { (_) in
                self.menuIcon.transform = CGAffineTransform(rotationAngle: CGFloat.pi/180*0)
                self.menuIcon.setImage(UIImage(systemName: "chevron.down.circle"), for: .normal)
                self.menuView.isHidden.toggle()
            })
        case false:
            self.menuView.alpha = 0.0
            self.menuIcon.transform = CGAffineTransform(rotationAngle: CGFloat.pi/180*359)
            UIView.animate(withDuration: 0.5, animations: {
                self.menuView.isHidden.toggle()
                self.menuView.alpha = 1.0
                self.menuIcon.transform = CGAffineTransform(rotationAngle: CGFloat.pi/180*180)
                },
            completion: { (_) in
                self.menuIcon.transform = CGAffineTransform(rotationAngle: CGFloat.pi/180*0)
                self.menuIcon.setImage(UIImage(systemName: "chevron.up.circle"), for: .normal)
            })
        }
    }

    func createPDFView(orientation: UIInterfaceOrientation) {
        self.clearSunView(view: self.baseView)

        self.pdfView = PDFView(frame: CGRect(x: 0, y: 0, width: self.baseView.frame.width, height: self.baseView.frame.height))
        self.baseView.addSubview(self.pdfView)

        switch orientation {
        case .portrait, .portraitUpsideDown:
            self.pdfView.displayMode = .singlePage
            self.turnPageCount = 1
            self.nowOrientation = orientation
        case .landscapeLeft, .landscapeRight:
            self.pdfView.displayMode = .twoUp
            self.turnPageCount = 2
            self.nowOrientation = orientation
        default:
            break
        }
        self.pdfView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.pdfView.displayDirection = .vertical
        self.pdfView.autoScales = true
        self.pdfView.displaysAsBook = true
        
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
        print(self.nowPage)
        let pdfPage = self.pdfView.document?.page(at: self.nowPage - 1)
        self.pdfView.go(to: pdfPage!)
        print("scaleFactor:\(self.pdfView.scaleFactor)")
        print("scaleFactorForSizeToFit:\(self.pdfView.scaleFactorForSizeToFit)")
//        self.pdfView.scaleFactor = self.pdfView.scaleFactorForSizeToFit
    }

}

extension ViewController: UIDocumentPickerDelegate {
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        if let documentURL = self.pdfView.document?.documentURL {
            documentURL.stopAccessingSecurityScopedResource()
        }
        print(urls)
        let url = urls[0]
        let _ = url.startAccessingSecurityScopedResource()
        self.nowPage = 1
        self.createPDFView(orientation: self.nowOrientation)
        self.loadDocument(bookurl: url)
        self.goPage()
    }
    
}
