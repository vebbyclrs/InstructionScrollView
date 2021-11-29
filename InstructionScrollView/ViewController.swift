//
//  ViewController.swift
//  InstructionScrollView
//
//  Created by Vebby Clarissa on 29/11/21.
//

import Instructions

class ViewController: UIViewController {
    @IBOutlet weak var blueView: UIView!
    @IBOutlet weak var redView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!

    let coachMarksController = CoachMarksController()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.scrollView.delegate = self
        self.coachMarksController.delegate = self
        self.coachMarksController.dataSource = self
        self.coachMarksController.overlay.color = UIColor.black.withAlphaComponent(0.75)


    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.coachMarksController.start(in: .window(over: self))
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.coachMarksController.stop(immediately: true)
    }

}

extension ViewController: UIScrollViewDelegate {
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        var rect = self.view.window!.convert(self.redView.frame, from: self.redView.superview)
        rect = CGRect(x: rect.origin.x,
                      y: rect.origin.y,
                      width: rect.width,
                      height: rect.height)
        let maker = { (frame: CGRect) -> UIBezierPath in
            return UIBezierPath(roundedRect: rect.insetBy(dx: -4, dy: -4),
                                byRoundingCorners: .allCorners,
                                cornerRadii: CGSize(width: 4, height: 4))
        }
        // Once the animation is completed, we update the coach mark,
        // and start the display again.
        /**
         To know more about how to update the coach mark,
                 // find the documentation here: https://github.com/ephread/Instructions/blob/main/Examples/Example/Sources/Core/View%20Controllers/Delegate%20Examples/DelegateViewController.swift#L107
         */
        coachMarksController.helper.updateCurrentCoachMark(
            usingView: self.redView,
            pointOfInterest: nil,
            cutoutPathMaker: maker
        )
        
        /**To know more about how to resume and pause the flow of Coach Mark, refer this issue:
         https://github.com/ephread/Instructions/issues/249
         */
        coachMarksController.flow.resume()
    }
}

extension ViewController: CoachMarksControllerDelegate, CoachMarksControllerDataSource {
    func coachMarksController(_ coachMarksController: CoachMarksController, coachMarkViewsAt index: Int, madeFrom coachMark: CoachMark) -> (bodyView: CoachMarkBodyView, arrowView: CoachMarkArrowView?) {
        let coachViews = coachMarksController.helper.makeDefaultCoachViews(
            withArrow: true,
            arrowOrientation: coachMark.arrowOrientation
        )

        switch(index) {
        case 0:
            coachViews.bodyView.hintLabel.text = "This is Blue"
        case 1:
            coachViews.bodyView.hintLabel.text = "This is Red"
        default: break
        }
        coachViews.bodyView.nextLabel.text = "Ok"

        return (bodyView: coachViews.bodyView, arrowView: coachViews.arrowView)
    }
    
    func coachMarksController(_ coachMarksController: CoachMarksController, coachMarkAt index: Int) -> CoachMark {
        var coachMark: CoachMark
        
        switch(index) {
        case 0:
            coachMark = coachMarksController.helper.makeCoachMark(for: blueView)
            coachMark.arrowOrientation = .top
        case 1:
            coachMark = coachMarksController.helper.makeCoachMark(for: redView)
            coachMark.arrowOrientation = .bottom

        default:
            coachMark = coachMarksController.helper.makeCoachMark()
        }

        
        return coachMark

    }
    
    func coachMarksController(_ coachMarksController: CoachMarksController, willShow coachMark: inout CoachMark, beforeChanging change: ConfigurationChange, at index: Int) {
        if index == 1 && change == .nothing {
            
            /**To know more about how to resume and pause the flow of Coach Mark, refer this issue:
             https://github.com/ephread/Instructions/issues/249
             */
            coachMarksController.flow.pause()
        }
    }
    
    func coachMarksController(_ coachMarksController: CoachMarksController, didHide coachMark: CoachMark, at index: Int) {
        if index == 0 {
            // scroll to show the red view
            scrollView.scrollRectToVisible(redView.frame, animated: true)
        }
    }
    
    func numberOfCoachMarks(for coachMarksController: CoachMarksController) -> Int {
        return 2
    }
    
    
    
}

