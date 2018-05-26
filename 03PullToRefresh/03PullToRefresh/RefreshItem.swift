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

    func updateViewPositionForPercentage(percentage: CGFloat) {
        view.center = CGPoint(
            x: centerStart.x + (centerEnd.x - centerStart.x) * percentage,
            y: centerStart.y + (centerEnd.y - centerStart.y) * percentage)
        print("(view.center.y = \(view.center.y)")
        if view.center.y > 180 {
            view.isHidden = true
        } else {
            view.isHidden = false
        }

    }
}
