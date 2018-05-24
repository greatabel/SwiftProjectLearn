import UIKit

protocol TitleSegmentDelegate: class {

    func buttonDidClicked(index: Int)
}

class TitleSegment: UIView {

    weak var delegate : TitleSegmentDelegate?

    let buttonTagBase = 100
    var index: Int = 0

    var titleArray: Array<String>? {

        didSet {
            createTitleViews()
        }
    }
    lazy var scrollView: UIScrollView = {
        let temp = UIScrollView()
        temp.showsHorizontalScrollIndicator = false
        temp.backgroundColor = UIColor(red: 246.0/255.0, green: 246.0/255.0, blue: 246.0/255.0, alpha: 1)

        return temp
    }()

    override init(frame: CGRect) {

        super.init(frame: frame)
        print("frame.size.height = \(frame.size.height)")
        scrollView.frame = CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height)
        self.addSubview(scrollView)

    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func createTitleViews() {
        for subview in self.scrollView.subviews {

            subview.removeFromSuperview()

        }
        let width: CGFloat = 80
        if let count = titleArray?.count {
            print("\(count)")
            for i in 0..<count {

                let button = UIButton()
                button.frame = CGRect(x: CGFloat(i) * width, y: 0, width: width
                    , height: frame.size.height)
                button.backgroundColor = UIColor.clear
                button.addTarget(self, action: #selector(buttonClicked), for: UIControlEvents.touchUpInside)
                button.tag = i + buttonTagBase
                self.scrollView.addSubview(button)


                button.setTitleColor(UIColor(red: 220.0/255.0, green: 50.0/255.0, blue: 55.0/255.0, alpha: 1), for:.selected)

                button.setTitleColor(UIColor(red: 74.0/255.0, green: 74.0/255.0, blue: 74.0/255.0, alpha: 1), for: .normal)


                if let title = self.titleArray?[i] {
                    button.setTitle(title, for: .normal)
                }
                if i + buttonTagBase == self.index {
                    button.isSelected = true
                }

            }
            
            scrollView.contentSize = CGSize(width: width * CGFloat(count),
                                            height: self.frame.size.height)

        }
    }

    @objc func buttonClicked(button: UIButton){
        if let tempButton = self.scrollView.viewWithTag(self.index) as? UIButton {
            tempButton.isSelected = false
        }
        button.isSelected = true
        self.delegate?.buttonDidClicked(index: button.tag - buttonTagBase)
        self.index = button.tag
    }



}
