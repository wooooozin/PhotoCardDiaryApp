//
//  PopupTaostLabel.swift
//  PhotoCardDiaryApp
//
//  Created by 효우 on 2022/10/16.
//

import UIKit

class PopupTaostLabel: UILabel {
    init(message: String) {
        super.init(frame: .zero)
        
        backgroundColor = UIColor.black.withAlphaComponent(0.6)
        textColor = UIColor.white
        textAlignment = .center
        font = UIFont.systemFont(ofSize: 14)
        text = message
        alpha = 1.0
        layer.cornerRadius = 10;
        clipsToBounds  =  true
        UIView.animate(withDuration: 5.0, delay: 0.1, options: .curveEaseOut, animations: {
            self.alpha = 0.0
        }, completion: {(isCompleted) in
            self.removeFromSuperview()
        })        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
