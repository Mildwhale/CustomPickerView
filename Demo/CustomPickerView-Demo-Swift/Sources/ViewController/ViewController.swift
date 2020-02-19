//
//  ViewController.swift
//  CustomPickerSample
//
//  Created by Wayne Kim on 2020/02/19.
//  Copyright © 2020 Wayne Kim. All rights reserved.
//

import UIKit
import CustomPickerView

class ViewController: UIViewController {

    var pickerView = CustomPickerView(axis: .horizontal)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        setupPickerView()
    }
    
    func setupPickerView() {
        view.addSubview(pickerView)
        
        pickerView.backgroundColor = .gray
        pickerView.dataSource = self
        pickerView.delegate = self
        pickerView.translatesAutoresizingMaskIntoConstraints = false
        pickerView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        pickerView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        pickerView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        pickerView.heightAnchor.constraint(equalToConstant: 80.0).isActive = true
    }
}

extension ViewController: CustomPickerViewDelegate, CustomPickerViewDataSource {
    func numberOfItems(in pickerView: CustomPickerView) -> Int {
        return 20
    }
    
    func pickerView(_ pickerView: CustomPickerView, viewForIndex index: Int) -> UIView {
        let view = UIView()
        view.backgroundColor = .systemPink
        return view
    }
    
    func sizeForItem(in pickerView: CustomPickerView) -> CGSize {
        return CGSize(width: 80, height: 80)
    }
    
    func spacingForItem(in pickerView: CustomPickerView) -> CGFloat {
        return 10
    }
}

#if canImport(SwiftUI) && DEBUG
import SwiftUI

private let deviceNames: [String] = [
    "iPhone 11 Pro"
]

@available(iOS 13.0, *)
struct CustomPickerView_Preview: PreviewProvider {
    static var previews: some View {
        ForEach(deviceNames, id: \.self) { deviceName in
            UIViewControllerPreview {
                ViewController()
            }
        }
    }
}
#endif
