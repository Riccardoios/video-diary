

import UIKit

class CalendarPickerHeaderView: UIView {
    lazy var monthLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 26, weight: .bold)
        label.text = "Month"
        label.accessibilityTraits = .header
        label.isAccessibilityElement = true
        return label
    }()
    
    lazy var mergeButton: UIButton = {
        let color = UIColor.systemIndigo
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
//        button.frame = CGRect(x: 100, y: 100, width: 70, height: 70)
        
        button.setTitle("Merge", for: .normal)
        button.setTitleColor(color, for: .normal)
        button.titleEdgeInsets = UIEdgeInsets(top: 20, left: -35, bottom: -25, right: 2)
        
        var image = UIImage(named: "clapperboard.fill.png")?.withRenderingMode(.alwaysTemplate)
        
        button.tintColor = color
        button.setImage(image, for: .normal)
        button.imageView?.contentMode = .top
        button.imageView?.contentMode = .scaleAspectFit
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 15, bottom: 15, right: 25)
//        button.layer.borderWidth = 1.0
//        button.layer.borderColor = UIColor.purple.cgColor
//        button.layer.cornerRadius = 30
        
        button.addTarget(self, action: #selector(didTapMergeButton), for: .touchUpInside)
        
        return button
    }()
    
    
    
    lazy var separatorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.label.withAlphaComponent(0.2)
        return view
    }()
    
    private lazy var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.calendar = Calendar(identifier: .gregorian)
        dateFormatter.locale = Locale.autoupdatingCurrent
        dateFormatter.setLocalizedDateFormatFromTemplate("MMMM y")
        return dateFormatter
    }()
    
    var baseDate = Date() {
        didSet {
            monthLabel.text = dateFormatter.string(from: baseDate)
        }
    }
    
    let didTapMergeCompletitionHandler: (() -> Void)
    
    
    init( exitButtonTappedCompletionHandler: @escaping (() -> Void),
          didTapMergeCompletitionHandler: @escaping (() -> Void)
    )  {
        
        self.didTapMergeCompletitionHandler = didTapMergeCompletitionHandler
        
        super.init(frame: CGRect.zero)
        
        translatesAutoresizingMaskIntoConstraints = false
        
        backgroundColor = .systemGroupedBackground
        
        addSubview(monthLabel)
        addSubview(separatorView)
        addSubview(mergeButton)
       
        
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        addSubview(mergeButton)
        
        mergeButton.frame.size = CGSize(width: 70, height: 70)
        
        NSLayoutConstraint.activate([
            monthLabel.topAnchor.constraint(equalTo: super.safeAreaLayoutGuide.topAnchor),
            monthLabel.centerXAnchor.constraint(equalTo: super.centerXAnchor),
            
            mergeButton.widthAnchor.constraint(equalToConstant: 70),
            mergeButton.heightAnchor.constraint(equalToConstant: 70),
            mergeButton.trailingAnchor.constraint(equalTo: super.trailingAnchor, constant: -20),
            mergeButton.topAnchor.constraint(equalTo: super.topAnchor, constant: 40),
            
//            mergeButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            separatorView.leadingAnchor.constraint(equalTo: leadingAnchor),
            separatorView.trailingAnchor.constraint(equalTo: trailingAnchor),
            separatorView.bottomAnchor.constraint(equalTo: bottomAnchor),
            separatorView.heightAnchor.constraint(equalToConstant: 1)
        ])
    }
    
    @objc func didTapMergeButton() {
        didTapMergeCompletitionHandler()
    }
}
