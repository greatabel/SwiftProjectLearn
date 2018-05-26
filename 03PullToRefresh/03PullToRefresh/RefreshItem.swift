import UIKit

class RefreshItem {
    private var centerStart: CGPoint
    private var centerEnd: CGPoint
    unowned var view: UIView

    init(view: UIView, centerEnd: CGPoint, parallaxRatio: CGFloat, sceneHeight: CGFloat) {
        self.view = view
        self.centerEnd = centerEnd
        centerStart = CGPoint(x: centerEnd.x, y: centerEnd.y + (parallaxRatio * sceneHeight))
        self.view.center = centerStart
    }
}
