import UIKit
import SnapKit

class SnapTableViewCell: UITableViewCell {

    lazy var testImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = UIColor.purple
        return imageView
    }()

    var titleLabel = UILabel()
    var detailLabel = UILabel()
    var typeLabel = UILabel()

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        self.contentView.addSubview(testImageView)
        self.contentView.addSubview(titleLabel)
        self.contentView.addSubview(detailLabel)
        self.contentView.addSubview(typeLabel)
        setLayout()
    }

    func setLayout() {

        detailLabel.numberOfLines = 2
        detailLabel.font = UIFont.systemFont(ofSize: 12)
        detailLabel.textColor = UIColor.gray
        
        testImageView.snp.makeConstraints{ (make) in
            make.top.bottom.left.equalTo(self.contentView)
                .inset(UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 0))
            make.width.equalTo(70)
        }

        titleLabel.snp.makeConstraints{ (make) in
            make.left.equalTo(testImageView.snp.right).offset(15)
            make.top.equalTo(testImageView)
            make.right.equalTo(self.contentView).offset(-15)
        }

        detailLabel.snp.makeConstraints{ (make) in
            make.left.equalTo(testImageView.snp.right).offset(15)
            make.top.equalTo(titleLabel.snp.bottom).offset(15)
            make.right.equalTo(self.contentView).offset(-15)
        }
        typeLabel.snp.makeConstraints{ (make) in
            make.bottom.equalTo(self.contentView).offset(-15)
            make.right.equalTo(self.contentView).offset(-15)
            make.right.equalTo(self.contentView).offset(-15)
        }

    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
