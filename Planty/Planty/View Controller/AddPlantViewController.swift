//
//  AddPlantViewController.swift
//  Planty
//
//  Created by Craig Belinfante on 12/28/20.
//

import UIKit
import AVFoundation

class AddPlantViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var plantName: UITextField!
    @IBOutlet weak var plantImageView: UIImageView!
    @IBOutlet weak var plantImage: UIButton!
    @IBOutlet weak var audioNote: UIButton!
    @IBOutlet weak var plantType: UIButton!
    @IBOutlet weak var plantWaterDate: UIButton!
    
    var currentImage: UIImage!
    var plantController = PlantController()
    var waterDateVC = WaterDateViewController()
    var plantTypeVC = PlantTypeViewController()
    
    var recordingURL: URL?
    var audioRecorder: AVAudioRecorder?
    var audioPlayer: AVAudioPlayer? {
        didSet {
            guard let audioPlayer = audioPlayer else { return }
            
            audioPlayer.delegate = self
            audioPlayer.isMeteringEnabled = true
            updateAudioViews()
        }
    }
    var isRecording: Bool {
        audioRecorder?.isRecording ?? false
    }
    var isPlaying: Bool {
        audioPlayer?.isPlaying ?? false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Actions
    @IBAction func addPhotoButton(_ sender: UIButton) {
        let picker = UIImagePickerController()
                  picker.allowsEditing = true
                  picker.delegate = self
                  present(picker, animated: true)
    }
    
    @IBAction func savePlant(_ sender: UIBarButtonItem) {
        
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "WaterDate" {
            guard let dateVC = segue.destination as? WaterDateViewController else { return }
            dateVC.popoverPresentationController?.delegate = self
            dateVC.presentationController?.delegate = self
        } else if segue.identifier == "PlantType" {
            guard let dateVC = segue.destination as? PlantTypeViewController else { return }
            dateVC.popoverPresentationController?.delegate = self
            dateVC.presentationController?.delegate = self
        }
    }
    
    func updateWaterDateLabel() {
        plantWaterDate.titleLabel?.text = "test"
    }
    
    func updateAudioViews() {
        audioNote.isEnabled = !isPlaying
        audioNote.isSelected = isRecording
    }
    
    func startRecording() {
        do {
            try prepareAudioSession()
        } catch {
            print("Cannot record audio: \(error)")
            return
        }
        
        recordingURL = createNewAudioRecordingURL()
        
        let format = AVAudioFormat(standardFormatWithSampleRate: 44_100, channels: 1)!
        
        do {
            audioRecorder = try AVAudioRecorder(url: recordingURL!, format: format)
            audioRecorder?.delegate = self
            audioRecorder?.isMeteringEnabled = true
            audioRecorder?.record()
           // updateAudioViews()
        } catch {
            preconditionFailure("The audio recorder could not be created with \(recordingURL!) and \(format)")
        }
    }
    
    func play() {
        do {
            try prepareAudioSession()
            audioPlayer?.play()
            updateAudioViews()
        } catch {
            print("Cannot play audio: \(error)")
        }
    }
    
    func pause() {
        audioPlayer?.pause()
        updateAudioViews()
    }
    
    func stopRecording() {
        audioRecorder?.stop()
        updateAudioViews()
    }
    
    func prepareAudioSession() throws {
        let session = AVAudioSession.sharedInstance()
        try session.setCategory(.playAndRecord, options: [.defaultToSpeaker])
        try session.setActive(true, options: [])
    }
    
    func createNewAudioRecordingURL() -> URL {
        let documents = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        
        let name = ISO8601DateFormatter.string(from: Date(), timeZone: .current, formatOptions: .withInternetDateTime)
        let file = documents.appendingPathComponent(name, isDirectory: false).appendingPathExtension("caf")
        
        print("recording URL: \(file)")
        
        return file
    }
    
    func newVideoRecordingURL(fileTitle: String) -> URL {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let url = documentsDirectory.appendingPathComponent(fileTitle).appendingPathExtension("mp3")
        return url
    }
    
    func requestPermissionOrStartRecording() {
        switch AVAudioSession.sharedInstance().recordPermission {
        case .undetermined:
            AVAudioSession.sharedInstance().requestRecordPermission { granted in
                guard granted == true else {
                    print("We need microphone access")
                    return
                }
                
                print("Recording permission has been granted!")
                // NOTE: Invite the user to tap record again, since we just interrupted them, and they may not have been ready to record
            }
        case .denied:
            print("Microphone access has been blocked.")
            
            let alertController = UIAlertController(title: "Microphone Access Denied", message: "Please allow this app to access your Microphone.", preferredStyle: .alert)
            
            alertController.addAction(UIAlertAction(title: "Open Settings", style: .default) { (_) in
                UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
            })
            
            alertController.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
            
            present(alertController, animated: true, completion: nil)
        case .granted:
            startRecording()
        @unknown default:
            break
        }
    }
    
    @IBAction func toggleAudioButton(_ sender: UIButton) {
        if isRecording {
            stopRecording()
        } else {
            requestPermissionOrStartRecording()
        }
    }
}

extension AddPlantViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }
        plantImageView.image = image
        dismiss(animated: true)
        currentImage = image
    }
}

extension AddPlantViewController: UIPopoverPresentationControllerDelegate {
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
}

extension AddPlantViewController: UIAdaptivePresentationControllerDelegate {
    func presentationControllerWillDismiss(_ presentationController: UIPresentationController) {
        updateWaterDateLabel()
    }
}

extension AddPlantViewController: AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        updateAudioViews()
    }
    func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?) {
        if let error = error {
            print("Audio Player Error: \(error)")
        }
    }
}

extension AddPlantViewController: AVAudioRecorderDelegate {
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if let recordingURL = recordingURL {
            audioPlayer = try? AVAudioPlayer(contentsOf: recordingURL)
        }
        recordingURL = nil
    }
    func audioRecorderEncodeErrorDidOccur(_ recorder: AVAudioRecorder, error: Error?) {
        if let error = error {
            print("Audio Recorder Error: \(error)")
        }
    }
}

