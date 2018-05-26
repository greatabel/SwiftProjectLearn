import UIKit

private let kSceneHeight: CGFloat = 180

class RefreshView: UIView, UIScrollViewDelegate {

    private unowned var scrollView : UIScrollView
    private var progress: CGFloat = 0.0
    var refreshItems = [RefreshItem]()

    init(frame: CGRect, scrollView: UIScrollView) {
        self.scrollView = scrollView
        super.init(frame: frame)
        backgroundColor = UIColor.green
        updateBackgroundColor()
        setupRefreshItems()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupRefreshItems() {
        let groundImageView = UIImageView(image: UIImage(named: "ground"))
        let buildingsImageView = UIImageView(image: UIImage(named: "buildings"))
        let sunImageView = UIImageView(image: UIImage(named: "sun"))
        let catImageView = UIImageView(image: UIImage(named: "cat"))
        let capeBackImageView = UIImageView(image: UIImage(named: "cape_back"))
        let capeFrontImageView = UIImageView(image: UIImage(named: "cape_front"))

        refreshItems = [
            RefreshItem(view: buildingsImageView,
                        centerEnd: CGPoint(x: (bounds).midX,
                                           y: (bounds).height - (groundImageView.bounds).height - (buildingsImageView.bounds).height / 2),
                        parallaxRatio: 1.5, sceneHeight: kSceneHeight),
            RefreshItem(view: sunImageView,
                        centerEnd: CGPoint(x: (bounds).width * 0.1,
                                           y: (bounds).height - (groundImageView.bounds).height - (sunImageView.bounds).height),
                        parallaxRatio: 3, sceneHeight: kSceneHeight),
            RefreshItem(view: groundImageView,
                        centerEnd: CGPoint(x: (bounds).midX,
                                           y: (bounds).height - (groundImageView.bounds).height/2),
                        parallaxRatio: 0.5, sceneHeight: kSceneHeight),
            RefreshItem(view: capeBackImageView, centerEnd: CGPoint(x: (bounds).midX, y: (bounds).height - (groundImageView.bounds).height/2 - (capeBackImageView.bounds).height/2), parallaxRatio: -1, sceneHeight: kSceneHeight),
            RefreshItem(view: catImageView, centerEnd: CGPoint(x: (bounds).midX, y: (bounds).height - (groundImageView.bounds).height/2 - (catImageView.bounds).height/2) , parallaxRatio: 1, sceneHeight: kSceneHeight),
            RefreshItem(view: capeFrontImageView, centerEnd: CGPoint(x: (bounds).midX, y: (bounds).height - (groundImageView.bounds).height/2 - (capeFrontImageView.bounds).height/2), parallaxRatio: -1, sceneHeight: kSceneHeight),
        ]

        for refreshItem in refreshItems {
            addSubview(refreshItem.view)
        }

    }

    func updateBackgroundColor() {
        backgroundColor = UIColor(white: 0.7 * progress + 0.2,
                                  alpha: 1.0)
    }

    func updateRefreshItemPositions() {
        for refreshItem in refreshItems {
            refreshItem.updateViewPositionForPercentage(percentage: progress)
        }
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // 1. 先拿到刷新试图可见区域高度
        let refreshViewVisibleHeight = max(0,
                                           -scrollView.contentOffset.y - scrollView.contentInset.top)
//        print("refreshViewVisibleHeight= \(refreshViewVisibleHeight)")
        // 2. 计算华东到进度
        progress = min(1,refreshViewVisibleHeight / kSceneHeight)
//        print("progress= \(progress)")
        //3. 改变背景
        updateBackgroundColor()
        //4. 根据进度来更新图片位置
        updateRefreshItemPositions()
    }
}
