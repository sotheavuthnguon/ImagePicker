import Foundation
import AVFoundation
import PhotosUI

protocol CameraManDelegate: class {
  func cameraManNotAvailable(_ cameraMan: CameraMan)
  func cameraManDidStart(_ cameraMan: CameraMan)
  func cameraMan(_ cameraMan: CameraMan, didChangeInput input: AVCaptureDeviceInput)
}

class CameraMan:NSObject {
  weak var delegate: CameraManDelegate?

  let session = AVCaptureSession()
  let queue = DispatchQueue(label: "no.hyper.ImagePicker.Camera.SessionQueue")

  var backCamera: AVCaptureDeviceInput?
  var frontCamera: AVCaptureDeviceInput?
  var audioDeviceInput: AVCaptureDeviceInput?
  var stillImageOutput: AVCaptureStillImageOutput?
  var startOnFrontCamera: Bool = false
  var stillVideoOutput: AVCaptureMovieFileOutput?
  var outputFileURLPath = ""
  var outputFileURL: URL?
 
  deinit {
    stop()
  }

  // MARK: - Setup

  func setup(_ startOnFrontCamera: Bool = false) {
    self.startOnFrontCamera = startOnFrontCamera
    checkPermission()
  }

  func setupDevices() {
    // Input
    AVCaptureDevice
    .devices()
    .filter {
      return $0.hasMediaType(AVMediaType.video)
    }.forEach {
      switch $0.position {
      case .front:
        self.frontCamera = try? AVCaptureDeviceInput(device: $0)
      case .back:
        self.backCamera = try? AVCaptureDeviceInput(device: $0)
      default:
        break
      }
    }
    
    if #available(iOS 10.0, *) {
        guard let audioDevice = AVCaptureDevice.default(.builtInMicrophone, for: AVMediaType.audio, position: .unspecified) else { return }
        self.audioDeviceInput = try? AVCaptureDeviceInput(device: audioDevice)
        guard let input = self.audioDeviceInput else { return }
        if session.canAddInput(input) {
            session.addInput(input)
        }
    }
  }
    
  func addInput(_ input: AVCaptureDeviceInput) {
    configurePreset(input)

    if session.canAddInput(input) {
      session.addInput(input)

      DispatchQueue.main.async {
        self.delegate?.cameraMan(self, didChangeInput: input)
      }
    }
  }

  // MARK: - Permission

  func checkPermission() {
    let status = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)

    switch status {
    case .authorized:
      start()
    case .notDetermined:
      requestPermission()
    default:
      delegate?.cameraManNotAvailable(self)
    }
  }

  func requestPermission() {
    AVCaptureDevice.requestAccess(for: AVMediaType.video) { granted in
      DispatchQueue.main.async {
        if granted {
          self.start()
        } else {
          self.delegate?.cameraManNotAvailable(self)
        }
      }
    }
  }

  // MARK: - Session

  var currentInput: AVCaptureDeviceInput? {
    for input in session.inputs {
        if (input as? AVCaptureDeviceInput) != self.audioDeviceInput {
            return input as? AVCaptureDeviceInput
        }
    }
    return nil
  }

  fileprivate func start() {
    // Devices
    setupDevices()
    
    guard let input = (self.startOnFrontCamera) ? frontCamera ?? backCamera : backCamera else { return }

    addInput(input)

    stillVideoOutput = AVCaptureMovieFileOutput()
      guard let outputVideo = self.stillVideoOutput else { return }
       if session.canAddOutput(outputVideo) {
         session.addOutput(outputVideo)
      }
    
    stillImageOutput = AVCaptureStillImageOutput()
    stillImageOutput?.outputSettings = [AVVideoCodecKey: AVVideoCodecJPEG]
    guard let outputImage = self.stillImageOutput else { return }
     if session.canAddOutput(outputImage) {
       session.addOutput(outputImage)
    }

    queue.async {
      self.session.startRunning()

      DispatchQueue.main.async {
        self.delegate?.cameraManDidStart(self)
      }
    }
  }
    
    func resume() {
        self.session.startRunning()
    }

  func stop() {
    self.session.stopRunning()
  }

  func switchCamera(_ completion: (() -> Void)? = nil) {
    guard let currentInput = currentInput
      else {
        completion?()
        return
    }

    queue.async {
      guard let input = (currentInput == self.backCamera) ? self.frontCamera : self.backCamera
        else {
          DispatchQueue.main.async {
            completion?()
          }
          return
      }

      self.configure {
        self.session.removeInput(currentInput)
        self.addInput(input)
      }

      DispatchQueue.main.async {
        completion?()
      }
    }
  }

  func takePhoto(_ previewLayer: AVCaptureVideoPreviewLayer, location: CLLocation?, completion: ((UIImage) -> Void)? = nil) {
    guard let connection =  stillImageOutput?.connection(with: AVMediaType.video) else { return }
    connection.videoOrientation = Helper.videoOrientation()
    if currentInput == frontCamera {
        connection.isVideoMirrored = true
    }
    queue.async {
      self.stillImageOutput?.captureStillImageAsynchronously(from: connection) { buffer, error in
        guard let buffer = buffer, error == nil && CMSampleBufferIsValid(buffer),
          let imageData = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(buffer),
          let image = UIImage(data: imageData),
          let safeCompletion = completion
          else {
//            DispatchQueue.main.async {
//              completion?(image)
//            }
            return
        }
        safeCompletion(image)
//        self.savePhoto(image, location: location, completion: completion)
      }
    }
  }
    
    func takeVideo(_ previewLayer: AVCaptureVideoPreviewLayer, location: CLLocation?, completion: (() -> Void)? = nil) {
        
      guard let outputVideo = self.stillVideoOutput else { return }
      guard let connection =  stillVideoOutput?.connection(with: AVMediaType.video) else { return }
      connection.videoOrientation = Helper.videoOrientation()
        if currentInput == frontCamera {
            connection.isVideoMirrored = true
        }
      queue.async {
        
          if outputVideo.isRecording {
              outputVideo.stopRecording()
          }else{
              let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
              let fileUrl = paths[0].appendingPathComponent("output.mov")
              outputVideo.startRecording(to: fileUrl, recordingDelegate: self)
          }
        }
    }
        
    
    func stopRecordingVideo(){
        guard  let outputVideo = self.stillVideoOutput else { return }
        outputVideo.stopRecording()
    }
    

  func savePhoto(_ image: UIImage, location: CLLocation?, completion: (() -> Void)? = nil) {
    PHPhotoLibrary.shared().performChanges({
      let request = PHAssetChangeRequest.creationRequestForAsset(from: image)
      request.creationDate = Date()
      request.location = location
      }, completionHandler: { (_, _) in
        DispatchQueue.main.async {
          completion?()
        }
    })
  }

  func flash(_ mode: AVCaptureDevice.FlashMode) {
    guard let device = currentInput?.device, device.isFlashModeSupported(mode) else { return }

    queue.async {
      self.lock {
        device.flashMode = mode
      }
    }
  }

  func focus(_ point: CGPoint) {
    guard let device = currentInput?.device, device.isFocusModeSupported(AVCaptureDevice.FocusMode.locked) else { return }

    queue.async {
      self.lock {
        device.focusPointOfInterest = point
      }
    }
  }

  func zoom(_ zoomFactor: CGFloat) {
    guard let device = currentInput?.device, device.position == .back else { return }

    queue.async {
      self.lock {
        device.videoZoomFactor = zoomFactor
      }
    }
  }

  // MARK: - Lock

  func lock(_ block: () -> Void) {
    if let device = currentInput?.device, (try? device.lockForConfiguration()) != nil {
      block()
      device.unlockForConfiguration()
    }
  }

  // MARK: - Configure
  func configure(_ block: () -> Void) {
    session.beginConfiguration()
    block()
    session.commitConfiguration()
  }

  // MARK: - Preset

  func configurePreset(_ input: AVCaptureDeviceInput) {
    for asset in preferredPresets() {
      if input.device.supportsSessionPreset(AVCaptureSession.Preset(rawValue: asset)) && self.session.canSetSessionPreset(AVCaptureSession.Preset(rawValue: asset)) {
        self.session.sessionPreset = AVCaptureSession.Preset(rawValue: asset)
        return
      }
    }
  }

  func preferredPresets() -> [String] {
    return [
      AVCaptureSession.Preset.high.rawValue,
      AVCaptureSession.Preset.high.rawValue,
      AVCaptureSession.Preset.low.rawValue
    ]
  }
}

extension CameraMan: AVCaptureFileOutputRecordingDelegate {
    func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
        if error == nil {
//            UISaveVideoAtPathToSavedPhotosAlbum(outputFileURL.path, nil, nil, nil)
//            outputFileURLPath = outputFileURL.path
            self.outputFileURL = outputFileURL
        }
    }
    
    
}

