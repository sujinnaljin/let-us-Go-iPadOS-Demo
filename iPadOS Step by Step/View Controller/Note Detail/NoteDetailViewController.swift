//
//  NoteDetailViewController.swift
//  iPadOS Step by Step
//
//  Created by BumMo Koo on 03/08/2019.
//  Copyright © 2019 BumMo Koo. All rights reserved.
//

import UIKit
import VisionKit // 알아서 네모로 잘라주는 것
import PencilKit
import MobileCoreServices
import SnapKit

class NoteDetailViewController: UIViewController {
    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var imageView: UIImageView!
    private lazy var canvasView = PKCanvasView()
    
    var note: Note?
    private var image : UIImage? {
        didSet {
            imageView.image = image
        }
    }
    
    // MARK: - View
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        loadCanvas()
        
    }
    
    private func setup() {
        view.backgroundColor = .secondarySystemBackground
        
        //canvas
        canvasView.backgroundColor = .clear
        canvasView.isOpaque = false
        canvasView.delegate = self
        canvasView.allowsFingerDrawing = true
        canvasView.tool = PKInkingTool(.pencil)
        
        containerView.addSubview(canvasView)
        canvasView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        //Tool
        let window = UIApplication.shared.windows.first! //아마 잘못되게 부르는 방법이지만 일단 이렇게 가져오는걸로
        let picker = PKToolPicker.shared(for: window)
        picker?.addObserver(canvasView)
        //canvasView가 firstResponder가 되었을때 나타나도록
        picker?.setVisible(true, forFirstResponder: canvasView)
        canvasView.becomeFirstResponder()
        
        //Drop
        let drop = UIDropInteraction(delegate: self)
        view.addInteraction(drop)
    }
    
    // MARK: - Action
    @IBAction
    private func tapped(clearCanvas button: UIBarButtonItem) {
        clearCanvas()
    }
    
    @IBAction
    private func tapped(document button: UIBarButtonItem) {
        presentDocumentPicker()
    }
    
    @IBAction
    private func tapped(scanner button: UIBarButtonItem) {
        presentDocumentScanner()
    }
    
    @IBAction
    private func tapped(photoLibrary button: UIBarButtonItem) {
        presentImagePicker()
    }
    
    @IBAction
    private func tapped(share button: UIBarButtonItem) {
        presentSharesheet(button)
    }
    
    // MARK: -
    private func presentDocumentPicker() {
        let picker = UIDocumentPickerViewController(documentTypes: [kUTTypeImage as String], in: .import)
        picker.delegate = self
        present(picker, animated: true)
    }
    
    private func presentDocumentScanner() {
        let scanner = VNDocumentCameraViewController()
        scanner.delegate = self
        present(scanner, animated: true)
    }
    
    private func presentImagePicker() {
        
    }
    
    private func presentSharesheet(_ sourceView: UIBarButtonItem? = nil) {
        
    }
    
    // MARK: - Canvas
    private func loadCanvas() {
        
    }
    
    private func saveCanvas() {
        
    }
    
    private func generateImage() -> UIImage? {
        return nil
    }
    
    private func clearCanvas() {
        
    }
}

// MARK: - Canvas
extension NoteDetailViewController: PKCanvasViewDelegate {
    
}

// MARK: - Drag & Drop
extension NoteDetailViewController: UIDropInteractionDelegate {
    //drop 받을 수 있는지 없는지
    func dropInteraction(_ interaction: UIDropInteraction, canHandle session: UIDropSession) -> Bool {
        return true
    }
    //drag하면서 위치 바뀔텐데 해당 위치에서 어떤 드롭 프로포절이 발생하는지 알려줌. 이동인지 복사인지 불가인지
    func dropInteraction(_ interaction: UIDropInteraction, sessionDidUpdate session: UIDropSession) -> UIDropProposal {
        return UIDropProposal(operation: .copy)
    }
    //실제 드롭 발생
    func dropInteraction(_ interaction: UIDropInteraction, performDrop session: UIDropSession) {
        session.loadObjects(ofClass: UIImage.self) { (items) in
            let images = items as! [UIImage]
            self.image = images.first
        }
    }
}

// MARK: - Documenet picker
extension NoteDetailViewController: UIDocumentPickerDelegate {
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        defer {
            dismiss(animated: true)
        }
        guard let url = urls.first else {return}
        guard let data = try? Data(contentsOf: url) else {return}
        guard let image = UIImage(data: data) else {return}
        self.image = image
    }
}

// MARK: - Document scanner
extension NoteDetailViewController: VNDocumentCameraViewControllerDelegate {
    func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFinishWith scan: VNDocumentCameraScan) {
        scan.imageOfPage(at: 0)
    }
    func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFailWithError error: Error) {
        print("error")
    }
    func documentCameraViewControllerDidCancel(_ controller: VNDocumentCameraViewController) {
        dismiss(animated: true)
    }
}

// MARK: - Image picker
extension NoteDetailViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true)
    }
}
