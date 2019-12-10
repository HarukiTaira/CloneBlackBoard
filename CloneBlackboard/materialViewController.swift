//
//  materialViewController.swift
//  CloneBlackboard
//
//  Created by 平良悠貴 on 2019/12/05.
//  Copyright © 2019 平良悠貴. All rights reserved.
//

import UIKit
import Material

struct ButtonLayout {
    struct Flat {
        static let width: CGFloat = 120
        static let height: CGFloat = 44
        static let offsetY: CGFloat = -150
    }
    
    struct Raised {
        static let width: CGFloat = 150
        static let height: CGFloat = 44
        static let offsetY: CGFloat = -75
    }
    
    struct Fab {
        static let diameter: CGFloat = 48
    }
    
    struct Icon {
        static let width: CGFloat = 120
        static let height: CGFloat = 48
        static let offsetY: CGFloat = 75
    }
}

class materialViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        prepareFlatButton()
        prepareRaisedButton()
        prepareFABButton()
        prepareIconButton()
    }
}

extension materialViewController {
    fileprivate func prepareFlatButton() {
        let button = FlatButton(title: "Flat Button")
        
        view.layout(button)
            .width(ButtonLayout.Flat.width)
            .height(ButtonLayout.Flat.height)
            .center(offsetY: ButtonLayout.Flat.offsetY)
    }
    
    fileprivate func prepareRaisedButton() {
        let button = RaisedButton(title: "Raised Button", titleColor: .white)
        button.pulseColor = .white
        button.backgroundColor = Color.blue.base
        
        view.layout(button)
            .width(ButtonLayout.Raised.width)
            .height(ButtonLayout.Raised.height)
            .center(offsetY: ButtonLayout.Raised.offsetY)
    }
    
    fileprivate func prepareFABButton() {
        let button = FABButton(image: Icon.cm.add, tintColor: .white)
        button.pulseColor = .white
        button.backgroundColor = Color.red.base
        
        view.layout(button)
            .width(ButtonLayout.Fab.diameter)
            .height(ButtonLayout.Fab.diameter)
            .center()
    }
    
    fileprivate func prepareIconButton() {
        let button = IconButton(image: Icon.cm.search)
        
        view.layout(button)
            .width(ButtonLayout.Icon.width)
            .height(ButtonLayout.Icon.height)
            .center(offsetY: ButtonLayout.Icon.offsetY)
    }
}

