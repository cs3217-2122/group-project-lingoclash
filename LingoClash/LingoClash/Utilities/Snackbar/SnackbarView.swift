//
//  SnackbarView.swift
//  LingoClash
//
//  Created by Ai Ling Hong on 15/4/22.
//
import UIKit

class SnackbarView: UIView {

    let viewModel: SnackbarViewModel

    private var handler: Handler?

    private let label: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()

    init(viewModel: SnackbarViewModel, frame: CGRect) {
        self.viewModel = viewModel
        super.init(frame: frame)

        setUpView()
        configure()
    }

    private func setUpView() {
        addSubview(label)

        layer.cornerRadius = 8
        backgroundColor = #colorLiteral(red: 0.2196078449, green: 0.007843137719, blue: 0.8549019694, alpha: 1)

        layer.shadowOffset = CGSize(width: 5, height: 5)
        layer.shadowRadius = 5
        layer.shadowOpacity = 0.3
    }

    private func configure() {
        label.text = viewModel.text
        switch viewModel.type {
        case .action(let handler):
            self.handler = handler

            isUserInteractionEnabled = true
            let gesture = UITapGestureRecognizer(target: self, action: #selector(didTapSnackbar))
            gesture.numberOfTouchesRequired = 1
            gesture.numberOfTapsRequired = 1
            addGestureRecognizer(gesture)

        case.info:
            break
        }
    }

    @objc private func didTapSnackbar() {
        handler?()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        label.frame = bounds
    }

    @available(*, unavailable)
    required init(coder: NSCoder) {
        fatalError("init(coder:) not implemented")
    }

}
