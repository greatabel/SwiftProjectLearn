import UIKit

class CustomTabBar: UITabBar {
    
    // MARK: - Variables
    public var didTapButton: (() -> ())?
    
    public lazy var middleButton: UIButton! = {
        let middleButton = UIButton()
        
        middleButton.frame.size = CGSize(width: 48, height: 48)
        
        let image = UIImage(systemName: "plus")!
        middleButton.setImage(image, for: .normal)
        middleButton.imageEdgeInsets = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
        middleButton.backgroundColor = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)
        middleButton.tintColor = .white
        middleButton.layer.cornerRadius = 8
        
        middleButton.addTarget(self, action: #selector(self.middleButtonAction), for: .touchUpInside)
        
        self.addSubview(middleButton)
        
        return middleButton
    }()
    
    // MARK: - View Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.layer.shadowColor = #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1).cgColor
        self.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        self.layer.shadowRadius = 4.0
        self.layer.shadowOpacity = 0.4
        self.layer.masksToBounds = false

    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        middleButton.center = CGPoint(x: frame.width / 2, y: -5)
    }
    
    // MARK: - Actions
    @objc func middleButtonAction(sender: UIButton) {
        didTapButton?()
    }
    
    // MARK: - HitTest
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        guard !clipsToBounds && !isHidden && alpha > 0 else { return nil }
        
        return self.middleButton.frame.contains(point) ? self.middleButton : super.hitTest(point, with: event)
    }
}
