//
//  CustomPickerView.swift
//  CustomPickerSample
//
//  Created by Wayne Kim on 2020/02/19.
//  Copyright © 2020 Wayne Kim. All rights reserved.
//

import UIKit

public protocol CustomPickerViewDataSource: class {
    func numberOfItems(in pickerView: CustomPickerView) -> Int
}

public protocol CustomPickerViewDelegate: class {
    func pickerView(_ pickerView: CustomPickerView, itemSizeForRow row: Int) -> CGSize
    func pickerView(_ pickerView: CustomPickerView, viewForRow row: Int) -> UIView
}

public class CustomPickerView: UIView {
    public weak var dataSource: CustomPickerViewDataSource?
    public weak var delegate: CustomPickerViewDelegate?
    
    private var needToSetupConstraints = true
    private var scrollView = UIScrollView()
    private var contentStackView = UIStackView()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initialize()
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        setupConstraintsIfNeeded()
        reloadDataIfNeeded()
    }
    
    private func initialize() {
        addSubview()
        style()
    }
    
    private func addSubview() {
        addSubview(scrollView)
        scrollView.addSubview(contentStackView)
        
        reloadData()
    }
    
    private func style() {
        scrollView.delegate = self
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        
        contentStackView.translatesAutoresizingMaskIntoConstraints = false
        contentStackView.alignment = .center
        contentStackView.axis = .horizontal
        contentStackView.distribution = .equalSpacing
        contentStackView.spacing = 10.0
    }
    
    private func setupConstraintsIfNeeded() {
        guard needToSetupConstraints else { return }
        needToSetupConstraints.toggle()
        
        scrollView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        scrollView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        contentStackView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        contentStackView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        let leadingConstraints = contentStackView.leadingAnchor.constraint(equalTo: leadingAnchor)
        leadingConstraints.priority = .defaultHigh
        leadingConstraints.isActive = true
        
        let trailingConstraints = contentStackView.trailingAnchor.constraint(equalTo: trailingAnchor)
        trailingConstraints.priority = .defaultHigh
        trailingConstraints.isActive = true
    }
    
    private func reloadDataIfNeeded() {
        guard let dataSource = dataSource else { return }
        guard contentStackView.arrangedSubviews.count != dataSource.numberOfItems(in: self) else { return }
        reloadData()
    }
    
    public func reloadData() {
        guard let dataSource = dataSource, let delegate = delegate else { return }
        
        contentStackView.arrangedSubviews.forEach {
            $0.removeFromSuperview()
        }
        
        for i in 0 ..< dataSource.numberOfItems(in: self) {
            let view = delegate.pickerView(self, viewForRow: i)
            let size = delegate.pickerView(self, itemSizeForRow: i)
            contentStackView.addArrangedSubview(view)
            
            view.translatesAutoresizingMaskIntoConstraints = false
            view.widthAnchor.constraint(equalToConstant: size.width).isActive = true
            view.heightAnchor.constraint(equalToConstant: size.height).isActive = true
        }
    }
}

extension CustomPickerView: UIScrollViewDelegate {
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print(scrollView.contentOffset)
    }
}
