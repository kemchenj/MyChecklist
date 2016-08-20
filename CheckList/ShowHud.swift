//
//  ShowHud.swift
//  MyLocations
//
//  Created by kemchenj on 6/28/16.
//  Copyright © 2016 kemchenj. All rights reserved.
//

import UIKit

protocol Hudable {
    func showHudInView(text: String, rootView view: UIView, animated: Bool)
}

extension Hudable where Self: UIViewController {

    func showHudInView(text: String, rootView view: UIView, animated: Bool) {
        let hudView = HudView.hudInView(text as NSString, animated: true)

        view.addSubview(hudView)
        view.isUserInteractionEnabled = false
    }



}
