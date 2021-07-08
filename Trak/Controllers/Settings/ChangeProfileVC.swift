//
//  ChangeProfileVC.swift
//  TrackingApp
//
//  Created by William Yeung on 1/12/21.
//

import UIKit
import SwiftUI

class ChangeProfileVC: UIViewController {
    // MARK: - Views
    let moreActionsLauncher = MoreActionsLauncher()
    
    private let headerLabel = UILabel.createHeaderLabel(withTitle: "Tap to Edit".localized(), andFont: UIFont.medium25)
    
    private lazy var profileImageButton: UIButton = {
        let btn = UIButton(type: .custom)
        btn.contentMode = .scaleAspectFill
        let largeConfig = UIImage.SymbolConfiguration(font: UIFont.systemFont(ofSize: 130))
        btn.setImage(UIImage(systemName: "person.circle", withConfiguration: largeConfig), for: .normal)
        btn.clipsToBounds = true
        btn.addTarget(self, action: #selector(openOptionsMenu), for: .touchUpInside)
        return btn
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.lineBreakMode = .byTruncatingTail
        label.textAlignment = .center
        label.textColor = UIColor.InvertedDarkMode
        label.adjustsFontForContentSizeCategory = true
        label.font = UIFontMetrics(forTextStyle: .body).scaledFont(for: UIFont.bold24!)
        label.isUserInteractionEnabled = true
        label.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(editName)))
        return label
    }()
    
    private let bottomView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.addBlurBackground(withStyle: .systemUltraThinMaterial)
        view.layer.cornerRadius = 15
        view.clipsToBounds = true
        return view
    }()
    
    private let totalStatsView = UIHostingController(rootView: TotalStatsView())
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        layoutViews()
        animateHeaderLabel()
        setupImage()
        setupName()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        view.layer.removeAllAnimations()
    }
    
    // MARK: - Helpers
    private func configureUI() {
        view.backgroundColor = UIColor.StandardDarkMode
        configureSmallNavBar(withTitle: "Profile".localized())
    }
    
    private func animateHeaderLabel() {
        headerLabel.alpha = 0.25
        UIView.animate(withDuration: 1, delay: 0, options: [.repeat, .autoreverse, .beginFromCurrentState]) {
            self.headerLabel.alpha = 1
        }
    }
    
    private func layoutViews() {
        view.addSubviews(headerLabel, profileImageButton, nameLabel, totalStatsView.view)
        
        headerLabel.center(to: view, by: .centerX)
        headerLabel.center(to: view, by: .centerY, withMultiplierOf: 0.225)
        
        profileImageButton.setDimension(width: view.widthAnchor, height: view.widthAnchor, wMult: 0.35, hMult: 0.35)
        profileImageButton.center(to: view, by: .centerX)
        profileImageButton.center(to: view, by: .centerY, withMultiplierOf: UIScreen.main.bounds.height < 600 ? 0.65 : 0.7)
        profileImageButton.layer.cornerRadius = UIScreen.main.bounds.width * 0.35 / 2
        
        nameLabel.center(to: view, by: .centerX)
        nameLabel.anchor(top: profileImageButton.bottomAnchor, paddingTop: 15)
        nameLabel.setDimension(width: view.widthAnchor, wMult: 1)
        
        addChild(totalStatsView)
        totalStatsView.didMove(toParent: self)
        totalStatsView.view.center(to: view, by: .centerX)
        totalStatsView.view.center(to: view, by: .centerY, withMultiplierOf: 1.55)
        totalStatsView.view.setDimension(width: view.widthAnchor)
    }
    
    private func setupName() {
        guard let name = UserDefaults.standard.string(forKey: nameUDKey) else { nameLabel.text = "Your Name".localized(); return }
        nameLabel.text = name
    }
    
    private func setupImage() {
        guard let imageData = UserDefaults.standard.data(forKey: imageUDKey) else {
            return
        }
        profileImageButton.setImage(UIImage(data: imageData)?.withRenderingMode(.alwaysOriginal), for: .normal)
    }
    
    private func saveImage(_ image: UIImage) {
        if let imageData = image.jpegData(compressionQuality: 0.5) {
            UserDefaults.standard.setValue(imageData, forKey: imageUDKey)
            NotificationCenter.default.post(name: Notification.Name.didChangeImage, object: nil, userInfo: ["newImage": imageData])
        }
    }
    
    func showViewForAction(action: UIImagePickerController.SourceType) {
        switch action.rawValue {
        case 0:
            openCameraSelection(forSelection: .photoLibrary)
        case 1:
            openCameraSelection(forSelection: .camera)
        default:
            break
        }
    }
    
    private func openCameraSelection(forSelection selection: UIImagePickerController.SourceType) {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.sourceType = selection
        picker.delegate = self
        present(picker, animated: true, completion: nil)
    }
    
    // MARK: - Selector
    @objc func openOptionsMenu() {
        moreActionsLauncher.changeProfileVC = self
        moreActionsLauncher.showMoreActionsMenu()
    }
    
    @objc func editName() {
        var nameTextField: UITextField?
        
        let changeNameAlert = UIAlertController(title: "Edit Name".localized(), message: nil, preferredStyle: .alert)
        changeNameAlert.addTextField { (tf) in
            nameTextField = tf
            tf.text = self.nameLabel.text
        }
        changeNameAlert.addAction(UIAlertAction(title: "Save".localized(), style: .default, handler: { (action) in
            self.nameLabel.text = nameTextField?.text ?? ""
            UserDefaults.standard.setValue(nameTextField?.text, forKey: nameUDKey)
            NotificationCenter.default.post(name: Notification.Name.didChangeName, object: nil, userInfo: ["newName": nameTextField?.text ?? "Unknown"])
        }))
        changeNameAlert.addAction(UIAlertAction(title: "Cancel".localized(), style: .cancel, handler: nil))
        present(changeNameAlert, animated: true)
    }
}

// MARK: - ImagePickerController/NavigationController Delegate
extension ChangeProfileVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let selectedImage = info[.editedImage] as? UIImage else { return }
        profileImageButton.setImage(selectedImage.withRenderingMode(.alwaysOriginal), for: .normal)
        dismiss(animated: true, completion: nil)
        saveImage(selectedImage)
    }
}
