//
//  ConfirmResultTableViewCell.swift
//  DocumentCapture-sample-Swift
//
//  Created by Jura Skrlec on 05/02/2020.
//  Copyright © 2020 Jura Skrlec. All rights reserved.
//

import UIKit

protocol ConfirmResultTableViewCellDelegate: AnyObject {
    func didTapOk()
}

class ConfirmResultTableViewCell: UITableViewCell {
    
    weak var delegate: ConfirmResultTableViewCellDelegate?
    
    public static var cellIdentifier: String {
        return "ConfirmResultTableViewCell"
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func didTapOkButton(_ sender: Any) {
        delegate?.didTapOk()
    }
}
