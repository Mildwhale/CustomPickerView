//
//  UIViewControllerPreview.swift
//  SantaBase
//
//  Created by Riiid_Pilgwon on 2020/01/08.
//  Copyright © 2020 Riiid, Inc. All rights reserved.
//

import UIKit

#if canImport(SwiftUI) && DEBUG
import SwiftUI
public struct UIViewControllerPreview<ViewController: UIViewController>: UIViewControllerRepresentable {
    let viewController: ViewController

    init(_ builder: @escaping () -> ViewController) {
        viewController = builder()
    }
    
    // MARK: - UIViewControllerRepresentable
    public func makeUIViewController(context: Context) -> ViewController {
        viewController
    }

    public func updateUIViewController(_ uiViewController: ViewController, context: UIViewControllerRepresentableContext<UIViewControllerPreview<ViewController>>) {
        return
    }
}
#endif
