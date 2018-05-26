import UIKit

private let kSceneHeight: CGFloat = 200.0

class RefreshView: UIView, UIScrollViewDelegate {

    private unowned var scrollView : UIScrollView
    private var progress: CGFloat = 0.0

    init(frame: CGRect, scrollView: UIScrollView) {
        self.scrollView = scrollView
        super.init(frame: frame)
        backgroundColor = UIColor.green
        updateBackgroundColor()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func updateBackgroundColor() {
        backgroundColor = UIColor(white: 0.7 * progress + 0.2,
                                  alpha: 1.0)
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // 1. 先拿到刷新试图可见区域高度
        let refreshViewVisibleHeight = max(0,
                                           -scrollView.contentOffset.y - scrollView.contentInset.top)
        print("refreshViewVisibleHeight= \(refreshViewVisibleHeight)")
        // 2. 计算华东到进度
        progress = min(1,refreshViewVisibleHeight / kSceneHeight)
        print("progress= \(progress)")
        //3. 改变背景
        updateBackgroundColor()

    }
}
