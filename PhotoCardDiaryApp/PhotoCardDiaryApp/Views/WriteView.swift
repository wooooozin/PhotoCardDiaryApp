//
//  WriteView.swift
//  PhotoCardDiaryApp
//
//  Created by 효우 on 2022/10/12.
//

import UIKit

final class WriteView: UIView {
    
    // MARK: - Property
    
    lazy var closeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("닫기", for: .normal)
        button.tintColor = .black
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var addButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("완료", for: .normal)
        button.tintColor = .black
        button.isEnabled = false
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .black
        label.text = "새로운 순간"
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let mainImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.isUserInteractionEnabled = true
        imageView.image = UIImage(systemName: "photo")
        imageView.tintColor = .systemGray6
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let titleTextField: UITextField = {
        let tf = UITextField()
        tf.borderStyle = .none
        tf.textColor = .black
        tf.placeholder = "제목을 입력해주세요"
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    let memoTextView: UITextView = {
        let tv = UITextView()
        tv.textColor = .lightGray
        tv.isScrollEnabled = true
        tv.text = "당신의 순간을 기록해주세요."
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    
    let topStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .horizontal
        sv.alignment = .fill
        sv.distribution = .fill
        sv.spacing = 10
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    let bottomStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.alignment = .fill
        sv.distribution = .fill
        sv.spacing = 5
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        setupUI()
        memoTextView.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        setTopStackView()
        setBottomStackView()
    }
    
    private func setTopStackView() {
        self.addSubview(topStackView)
        topStackView.addArrangedSubview(closeButton)
        topStackView.addArrangedSubview(titleLabel)
        topStackView.addArrangedSubview(addButton)
        
        NSLayoutConstraint.activate([
            topStackView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 0),
            topStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            topStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
        ])
        
        NSLayoutConstraint.activate([
            closeButton.widthAnchor.constraint(equalToConstant: 45),
            addButton.widthAnchor.constraint(equalToConstant: 45)
        ])
    }
    
    private func setBottomStackView() {
        self.addSubview(bottomStackView)
        bottomStackView.addArrangedSubview(mainImageView)
        bottomStackView.addArrangedSubview(titleTextField)
        bottomStackView.addArrangedSubview(memoTextView)
        
        NSLayoutConstraint.activate([
            bottomStackView.topAnchor.constraint(equalTo: topStackView.bottomAnchor, constant: 10),
            bottomStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            bottomStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
            bottomStackView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: 0)
        ])
        
        NSLayoutConstraint.activate([
            mainImageView.heightAnchor.constraint(equalToConstant: 200),
            titleTextField.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
}

extension WriteView: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "당신의 순간을 기록해주세요." {
            textView.text = nil
            textView.textColor = .black
        }
    }
    
    // 입력이 끝났을때
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            textView.text = "당신의 순간을 기록해주세요."
            textView.textColor = .lightGray
        }
    }
}
