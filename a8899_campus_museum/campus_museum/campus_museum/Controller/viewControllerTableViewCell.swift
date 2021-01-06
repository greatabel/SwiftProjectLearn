import UIKit

//a custom UITableViewCell class for the custom table cell
class viewControllerTableViewCell: UITableViewCell {

    @IBOutlet weak var myTextView: UITextView!
    @IBOutlet weak var myImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    //cell will contain a image and the textfield for presenting the
    //aetwork information
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        myImage.layer.masksToBounds = true
        myImage.layer.cornerRadius = 10;
        //Configure the view for the selected state 
    }

}
