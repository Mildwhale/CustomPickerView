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

    var pickerView = CustomPickerView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        setupPickerView()
    }
    
    func setupPickerView() {
        view.addSubview(pickerView)
        
        pickerView.backgroundColor = .gray
        pickerView.translatesAutoresizingMaskIntoConstraints = false
        pickerView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        pickerView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        pickerView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        pickerView.heightAnchor.constraint(equalToConstant: 80.0).isActive = true
    }
}

extension ViewController: CustomPickerViewDelegate, CustomPickerViewDataSource {
    func pickerView(_ pickerView: CustomPickerView, itemSizeForRow row: Int) -> CGSize {
        return CGSize(width: 70, height: 70)
    }
    
    func pickerView(_ pickerView: CustomPickerView, viewForRow row: Int) -> UIView {
        let view = UIView()
        view.backgroundColor = .systemPink
        return view
    }
    
    func numberOfItems(in pickerView: CustomPickerView) -> Int {
        return 20
    }
}
