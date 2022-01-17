

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
    
    var mergingButton: MergingButton!
    
    init( exitButtonTappedCompletionHandler: @escaping (() -> Void)
    )  {
        
        
        
        super.init(frame: CGRect.zero)
        
        mergingButton = UINib(nibName: "MergingButton", bundle: nil).instantiate(withOwner: self, options: nil).first as? MergingButton
        
        translatesAutoresizingMaskIntoConstraints = false
        
        backgroundColor = .systemGroupedBackground
        
        addSubview(monthLabel)
        addSubview(separatorView)
        addSubview(mergingButton)
        
        mergingButton.translatesAutoresizingMaskIntoConstraints = false
        mergingButton.backgroundColor = nil
        
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        addSubview(mergingButton)
        mergingButton.frame.size = CGSize(width: 70, height: 70)
        
        NSLayoutConstraint.activate([
            monthLabel.topAnchor.constraint(equalTo: super.safeAreaLayoutGuide.topAnchor),
            monthLabel.centerXAnchor.constraint(equalTo: super.centerXAnchor),
            
            
            mergingButton.trailingAnchor.constraint(equalTo: super.trailingAnchor),
            mergingButton.topAnchor.constraint(equalTo: super.topAnchor, constant: 40),
            mergingButton.widthAnchor.constraint(equalToConstant: 70),
            mergingButton.heightAnchor.constraint(equalToConstant: 70),
            
            separatorView.leadingAnchor.constraint(equalTo: leadingAnchor),
            separatorView.trailingAnchor.constraint(equalTo: trailingAnchor),
            separatorView.bottomAnchor.constraint(equalTo: bottomAnchor),
            separatorView.heightAnchor.constraint(equalToConstant: 1)
        ])
    }
    
}
