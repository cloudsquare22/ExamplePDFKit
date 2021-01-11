//
//  Extension.swift
//  ExamplePDFKit
//
//  Created by Shin Inaba on 2021/01/10.
//

import Foundation
import UIKit

extension UIDeviceOrientation {
    func toString() -> String {
        var result = ""
        switch self.rawValue {
        case 0:
            result = "unknown"
        case 1:
            result = "portrait"
        case 2:
            result = "portraitUpsideDown"
        case 3:
            result = "landscapeLeft"
        case 4:
            result = "landscapeRight"
        case 5:
            result = "faceUp"
        case 6:
            result = "faceDown "
        default:
            break
        }
        return result
    }
}

extension UIInterfaceOrientation {
    func toString() -> String {
        var result = ""
        switch self.rawValue {
        case 0:
            result = "unknown"
        case 1:
            result = "portrait"
        case 2:
            result = "portraitUpsideDown"
        case 3:
            result = "landscapeLeft"
        case 4:
            result = "landscapeRight"
        default:
            break
        }
        return result
    }
}
