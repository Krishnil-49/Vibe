//
//  ViewController.swift
//  Vibe
//
//  Created by Krishnil Bhojani on 11/04/20.
//  Copyright © 2020 Krishnil Bhojani. All rights reserved.
//

import UIKit
import AudioToolbox

class HomeViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    fileprivate let cellID = "PatternCell"
    
    let defaults = UserDefaults.standard
    
    var indexPathForSelectedItems = [IndexPath]()
    
    var timer: Timer?
    var localTimer: Timer?
     
    var willRepeat: Bool = false
    
    let intervalControllerLabel: UILabel = {
        let label = UILabel()
        label.text = "Interval Controllers"
        label.font = UIFont.systemFont(ofSize: 24)
        return label
    }()
    
    let repeatButton: ToggleButton = {
        let button = ToggleButton(type: .system)
        button.setImage(UIImage(named: "repeat.slash")?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.backgroundColor = .clear
        button.tintColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        button.heightAnchor.constraint(equalToConstant: 30).isActive = true
        button.widthAnchor.constraint(equalToConstant: 30).isActive = true
        button.addTarget(self, action: #selector(handleRepeat), for: .touchUpInside)
        return button
    }()
    
    let repeatInfoButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "info.circle.fill"), for: .normal)
        button.tag = 0
        button.tintColor = #colorLiteral(red: 0.5254901961, green: 0, blue: 0.8784313725, alpha: 1)
        button.heightAnchor.constraint(equalToConstant: 30).isActive = true
        button.widthAnchor.constraint(equalToConstant: 30).isActive = true
        button.addTarget(self, action: #selector(handleInfo), for: .touchUpInside)
        return button
    }()
    
    let vibrationModeLabel: UILabel = {
        let label = UILabel()
        label.text = "Vibration Mode"
        label.textColor = .darkGray
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    let vibrationModeSegmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl()
        segmentedControl.selectedSegmentTintColor = #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)
        segmentedControl.backgroundColor = .white
        segmentedControl.insertSegment(withTitle: "Light", at: 0, animated: true)
        segmentedControl.insertSegment(withTitle: "Medium", at: 1, animated: true)
        segmentedControl.insertSegment(withTitle: "Heavy", at: 2, animated: true)
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.addTarget(self, action: #selector(handleVibrationMode), for: .valueChanged)
        return segmentedControl
    }()
    
    let pauseIntervalLabel: UILabel = {
        let label = UILabel()
        label.text = "Pause Interval"
        label.textColor = .darkGray
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    let pauseIntervalSlider: UISlider = {
        let slider = UISlider()
        slider.minimumValueImage = UIImage(systemName: "minus")
        slider.maximumValueImage = UIImage(systemName: "plus")
        slider.tintColor = #colorLiteral(red: 0.5254901961, green: 0, blue: 0.8784313725, alpha: 1)
        slider.minimumValue = 20
        slider.maximumValue = 1000
        slider.addTarget(self, action: #selector(handleSlider), for: .valueChanged)
        return slider
    }()
    
    let pauseTimeLabel: UILabel = {
        let label = UILabel()
        label.text = "500ms"
        label.textAlignment = .center
        label.textColor = .lightGray
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    let patternMakerLabel: UILabel = {
        let label = UILabel()
        label.text = "Pattern Maker"
        label.font = UIFont.systemFont(ofSize: 24)
        return label
    }()
    
    let patternMakerInfoButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "info.circle.fill"), for: .normal)
        button.tintColor = #colorLiteral(red: 0.5254901961, green: 0, blue: 0.8784313725, alpha: 1)
        button.tag = 1
        button.heightAnchor.constraint(equalToConstant: 30).isActive = true
        button.widthAnchor.constraint(equalToConstant: 30).isActive = true
        button.addTarget(self, action: #selector(handleInfo), for: .touchUpInside)
        return button
    }()
    
    let patternCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = #colorLiteral(red: 0.5254901961, green: 0, blue: 0.8784313725, alpha: 1)
        collectionView.allowsMultipleSelection = true
        return collectionView
    }()
    
    let runButton: ToggleButton = {
        let button = ToggleButton()
        button.onTitle = "Stop"
        button.offTitle = "Run"
        button.setTitle("Run", for: .normal)
        button.layer.cornerRadius = 10
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(handleRun), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
//            #colorLiteral(red: 0.831372549, green: 0.9725490196, blue: 0.9098039216, alpha: 1)
        
        loadDefaults()
        
//        //Remove this ASAP
//        let indexPath1 = IndexPath(row: 0, section: 0)
//        indexPathForSelectedItems.append(indexPath1)
//        let indexPath2 = IndexPath(row: 1, section: 0)
//        indexPathForSelectedItems.append(indexPath2)
        
        title = "Your Pattern"
        patternCollectionView.dataSource = self
        patternCollectionView.delegate = self
        patternCollectionView.register(PatternCell.self, forCellWithReuseIdentifier: cellID)
        
        setUpNavigationBar()
        setUpViews()
    }

    fileprivate func setUpNavigationBar(){
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.5254901961, green: 0, blue: 0.8784313725, alpha: 1)
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        
        let lockImage = UIImage(named: "lock")
        let saveImage = UIImage(named: "save")
        
        let lockButton = UIBarButtonItem(image: lockImage, style: .plain, target: self, action: #selector(handleLock))
        let saveButton = UIBarButtonItem(image: saveImage, style: .plain, target: self, action: #selector(handleSave))
        
        navigationItem.leftBarButtonItem = lockButton
        navigationItem.rightBarButtonItem = saveButton
    }
    
    fileprivate func setUpViews(){
        view.addSubview(vibrationModeLabel)
        view.addSubview(vibrationModeSegmentedControl)
        view.addSubview(pauseIntervalLabel)
        view.addSubview(pauseIntervalSlider)
        view.addSubview(pauseTimeLabel)
        view.addSubview(patternCollectionView)
        view.addSubview(runButton)
        
        if repeatButton.isOn {
            repeatButton.setImage(UIImage(named: "repeat"), for: .normal)
            repeatButton.tintColor = #colorLiteral(red: 0.5254901961, green: 0, blue: 0.8784313725, alpha: 1)
        }else{
            repeatButton.setImage(UIImage(named: "repeat.slash"), for: .normal)
        }
        
        let intervalControllersStackView = UIStackView(arrangedSubviews: [intervalControllerLabel, repeatButton, repeatInfoButton])
        intervalControllersStackView.translatesAutoresizingMaskIntoConstraints = false
//        intervalControllersStackView.distribution = .fillProportionally
//        intervalControllersStackView.spacing = 5
        view.addSubview(intervalControllersStackView)
        
        let patternMakerStackView = UIStackView(arrangedSubviews: [patternMakerLabel, patternMakerInfoButton])
        patternMakerStackView.translatesAutoresizingMaskIntoConstraints = false
//        patternMakerStackView.spacing = 5
//        patternMakerStackView.distribution = .fillProportionally
        view.addSubview(patternMakerStackView)
        
        let space = (view.frame.height * 4.5)/300
        
        view.addConstraintsWithFormat(format: "H:|-12-[v0]-12-|", views: intervalControllersStackView)
        
        view.addConstraintsWithFormat(format: "H:|-16-[v0]-16-|", views: vibrationModeLabel)
        
        view.addConstraintsWithFormat(format: "H:|-16-[v0]-16-|", views: vibrationModeSegmentedControl)
        
        view.addConstraintsWithFormat(format: "H:|-16-[v0]-16-|", views: pauseIntervalLabel)
        
        view.addConstraintsWithFormat(format: "H:|-16-[v0]-16-|", views: pauseIntervalSlider)
        
        view.addConstraintsWithFormat(format: "H:|-16-[v0]-16-|", views: pauseTimeLabel)
        
        view.addConstraintsWithFormat(format: "H:|-12-[v0]-12-|", views: patternMakerStackView)
        
        view.addConstraintsWithFormat(format: "H:|-25-[v0]-25-|", views: runButton)
        
        // Leaving a padding of size equivalent to width of one cell so 1+9+1 = 11
        let cellSize = view.frame.width/11
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-\(cellSize)-[v0]-\(cellSize)-|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["v0" : patternCollectionView]))
        
        print("space: ",space)
        view.addConstraintsWithFormat(format: "V:|-\(space*3)-[v0]-\(space*2)-[v1]-\(space)-[v2]-\(space*2)-[v3]-\(space)-[v4]-\(space/2)-[v5]-\(space*3)-[v6]-\(space*2)-[v7(\(cellSize*3))]-\(space*6)-[v8(50)]", views: intervalControllersStackView, vibrationModeLabel, vibrationModeSegmentedControl, pauseIntervalLabel, pauseIntervalSlider, pauseTimeLabel, patternMakerStackView, patternCollectionView, runButton)
        
        print(view.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 27
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! PatternCell
        
        if indexPathForSelectedItems.contains(indexPath) {
            collectionView.selectItem(at: indexPath, animated: false, scrollPosition: .top)
            cell.toggleSelectedState()
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if !indexPathForSelectedItems.contains(indexPath){
            let cell = collectionView.cellForItem(at: indexPath) as! PatternCell
            cell.toggleSelectedState()
            
            indexPathForSelectedItems.append(indexPath)
            indexPathForSelectedItems = indexPathForSelectedItems.sorted()
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
        if indexPathForSelectedItems.contains(indexPath){
            let cell = collectionView.cellForItem(at: indexPath) as! PatternCell
            cell.toggleSelectedState()
            
            indexPathForSelectedItems = indexPathForSelectedItems.filter{ $0 != indexPath}
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let constant = collectionView.frame.width/9
        return .init(width: constant, height: constant)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    @objc func handleLock(){
        let lockVC = CustomLockViewController()
        lockVC.modalTransitionStyle = .crossDissolve
        lockVC.modalPresentationStyle = .overCurrentContext
        
        present(lockVC, animated: true, completion: nil)
    }
    
    @objc func handleSave(){
        
        defaults.set(vibrationModeSegmentedControl.selectedSegmentIndex, forKey: "vibrationMode")
        defaults.set(Int(pauseIntervalSlider.value), forKey: "pauseInterval")
        defaults.set(repeatButton.isOn, forKey: "willRepeat")

        var selectedIndexArray = [Int]()

        if let indexPath = patternCollectionView.indexPathsForSelectedItems {
            let array = indexPath.sorted()
            print("Items Saved:",array)
            for index in array.indices {
                selectedIndexArray.append(array[index].row)
            }
        }

        defaults.set(selectedIndexArray, forKey: "selectedIndexArray")
        
        showAlert(with: "Saved Successfully!", and: "Your pattern is saved successfully.")
    }
    
    func loadDefaults(){
        
        let vibrationMode = defaults.integer(forKey: "vibrationMode")
        let pauseInterval = defaults.integer(forKey: "pauseInterval")
        let willRepeat = defaults.bool(forKey: "willRepeat")
        
        if willRepeat {
            repeatButton.sendActions(for: .touchUpInside)
        }
        vibrationModeSegmentedControl.selectedSegmentIndex = vibrationMode
        pauseIntervalSlider.setValue(Float(pauseInterval), animated: false)
        handleSlider()
        
        if let selectedItemsArray = defaults.array(forKey: "selectedIndexArray") as? [Int]{
            let array = selectedItemsArray.sorted()
            for index in array{
                let indexPath = IndexPath(row: index, section: 0)
                indexPathForSelectedItems.append(indexPath)
            }
        }
        indexPathForSelectedItems.sort()
    }
    
    @objc func handleRepeat(sender: ToggleButton){
        
        if sender.isOn{
            willRepeat = true
            sender.tintColor = #colorLiteral(red: 0.5254901961, green: 0, blue: 0.8784313725, alpha: 1)
            sender.setImage(UIImage(named: "repeat")?.withRenderingMode(.alwaysTemplate), for: .normal)
        }else{
            willRepeat = false
            sender.tintColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
            sender.setImage(UIImage(named: "repeat.slash")?.withRenderingMode(.alwaysTemplate), for: .normal)
        }
        
    }
    
    @objc func handleInfo(sender: UIButton){
        let repeatInfo = "Tap to enable or disable. Enable, to repeat pattern continuously."
        let patternMakerInfo = "Tap to add or remove points. A grid with points will vibrate and if a grid is empty it doesn't."
        var message = ""
        
        if sender.tag == 0{
            message = repeatInfo
        }else if sender.tag == 1{
            message = patternMakerInfo
        }
        
        showAlert(with: "Help", and: message)
        
    }
    
    @objc func handleVibrationMode(){
        print(vibrationModeSegmentedControl.selectedSegmentIndex)
    }
    
    @objc func handleSlider(){
        let sliderValue = Int(pauseIntervalSlider.value)
        pauseTimeLabel.text = "\(sliderValue)ms"
    }
    
    @objc func handleRun(sender: ToggleButton){
        if sender.isOn {
            timer = Timer.scheduledTimer(timeInterval: TimeInterval(pauseIntervalSlider.value/1000), target: self, selector: #selector(handleTimer), userInfo: nil, repeats: true)
        }else{
            timer?.invalidate()
            resetCollectionView()
        }
    }
    
    var index = 0
    
    @objc func handleTimer(){
        
        let indexPath = IndexPath(row: index, section: 0)
        let cell = patternCollectionView.cellForItem(at: indexPath) as! PatternCell
        cell.separatorView.backgroundColor = #colorLiteral(red: 0.9725490196, green: 0.8823529412, blue: 0.9568627451, alpha: 1)
        
        if indexPathForSelectedItems.contains(indexPath){
            print("Vibrate")
            AudioServicesDisposeSystemSoundID(kSystemSoundID_Vibrate)
        }else{
            print("Not Vibrate")
        }
        
        index += 1
        
        if repeatButton.isOn && index == 27{
            resetCollectionView()
        }else if repeatButton.isOn == false && index == 27{
            resetCollectionView()
            runButton.sendActions(for: .touchUpInside)
        }
        
    }
    
    func resetCollectionView(){
        index = 0
        for index in 0...26{
            let localIndexPath = IndexPath(row: index, section: 0)
            let cell = patternCollectionView.cellForItem(at: localIndexPath) as! PatternCell
            cell.separatorView.backgroundColor = .white
        }
    }
    
    func showAlert(with title: String, and message: String){
        let attributedTitle = NSMutableAttributedString(string: title, attributes: [NSAttributedString.Key.foregroundColor : #colorLiteral(red: 0.5254901961, green: 0, blue: 0.8784313725, alpha: 1)])
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.setValue(attributedTitle, forKey: "attributedTitle")
        alert.view.tintColor = #colorLiteral(red: 0.5254901961, green: 0, blue: 0.8784313725, alpha: 1)
        
        let dismissAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        
        alert.addAction(dismissAction)
        
        present(alert, animated: true, completion: nil)
    }
    
}

extension UIView {
    func addConstraintsWithFormat(format: String, views: UIView...){
        
        var viewsDict = [String: UIView]()
        
        for (index, view) in views.enumerated(){
            view.translatesAutoresizingMaskIntoConstraints = false
            viewsDict["v\(index)"] = view
        }
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: viewsDict))
        
    }
}
