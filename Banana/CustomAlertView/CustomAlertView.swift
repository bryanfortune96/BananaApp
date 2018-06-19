//
//  CustomAlertView.swift
//  Lut


import Foundation
import UIKit

class CustomAlertView: UIView, Modal {
    
    var dialogView = UIView()
    
    var backgroundView = UIView()
    
    convenience init(trafficInfo: EventDetailsObject) {
        self.init(frame: UIScreen.main.bounds)
        backgroundView.frame = frame
        backgroundView.backgroundColor = UIColor.black
        backgroundView.alpha = 0.6
        backgroundView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTappedOnBackgroundView)))
        addSubview(backgroundView)

        dialogView = implementDialogView(trafficInfo: trafficInfo)
        
        var swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(didTappedOnBackgroundView))
        swipeUp.direction = UISwipeGestureRecognizerDirection.down
        dialogView.addGestureRecognizer(swipeUp)
        //let dialogView = CustomInfoWindowUIView(frame: fra, trafficInfo: <#T##EventDetailsObject#>)

        addSubview(dialogView)
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func didTappedOnBackgroundView() {
        NotificationCenter.default.post(name: NSNotification.Name("CloseDetailScreen"), object: nil)
        dismiss(animated: true)
    }
    
    func implementDialogView(trafficInfo: EventDetailsObject) -> UIView {
        let dialogView = CustomInfoWindowUIView(frame: frame, trafficInfo: trafficInfo)
        let dialogViewHeight:CGFloat = frame.height - 140
        dialogView.frame.origin = CGPoint(x: 32, y: frame.height)
        dialogView.frame.size = CGSize(width: frame.width-64, height: dialogViewHeight)
        dialogView.backgroundColor = UIColor.white
        dialogView.layer.cornerRadius = 15
        dialogView.layer.shadowColor = UIColor.black.cgColor
        dialogView.layer.shadowOffset = CGSize(width: 3, height: 3)
        dialogView.layer.shadowOpacity = 0.8
        dialogView.layer.shadowRadius = 6
        dialogView.clipsToBounds = true
        
        return dialogView
    }
}
