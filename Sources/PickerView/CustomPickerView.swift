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
    func pickerView(_ pickerView: CustomPickerView, viewForIndex index: Int) -> UIView
    func sizeForItem(in pickerView: CustomPickerView) -> CGSize
    func spacingForItem(in pickerView: CustomPickerView) -> CGFloat
}

public class CustomPickerView: UIView {
    public enum Axis {
        case horizontal
        case vertical
    }
    
    public weak var dataSource: CustomPickerViewDataSource?
    public weak var delegate: CustomPickerViewDelegate?
    
    public var selectedIndex: Int? {
        guard let dataSource = dataSource, let delegate = delegate else { return nil }
        let spacing = delegate.spacingForItem(in: self)
        
        switch axis {
        case .vertical:
            let offset = scrollView.contentOffset.y + scrollView.contentInset.top
            let itemHeightWithSpace = delegate.sizeForItem(in: self).height + spacing
            let index = min(CGFloat(dataSource.numberOfItems(in: self) - 1), max(0, offset / itemHeightWithSpace))
            return Int(round(index))
            
        case .horizontal:
            let offset = scrollView.contentOffset.x + scrollView.contentInset.left
            let itemWidthWithSpace = delegate.sizeForItem(in: self).width + spacing
            let index = min(CGFloat(dataSource.numberOfItems(in: self) - 1), max(0, offset / itemWidthWithSpace))
            return Int(round(index))
        }
    }
    
    private let axis: Axis
    private var needToSetupConstraints: Bool = true
    private var scrollView: UIScrollView = UIScrollView()
    private var contentStackView: UIStackView = UIStackView()
    
    public init(axis: Axis) {
        self.axis = axis
        super.init(frame: .zero)
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
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
    }
    
    private func style() {
        scrollView.delegate = self
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.clipsToBounds = true
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        
        contentStackView.translatesAutoresizingMaskIntoConstraints = false
        contentStackView.axis = axis == .vertical ? .vertical : .horizontal
    }
}

// MARK: - Reload Data
extension CustomPickerView {
    public func reloadData() {
        guard let dataSource = dataSource, let delegate = delegate else { return }
        
        contentStackView.spacing = delegate.spacingForItem(in: self)
        contentStackView.arrangedSubviews.forEach {
            $0.removeFromSuperview()
        }
        
        for i in 0 ..< dataSource.numberOfItems(in: self) {
            let view = delegate.pickerView(self, viewForIndex: i)
            let size = delegate.sizeForItem(in: self)
            contentStackView.addArrangedSubview(view)
            
            view.tag = i
            view.translatesAutoresizingMaskIntoConstraints = false
            view.widthAnchor.constraint(equalToConstant: size.width).isActive = true
            view.heightAnchor.constraint(equalToConstant: size.height).isActive = true
            
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(itemTapGestureReceiver(_:)))
            tapGesture.numberOfTouchesRequired = 1
            tapGesture.numberOfTapsRequired = 1
            view.addGestureRecognizer(tapGesture)
        }
        
        updateScrollViewInsets()
    }
    
    private func reloadDataIfNeeded() {
        guard let dataSource = dataSource else { return }
        guard contentStackView.arrangedSubviews.count != dataSource.numberOfItems(in: self) else { return }
        reloadData()
    }
    
    private func setupConstraintsIfNeeded() {
        guard needToSetupConstraints else { return }
        needToSetupConstraints.toggle()
        
        scrollView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        scrollView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        switch axis {
        case .vertical:
            contentStackView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
            
            let topConstraints = contentStackView.topAnchor.constraint(equalTo: scrollView.topAnchor)
            let bottomConstraints = contentStackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor)
            
            [topConstraints, bottomConstraints].forEach {
                $0.priority = .defaultHigh
                $0.isActive = true
            }
            
        case .horizontal:
            contentStackView.centerYAnchor.constraint(equalTo: scrollView.centerYAnchor).isActive = true
            
            let leadingConstraints = contentStackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor)
            let trailingConstraints = contentStackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor)

            [leadingConstraints, trailingConstraints].forEach {
                $0.priority = .defaultHigh
                $0.isActive = true
            }
        }
        
        addRangeTestView()
    }
    
    private func updateScrollViewInsets() {
        guard let delegate = delegate else { return }
        let itemSize = delegate.sizeForItem(in: self)
        
        switch axis {
        case .vertical:
            let distance = (bounds.height - itemSize.height) / 2
            let insets = UIEdgeInsets(top: distance, left: 0, bottom: distance, right: 0)
            scrollView.contentInset = insets
            scrollView.setContentOffset(CGPoint(x: 0, y: -distance), animated: false)
            
        case .horizontal:
            let distance = (bounds.width - itemSize.width) / 2
            let insets = UIEdgeInsets(top: 0, left: distance, bottom: 0, right: distance)
            scrollView.contentInset = insets
            scrollView.setContentOffset(CGPoint(x: -distance, y: 0), animated: false)
        }
    }
}

// MARK: - Tap Event
extension CustomPickerView {
    @objc private func itemTapGestureReceiver(_ gesture: UITapGestureRecognizer) {
        guard let view = gesture.view else { return }
        print(#function, view.tag)
    }
}

// MARK: - UIScrollViewDelegate
extension CustomPickerView: UIScrollViewDelegate {
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let selectedIndex = selectedIndex else { return }
        print(selectedIndex)
    }
}

#warning("DEBUG Method")
extension CustomPickerView {
    private func addRangeTestView() {
        let testRangeView = UIView(frame: CGRect(origin: .zero, size: delegate?.sizeForItem(in: self) ?? .zero))
        testRangeView.layer.borderColor = UIColor.black.cgColor
        testRangeView.layer.borderWidth = 2.0
        testRangeView.isUserInteractionEnabled = false
        addSubview(testRangeView)
        
        testRangeView.center = CGPoint(x: bounds.midX, y: bounds.midY)
    }
}
