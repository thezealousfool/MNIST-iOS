//
//  ViewController.swift
//  NavCog DNN
//
//  Created by Vivek Roy on 11/20/19.
//  Copyright © 2019 Vivek Roy. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var mnist0: UIButton!
    @IBOutlet weak var mnist1: UIButton!
    @IBOutlet weak var mnist2: UIButton!
    @IBOutlet weak var mnist3: UIButton!
    @IBOutlet weak var mnist4: UIButton!
    @IBOutlet weak var mnist5: UIButton!
    @IBOutlet weak var mnist6: UIButton!
    @IBOutlet weak var mnist7: UIButton!
    @IBOutlet weak var mnist8: UIButton!
    @IBOutlet weak var mnist9: UIButton!
    @IBOutlet weak var mnist10: UIButton!
    @IBOutlet weak var mnist11: UIButton!
    @IBOutlet weak var mnist12: UIButton!
    @IBOutlet weak var mnist13: UIButton!
    @IBOutlet weak var mnist14: UIButton!
    @IBOutlet weak var mnist15: UIButton!
    @IBOutlet weak var mnist16: UIButton!
    @IBOutlet weak var mnist17: UIButton!
    @IBOutlet weak var mnist18: UIButton!
    @IBOutlet weak var mnist19: UIButton!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var prob: UILabel!
    @IBOutlet weak var pred: UILabel!
    @IBOutlet weak var disp: UIImageView!
    @IBAction func bClick(_ sender: Any) {
        let img = (sender as? UIButton)?.imageView?.image
        disp.image = img
        if let image = img {
            let result = classifier?.classify(image: image)
            time.text = NSString(format:"%d ms", result?.timeCost ?? -1) as String
            prob.text = NSString(format:"%.6f", result?.prob ?? -1) as String
            pred.text = "\(result?.number ?? -1)"
        }
    }
    
    private var classifier : Classifier?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mnist0.imageView?.contentMode = .scaleAspectFit
        mnist1.imageView?.contentMode = .scaleAspectFit
        mnist2.imageView?.contentMode = .scaleAspectFit
        mnist3.imageView?.contentMode = .scaleAspectFit
        mnist4.imageView?.contentMode = .scaleAspectFit
        mnist5.imageView?.contentMode = .scaleAspectFit
        mnist6.imageView?.contentMode = .scaleAspectFit
        mnist7.imageView?.contentMode = .scaleAspectFit
        mnist8.imageView?.contentMode = .scaleAspectFit
        mnist9.imageView?.contentMode = .scaleAspectFit
        mnist10.imageView?.contentMode = .scaleAspectFit
        mnist11.imageView?.contentMode = .scaleAspectFit
        mnist12.imageView?.contentMode = .scaleAspectFit
        mnist13.imageView?.contentMode = .scaleAspectFit
        mnist14.imageView?.contentMode = .scaleAspectFit
        mnist15.imageView?.contentMode = .scaleAspectFit
        mnist16.imageView?.contentMode = .scaleAspectFit
        mnist17.imageView?.contentMode = .scaleAspectFit
        mnist18.imageView?.contentMode = .scaleAspectFit
        mnist19.imageView?.contentMode = .scaleAspectFit
        classifier = Classifier()
    }
}

