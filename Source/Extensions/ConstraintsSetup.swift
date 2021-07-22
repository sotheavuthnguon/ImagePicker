import UIKit

// MARK: - BottomContainer autolayout

extension BottomContainerView {

  func setupConstraints() {
    
    addConstraint(NSLayoutConstraint(item: imageStackCountLabel, attribute: .centerY, relatedBy: .equal, toItem: imageStackCountView, attribute: .centerY, multiplier: 1, constant: 0))
    
    addConstraint(NSLayoutConstraint(item: imageStackCountLabel, attribute: .centerX, relatedBy: .equal, toItem: imageStackCountView, attribute: .centerX, multiplier: 1, constant: 0))
    
    addConstraint(NSLayoutConstraint(item: imageStackCountView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1, constant: 26))
    
    addConstraint(NSLayoutConstraint(item: imageStackCountView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: 26))
    
    addConstraint(centerXImageStackCountViewConstraint)
    
    addConstraint(centerYImageStackCountViewConstraint)
    
    for attribute: NSLayoutConstraint.Attribute in [.centerX] {
      addConstraint(NSLayoutConstraint(item: pickerButton, attribute: attribute,
        relatedBy: .equal, toItem: self, attribute: attribute,
        multiplier: 1, constant: 0))

      addConstraint(NSLayoutConstraint(item: borderPickerButton, attribute: attribute,
        relatedBy: .equal, toItem: self, attribute: attribute,
        multiplier: 1, constant: 0))
        
    }
    
    for attribute: NSLayoutConstraint.Attribute in [.centerY] {
      addConstraint(NSLayoutConstraint(item: pickerButton, attribute: attribute,
        relatedBy: .equal, toItem: self, attribute: attribute,
        multiplier: 1, constant: -15))

      addConstraint(NSLayoutConstraint(item: borderPickerButton, attribute: attribute,
        relatedBy: .equal, toItem: self, attribute: attribute,
        multiplier: 1, constant: -15))
        
    }

    for attribute: NSLayoutConstraint.Attribute in [.width, .left, .top] {
      addConstraint(NSLayoutConstraint(item: topSeparator, attribute: attribute,
        relatedBy: .equal, toItem: self, attribute: attribute,
        multiplier: 1, constant: 0))
    }

    for attribute: NSLayoutConstraint.Attribute in [.width, .height] {
      addConstraint(NSLayoutConstraint(item: pickerButton, attribute: attribute,
        relatedBy: .equal, toItem: nil, attribute: .notAnAttribute,
        multiplier: 1, constant: ButtonPicker.Dimensions.buttonSize))

      addConstraint(NSLayoutConstraint(item: borderPickerButton, attribute: attribute,
        relatedBy: .equal, toItem: nil, attribute: .notAnAttribute,
        multiplier: 1, constant: ButtonPicker.Dimensions.buttonBorderSize))

      addConstraint(NSLayoutConstraint(item: stackView, attribute: attribute,
        relatedBy: .equal, toItem: nil, attribute: .notAnAttribute,
        multiplier: 1, constant: ImageStackView.Dimensions.imageSize))
    }

    addConstraint(NSLayoutConstraint(item: doneButton, attribute: .centerY,
      relatedBy: .equal, toItem: self, attribute: .centerY,
      multiplier: 1, constant: -10))

    addConstraint(NSLayoutConstraint(item: infoLable, attribute: .centerY,
      relatedBy: .equal, toItem: self, attribute: .centerY,
      multiplier: 1, constant: 35))

    
    addConstraint(NSLayoutConstraint(item: stackView, attribute: .centerY,
      relatedBy: .equal, toItem: self, attribute: .centerY,
      multiplier: 1, constant: -18))

    let screenSize = Helper.screenSizeForOrientation()

    addConstraint(NSLayoutConstraint(item: doneButton, attribute: .centerX,
      relatedBy: .equal, toItem: self, attribute: .right,
      multiplier: 1, constant: -(screenSize.width - (ButtonPicker.Dimensions.buttonBorderSize + screenSize.width)/2)/2))
    
    addConstraint(NSLayoutConstraint(item: infoLable, attribute: .centerX,
      relatedBy: .equal, toItem: self, attribute: .centerX,
      multiplier: 1, constant: 0))

    addConstraint(NSLayoutConstraint(item: stackView, attribute: .centerX,
      relatedBy: .equal, toItem: self, attribute: .left,
      multiplier: 1, constant: screenSize.width/4 - ButtonPicker.Dimensions.buttonBorderSize/3))

    addConstraint(NSLayoutConstraint(item: topSeparator, attribute: .height,
      relatedBy: .equal, toItem: nil, attribute: .notAnAttribute,
      multiplier: 1, constant: 1))
  }
}

// MARK: - TopView autolayout

extension TopView {

  func setupConstraints() {

    addConstraint(NSLayoutConstraint(item: backButton, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1, constant: 7))
    
    addConstraint(NSLayoutConstraint(item: backButton, attribute: .centerY,
      relatedBy: .equal, toItem: self, attribute: .centerY,
      multiplier: 1, constant: 20))

    addConstraint(NSLayoutConstraint(item: backButton, attribute: .width,
      relatedBy: .equal, toItem: nil, attribute: .notAnAttribute,
      multiplier: 1, constant: 55))
    
    addConstraint(NSLayoutConstraint(item: timeLable, attribute: .centerX,
      relatedBy: .equal, toItem: self, attribute: .centerX,
      multiplier: 1, constant: 0))

    addConstraint(NSLayoutConstraint(item: timeLable, attribute: .centerY,
      relatedBy: .equal, toItem: self, attribute: .centerY,
      multiplier: 1, constant: 20))

    addConstraint(NSLayoutConstraint(item: timeLable, attribute: .width,
      relatedBy: .equal, toItem: nil, attribute: .notAnAttribute,
      multiplier: 1, constant: 200))
    
    addConstraint(NSLayoutConstraint(item: flashButton, attribute: .right,
      relatedBy: .equal, toItem: rotateCamera, attribute: .left,
      multiplier: 1, constant: -5))

    addConstraint(NSLayoutConstraint(item: flashButton, attribute: .centerY,
      relatedBy: .equal, toItem: self, attribute: .centerY,
      multiplier: 1, constant: 20))

    addConstraint(NSLayoutConstraint(item: flashButton, attribute: .width,
      relatedBy: .equal, toItem: nil, attribute: .notAnAttribute,
      multiplier: 1, constant: 55))

    if configuration.canRotateCamera {
      addConstraint(NSLayoutConstraint(item: rotateCamera, attribute: .right,
        relatedBy: .equal, toItem: self, attribute: .right,
        multiplier: 1, constant: -Dimensions.rightOffset))

      addConstraint(NSLayoutConstraint(item: rotateCamera, attribute: .centerY,
        relatedBy: .equal, toItem: self, attribute: .centerY,
        multiplier: 1, constant: 20))

      addConstraint(NSLayoutConstraint(item: rotateCamera, attribute: .width,
        relatedBy: .equal, toItem: nil, attribute: .notAnAttribute,
        multiplier: 1, constant: 55))

      addConstraint(NSLayoutConstraint(item: rotateCamera, attribute: .height,
        relatedBy: .equal, toItem: nil, attribute: .notAnAttribute,
        multiplier: 1, constant: 55))
    }
  }
}

// MARK: - Controller autolayout

extension ImagePickerController {

  func setupConstraints() {
    let attributes: [NSLayoutConstraint.Attribute] = [.bottom, .right, .width]
    let topViewAttributes: [NSLayoutConstraint.Attribute] = [.left, .width]

    for attribute in attributes {
      view.addConstraint(NSLayoutConstraint(item: bottomContainer, attribute: attribute,
        relatedBy: .equal, toItem: view, attribute: attribute,
        multiplier: 1, constant: 0))
    }
    
    if configuration.galleryOnly {
      
      for attribute: NSLayoutConstraint.Attribute in [.left, .right] {
        view.addConstraint(NSLayoutConstraint(item: galleryView, attribute: attribute,
          relatedBy: .equal, toItem: view, attribute: attribute,
          multiplier: 1, constant: 0))
      }
      let bottomHeightPadding: CGFloat
      if #available(iOS 11.0, *) {
        view.addConstraint(NSLayoutConstraint(item: galleryView, attribute: .top,
                                              relatedBy: .equal, toItem: view.safeAreaLayoutGuide,
                                              attribute: .top,
                                              multiplier: 1, constant: 0))
        bottomHeightPadding = UIApplication.shared.keyWindow!.safeAreaInsets.bottom
      } else {
        view.addConstraint(NSLayoutConstraint(item: galleryView, attribute: .top,
                                              relatedBy: .equal, toItem: view,
                                              attribute: .top,
                                              multiplier: 1, constant: 0))
        bottomHeightPadding = 0
      }
      view.addConstraint(NSLayoutConstraint(item: galleryView, attribute: .height,
        relatedBy: .equal, toItem: view, attribute: .height,
        multiplier: 1, constant: -(BottomContainerView.Dimensions.height + bottomHeightPadding)))
      
    } else {
      
      for attribute: NSLayoutConstraint.Attribute in [.left, .top, .width] {
        view.addConstraint(NSLayoutConstraint(item: cameraController.view!, attribute: attribute,
          relatedBy: .equal, toItem: view, attribute: attribute,
          multiplier: 1, constant: 0))
      }

      for attribute in topViewAttributes {
        view.addConstraint(NSLayoutConstraint(item: topView, attribute: attribute,
          relatedBy: .equal, toItem: self.view, attribute: attribute,
          multiplier: 1, constant: 0))
      }
      
      if #available(iOS 11.0, *) {
        let window = UIApplication.shared.keyWindow
        let topPadding = window?.safeAreaInsets.top
        view.addConstraint(NSLayoutConstraint(item: topView, attribute: .top,
                                              relatedBy: .equal, toItem: view.safeAreaLayoutGuide,
                                              attribute: .top,
                                              multiplier: 1, constant: topPadding == 0 ? -20 : -50))
      } else {
        view.addConstraint(NSLayoutConstraint(item: topView, attribute: .top,
                                              relatedBy: .equal, toItem: view,
                                              attribute: .top,
                                              multiplier: 1, constant: 0))
      }
      
      view.addConstraint(NSLayoutConstraint(item: topView, attribute: .height,
        relatedBy: .equal, toItem: nil, attribute: .notAnAttribute,
        multiplier: 1, constant: TopView.Dimensions.height))

      view.addConstraint(NSLayoutConstraint(item: cameraController.view!, attribute: .height,
        relatedBy: .equal, toItem: view, attribute: .height,
        multiplier: 1, constant: -BottomContainerView.Dimensions.height))
    }
    
    if #available(iOS 11.0, *) {
      let heightPadding = UIApplication.shared.keyWindow!.safeAreaInsets.bottom
      view.addConstraint(NSLayoutConstraint(item: bottomContainer, attribute: .height,
                                            relatedBy: .equal, toItem: nil,
                                            attribute: .notAnAttribute,
                                            multiplier: 1,
                                            constant: BottomContainerView.Dimensions.height + heightPadding))
    } else {
      view.addConstraint(NSLayoutConstraint(item: bottomContainer, attribute: .height,
                                            relatedBy: .equal, toItem: nil,
                                            attribute: .notAnAttribute,
                                            multiplier: 1,
                                            constant: BottomContainerView.Dimensions.height))
    }
  }
}

extension ImageGalleryViewCell {

  func setupConstraints() {

    for attribute: NSLayoutConstraint.Attribute in [.width, .height, .centerX, .centerY] {
      addConstraint(NSLayoutConstraint(item: imageView, attribute: attribute,
        relatedBy: .equal, toItem: self, attribute: attribute,
        multiplier: 1, constant: 0))

      addConstraint(NSLayoutConstraint(item: selectedImageView, attribute: attribute,
        relatedBy: .equal, toItem: self, attribute: attribute,
        multiplier: 1, constant: 0))
    }
  }
}

extension ButtonPicker {

  func setupConstraints() {
    let attributes: [NSLayoutConstraint.Attribute] = [.centerX, .centerY]

    for attribute in attributes {
      addConstraint(NSLayoutConstraint(item: numberLabel, attribute: attribute,
        relatedBy: .equal, toItem: self, attribute: attribute,
        multiplier: 1, constant: 0))
    }
  }
}

