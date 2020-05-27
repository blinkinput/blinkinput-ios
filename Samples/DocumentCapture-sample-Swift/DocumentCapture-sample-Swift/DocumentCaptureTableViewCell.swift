//
//  DocumentCaptureTableViewCell.swift
//  DocumentCapture-sample-Swift
//
//  Created by Jura Skrlec on 04/02/2020.
//  Copyright © 2020 Jura Skrlec. All rights reserved.
//

import UIKit

class DocumentCaptureTableViewCell: UITableViewCell {
    
    @IBOutlet private weak var documentImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    public static var cellIdentifier: String {
        return "DocumentCaptureTableViewCell"
    }
    
    public var documentImage: UIImage? {
        didSet {
            documentImageView.image = documentImage
        }
    }

}
