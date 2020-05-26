//
//  DocumentCaptureTableViewController.swift
//  DocumentCapture-sample-Swift
//
//  Created by Jura Skrlec on 04/02/2020.
//  Copyright © 2020 Jura Skrlec. All rights reserved.
//

import UIKit

struct ScannedDocument {
    var scannedDocumentImage: UIImage?
    var highResolutionDocumentImage: UIImage?
    
    init(scannedDocumentImage: UIImage?, highResolutionDocumentImage: UIImage?) {
        self.scannedDocumentImage = scannedDocumentImage
        self.highResolutionDocumentImage = highResolutionDocumentImage
    }
}

class DocumentCaptureTableViewController: UITableViewController {
    
    var scannedDocument: ScannedDocument?

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 3
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if (section == 0) {
            return "Document Capture Recognizer Result"
        }
        else if (section == 1) {
            return "High resolution image"
        }
        
        return nil;
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if (indexPath.section == 0) {
            let cell = tableView.dequeueReusableCell(withIdentifier: DocumentCaptureTableViewCell.cellIdentifier, for: indexPath) as! DocumentCaptureTableViewCell
            cell.documentImage = scannedDocument?.scannedDocumentImage
            
            return cell
        }
        else if (indexPath.section == 1) {
            let cell = tableView.dequeueReusableCell(withIdentifier: DocumentCaptureTableViewCell.cellIdentifier, for: indexPath) as! DocumentCaptureTableViewCell
            cell.documentImage = scannedDocument?.highResolutionDocumentImage
            
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: ConfirmResultTableViewCell.cellIdentifier, for: indexPath) as! ConfirmResultTableViewCell
            cell.delegate = self
            return cell
        }

    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if (indexPath.section == 0 || indexPath.section == 1) {
            return 300
        }
        else {
            return 80
        }
    }
    
}

extension DocumentCaptureTableViewController: ConfirmResultTableViewCellDelegate {
    func didTapOk() {
        self.dismiss(animated: true, completion: nil)
    }
}
