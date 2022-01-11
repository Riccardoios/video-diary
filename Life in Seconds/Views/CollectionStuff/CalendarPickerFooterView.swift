

import UIKit

class CalendarPickerFooterView: UIView {
    
    lazy var separatorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.label.withAlphaComponent(0.2)
        return view
    }()
    
    
    lazy var previousMonthButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = .systemFont(ofSize: 17, weight: .medium)
        button.titleLabel?.textAlignment = .left
        
        if let chevronImage = UIImage(systemName: "chevron.left.circle.fill") {
            let imageAttachment = NSTextAttachment(image: chevronImage)
            let attributedString = NSMutableAttributedString()
            
            attributedString.append(
                NSAttributedString(attachment: imageAttachment)
            )
            
            attributedString.append(
                NSAttributedString(string: " Previous")
            )
            
            button.setAttributedTitle(attributedString, for: .normal)
        } else {
            button.setTitle("Previous", for: .normal)
        }
        
        button.titleLabel?.textColor = .label
        
        button.addTarget(self, action: #selector(didTapPreviousMonthButton), for: .touchUpInside)
        return button
    }()
    
    lazy var nextMonthButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = .systemFont(ofSize: 17, weight: .medium)
        button.titleLabel?.textAlignment = .right
        
        if let chevronImage = UIImage(systemName: "chevron.right.circle.fill") {
            let imageAttachment = NSTextAttachment(image: chevronImage)
            let attributedString = NSMutableAttributedString(string: "Next ")
            
            attributedString.append(
                NSAttributedString(attachment: imageAttachment)
            )
            
            button.setAttributedTitle(attributedString, for: .normal)
        } else {
            button.setTitle("Next", for: .normal)
        }
        
        button.titleLabel?.textColor = .label
        
        button.addTarget(self, action: #selector(didTapNextMonthButton), for: .touchUpInside)
        return button
    }()
    
    let didTapLastMonthCompletionHandler: (() -> Void)
    let didTapNextMonthCompletionHandler: (() -> Void)
    
    init(
        didTapLastMonthCompletionHandler: @escaping (() -> Void),
        didTapNextMonthCompletionHandler: @escaping (() -> Void)
    ) {
        self.didTapLastMonthCompletionHandler = didTapLastMonthCompletionHandler
        self.didTapNextMonthCompletionHandler = didTapNextMonthCompletionHandler
        
        
        super.init(frame: CGRect.zero)
        
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .systemGroupedBackground
        
        layer.maskedCorners = [
            .layerMinXMaxYCorner,
            .layerMaxXMaxYCorner
        ]
        layer.cornerCurve = .continuous
        layer.cornerRadius = 15
        
        addSubview(separatorView)
        addSubview(previousMonthButton)
        addSubview(nextMonthButton)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func adjustImageAndTitleOffsetsForButton (button: UIButton) {

       let spacing: CGFloat = 6.0

        let imageSize = button.imageView!.frame.size

        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: -(imageSize.height + spacing), right: 0)

       let titleSize = button.titleLabel!.frame.size

        button.imageEdgeInsets = UIEdgeInsets(top: -(titleSize.height + spacing), left: 0, bottom: 0, right: -titleSize.width)
   }
    
    private var previousOrientation: UIDeviceOrientation = UIDevice.current.orientation
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let smallDevice = UIScreen.main.bounds.width <= 350
        
        let fontPointSize: CGFloat = smallDevice ? 14 : 17
        
        previousMonthButton.titleLabel?.font = .systemFont(ofSize: fontPointSize, weight: .medium)
        nextMonthButton.titleLabel?.font = .systemFont(ofSize: fontPointSize, weight: .medium)
//        mergeButton.titleLabel?.font = .systemFont(ofSize: fontPointSize, weight: .medium)
//        adjustImageAndTitleOffsetsForButton(button: mergeButton)
        NSLayoutConstraint.activate([
            separatorView.leadingAnchor.constraint(equalTo: leadingAnchor),
            separatorView.trailingAnchor.constraint(equalTo: trailingAnchor),
            separatorView.topAnchor.constraint(equalTo: topAnchor),
            separatorView.heightAnchor.constraint(equalToConstant: 1),
            
            previousMonthButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            previousMonthButton.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            
            nextMonthButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            nextMonthButton.topAnchor.constraint(equalTo: topAnchor, constant: 10)
        ])
    }
    
    @objc func didTapPreviousMonthButton() {
        didTapLastMonthCompletionHandler()
    }
    
    @objc func didTapNextMonthButton() {
        didTapNextMonthCompletionHandler()
    }
    

}



