import UIKit

protocol BottomContainerViewDelegate: class {

  func pickerButtonDidPress()
  func doneButtonDidPress()
  func cancelButtonDidPress()
  func imageStackViewDidPress()
  func buttonDidLongPressBegan()
  func buttonDidLongPressEnded()
}

open class BottomContainerView: UIView {

  struct Dimensions {
    static let height: CGFloat = 101
  }

  var configuration = ImagePickerConfiguration()
  var centerXImageStackCountViewConstraint: NSLayoutConstraint!
  var centerYImageStackCountViewConstraint: NSLayoutConstraint!
    
  lazy var pickerButton: ButtonPicker = { [unowned self] in
    let pickerButton = ButtonPicker(configuration: self.configuration)
    pickerButton.setTitleColor(UIColor(red: 249/255, green: 161/255, blue: 27/255, alpha: 1), for: UIControl.State())
    pickerButton.delegate = self
    pickerButton.numberLabel.isHidden = !self.configuration.showsImageCountLabel

    return pickerButton
    }()

  lazy var borderPickerButton: UIView = {
    let view = UIView()
    view.backgroundColor = UIColor.clear
    view.layer.borderColor = UIColor(red: 249/255, green: 161/255, blue: 27/255, alpha: 1).cgColor // UIColor.white.cgColor
//    view.layer.borderColor = UIColor.white.cgColor
    view.layer.borderWidth = ButtonPicker.Dimensions.borderWidth
    view.layer.cornerRadius = ButtonPicker.Dimensions.buttonBorderSize / 2

    return view
    }()

    open lazy var imageStackCountLabel: UILabel = { [unowned self] in
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 10, weight: .bold)
        label.textColor = UIColor(red: 249/255, green: 161/255, blue: 27/255, alpha: 1)
        label.text = "0"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isHidden = true
        return label
    }()
    
    open lazy var imageStackCountView: UIView = { [unowned self] in
        let view = UIView()
        view.layer.cornerRadius = 13
        view.backgroundColor = (UIColor.black).withAlphaComponent(0.5)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = true
        return view
    }()
    
    open lazy var infoLable: UILabel = { [unowned self] in
      let label = UILabel()
      label.font = self.configuration.infoLabelFont
      label.textColor = .white
      label.textAlignment = .center
      label.text = "Hold for video and tap for photo"
      label.alpha = 0.5
      return label
      }()
    
  open lazy var doneButton: UIButton = { [unowned self] in
    let button = UIButton()
    button.setTitle(self.configuration.cancelButtonTitle, for: UIControl.State())
    button.titleLabel?.font = self.configuration.doneButton
    button.addTarget(self, action: #selector(doneButtonDidPress(_:)), for: .touchUpInside)

    return button
    }()

  lazy var stackView = ImageStackView(frame: CGRect(x: 0, y: 0, width: 80, height: 80))

  lazy var topSeparator: UIView = { [unowned self] in
    let view = UIView()
    view.backgroundColor = self.configuration.backgroundColor

    return view
    }()

  lazy var tapGestureRecognizer: UITapGestureRecognizer = { [unowned self] in
    let gesture = UITapGestureRecognizer()
    gesture.addTarget(self, action: #selector(handleTapGestureRecognizer(_:)))

    return gesture
    }()

  weak var delegate: BottomContainerViewDelegate?
  var pastCount = 0

  // MARK: Initializers

  public init(configuration: ImagePickerConfiguration? = nil) {
    if let configuration = configuration {
      self.configuration = configuration
    }
    super.init(frame: .zero)
    configure()
  }

  public required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func configure() {
    imageStackCountView.addSubview(imageStackCountLabel)
    
    [borderPickerButton, pickerButton, doneButton, stackView, topSeparator ,infoLable, imageStackCountView].forEach {
      addSubview($0)
      $0.translatesAutoresizingMaskIntoConstraints = false
    }

    backgroundColor = configuration.backgroundColor
    stackView.accessibilityLabel = "Image stack"
    stackView.addGestureRecognizer(tapGestureRecognizer)
    
    centerXImageStackCountViewConstraint = NSLayoutConstraint(item: imageStackCountView, attribute: .centerX, relatedBy: .equal, toItem: stackView, attribute: .centerX, multiplier: 1, constant: 0)
    
    centerYImageStackCountViewConstraint = NSLayoutConstraint(item: imageStackCountView, attribute: .centerY, relatedBy: .equal, toItem: stackView, attribute: .centerY, multiplier: 1, constant: 0)
    
    setupConstraints()
    if configuration.galleryOnly {
      borderPickerButton.isHidden = true
      pickerButton.isHidden = true
    }
    if !configuration.allowMultiplePhotoSelection {
      stackView.isHidden = true
    }
    
    stackView.isHidden = true
  }

    func updateImageStackCountView(count: Int) {
        UIView.animate(withDuration: 0.25) {
            self.imageStackCountLabel.text = "\(count)"
            self.imageStackCountLabel.isHidden = (count == 0)
            self.imageStackCountView.isHidden = (count == 0)
            self.stackView.isHidden = (count == 0)
            
            let step = (count > 4) ? 3 : count - 1
            
            self.centerXImageStackCountViewConstraint.constant = CGFloat(3 + (step * -3))
            self.centerYImageStackCountViewConstraint.constant = CGFloat(3 + (step * -3))
        }
        

    }
  // MARK: - Action methods

  @objc func doneButtonDidPress(_ button: UIButton) {
    if button.currentTitle == configuration.cancelButtonTitle {
      delegate?.cancelButtonDidPress()
    } else {
      delegate?.doneButtonDidPress()
    }
  }

  @objc func handleTapGestureRecognizer(_ recognizer: UITapGestureRecognizer) {
    delegate?.imageStackViewDidPress()
  }

  fileprivate func animateImageView(_ imageView: UIImageView) {
    imageView.transform = CGAffineTransform(scaleX: 0, y: 0)

    UIView.animate(withDuration: 0.3, animations: {
      imageView.transform = CGAffineTransform(scaleX: 1.05, y: 1.05)
      }, completion: { _ in
        UIView.animate(withDuration: 0.2, animations: {
          imageView.transform = CGAffineTransform.identity
        })
    })
  }
}

// MARK: - ButtonPickerDelegate methods

extension BottomContainerView: ButtonPickerDelegate {

  func buttonDidPress() {
    delegate?.pickerButtonDidPress()
  }
    
    func buttonDidLongPressBegan() {
        delegate?.buttonDidLongPressBegan()
    }
    
    func buttonDidLongPressEnded() {
        delegate?.buttonDidLongPressEnded()
    }
}

