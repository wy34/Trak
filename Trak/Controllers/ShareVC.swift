//
//  ShareVC.swift
//  TrackingApp
//
//  Created by William Yeung on 12/28/20.
//

import UIKit
import MessageUI


class ShareViewController: UIViewController {
    // MARK: - Properties
    var activitySession: ActivitySession? {
        didSet {
            guard let session = activitySession else { return }
            mapSnapshotView.activitySession = session
        }
    }
    
    lazy var shareWindowView = UpsideDownCommentView()
    var shareWindowViewBottomConstraint: NSLayoutConstraint!
    
    // MARK: - Views
    private let blueBorderLine = UIView.createBlueBorderLine()
    private let mapSnapshotView = MapSnapshotView()
    
    private lazy var shareCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.register(ShareOptionCell.self, forCellWithReuseIdentifier: ShareOptionCell.reuseId)
        cv.backgroundColor = UIColor.StandardDarkMode
        cv.delegate = self
        cv.dataSource = self
        return cv
    }()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        layoutViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.3) {
                self.shareWindowViewBottomConstraint.constant = 0
                self.view.layoutIfNeeded()
            }
        }
    }
    
    // MARK: - Helpers
    private func configureUI() {
        edgesForExtendedLayout = []
        let dismissButton = UIBarButtonItem(title: "Dismiss".localized(), style: .plain, target: self, action: #selector(dismissShareVC))
        let textAttributes = [NSAttributedString.Key.font: UIFontMetrics(forTextStyle: .body).scaledFont(for: UIFont.medium17!)]
        dismissButton.setTitleTextAttributes(textAttributes, for: .normal)
        navigationItem.leftBarButtonItem = dismissButton
        view.backgroundColor = UIColor.StandardDarkMode
    }
    
    private func layoutViews() {
        view.addSubviews(shareWindowView, blueBorderLine, mapSnapshotView)
                
        shareWindowView.setDimension(height: view.heightAnchor, hMult: 0.4)
        shareWindowView.anchor(right: view.rightAnchor, left: view.leftAnchor)
        shareWindowViewBottomConstraint = shareWindowView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 200)
        shareWindowViewBottomConstraint.isActive = true
        
        blueBorderLine.anchor(top: view.topAnchor, right: view.rightAnchor, left: view.leftAnchor)
        blueBorderLine.setDimension(hConst: 3)
    
        mapSnapshotView.setDimension(width: view.widthAnchor, height: view.widthAnchor, wMult: 0.8, hMult: 0.8)
        mapSnapshotView.center(to: view, by: .centerY, withMultiplierOf: 0.65)
        mapSnapshotView.center(to: view, by: .centerX)
        
        shareWindowView.addSubview(shareCollectionView)
        shareCollectionView.setDimension(width: shareWindowView.widthAnchor, height: shareWindowView.heightAnchor, wMult: 0.85, hMult: 0.65)
        shareCollectionView.center(to: shareWindowView, by: .centerX)
        shareCollectionView.center(to: shareWindowView, by: .centerY, withMultiplierOf: 1.15)
    }
    
    private func showActivityViewController() {
        guard let image = convertViewToImage() else { return }
        let avc = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        avc.popoverPresentationController?.sourceView = shareCollectionView
        present(avc, animated: true, completion: nil)
    }
    
    private func convertViewToImage() -> UIImage? {
        let side = view.frame.size.width * 0.8
        UIGraphicsBeginImageContextWithOptions(CGSize(width: side, height: side), mapSnapshotView.isOpaque, 0.0)
        defer { UIGraphicsEndImageContext() }
        mapSnapshotView.drawHierarchy(in: mapSnapshotView.bounds, afterScreenUpdates: true)
        return UIGraphicsGetImageFromCurrentImageContext()
    }
    
    private func saveToPhotoLibrary() {
        guard let image = convertViewToImage() else { return }
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    private func launchMessageComposeVC(image: UIImage) {
        if MFMessageComposeViewController.canSendText() {
            let messageVC = MFMessageComposeViewController()
            messageVC.messageComposeDelegate = self
            let imageData = image.pngData()
            messageVC.addAttachmentData(imageData!, typeIdentifier: "public.data", filename: "image.png")
            self.present(messageVC, animated: true, completion: nil)
        } else {
            debugPrint("User does not have the messages app.".localized())
        }
    }
    
    // MARK: - Selectors
    @objc func dismissShareVC() {
        UIView.animate(withDuration: 0.5) {
            self.shareWindowViewBottomConstraint.constant = 200
            self.view.layoutIfNeeded()
        }
        dismiss(animated: true, completion: nil)
    }
    
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            debugPrint(error)
            let ac = UIAlertController(title: "Save Error".localized(), message: error.localizedDescription, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK".localized(), style: .default, handler: nil))
            present(ac, animated: true)
        } else {
            let ac = UIAlertController(title: "Saved".localized(), message: "Your route snapshot has been downloaded to your photo library!".localized(), preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK".localized(), style: .default, handler: nil))
            present(ac, animated: true)
        }
    }
}

// MARK: - MessageComposeViewControllerDelegate
extension ShareViewController: MFMessageComposeViewControllerDelegate {
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - UICollectionView delegate/datasource/flowlayout
extension ShareViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return options.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ShareOptionCell.reuseId, for: indexPath) as! ShareOptionCell
        cell.shareOption = options[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let image = convertViewToImage() else { return }
        switch indexPath.item {
            case 0: launchMessageComposeVC(image: image)
            case 1: saveToPhotoLibrary()
            case 2: showActivityViewController()
            default: debugPrint("other")
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (view.frame.size.width * 0.85 / 3) - 10
        let height = (view.frame.size.height * 0.45 * 0.65 / 2)
        return CGSize(width: width, height: height)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

