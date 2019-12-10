//
//  ViewController.swift
//  showHowItsDone
//
//  Created by Brandon Tyson on 12/4/19.
//  Copyright © 2019 XE401. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {
    
    
    var audioPlayer = AVAudioPlayer()
    
    var music = false

    @IBOutlet var sceneView: ARSCNView!
    
    @IBAction func play(_ sender: Any) {
        if music == false{
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: URL.init(fileURLWithPath: Bundle.main.path(forResource: "Corps", ofType: "mp3")!))}
            catch {
                print("Problem")
            }
            audioPlayer.play()
            print("music playing")
            music = true
        }
        else {
            audioPlayer.pause()
            music = false
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tapped = UITapGestureRecognizer(target: self, action: #selector(taphandler(sender:)))
        
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(sender:)))
        rightSwipe.direction = .right
        
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(sender:)))
        leftSwipe.direction = .left
        
        let downSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(sender:)))
        downSwipe.direction = .down
        
        let upSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(sender:)))
        upSwipe.direction = .up
        
        view.addGestureRecognizer(rightSwipe)
        view.addGestureRecognizer(leftSwipe)
        view.addGestureRecognizer(upSwipe)
        view.addGestureRecognizer(downSwipe)
        view.addGestureRecognizer(tapped)

        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        // Create a new scene
        let scene = SCNScene(named: "art.scnassets/This.scn")!
        
        // Set the scene to the view
        sceneView.scene = scene
    }
    @objc func handleSwipe(sender: UISwipeGestureRecognizer){
        if sender.state == .ended{
            var x: Float = 0.0
            var y: Float = 0.0
            switch sender.direction{
            case .right:
                x += 0.5
            case .left:
                x -= 0.5
            case .down:
                y -= 0.5
            case .up:
                y += 0.5
            default:
                y = 0.0
                x = 0.0
            }
            for child in sceneView.scene.rootNode.childNodes{
                child.position = SCNVector3(child.position.x + x, child.position.y + y, child.position.z)
            }
        }
    }
    @objc func taphandler(sender: UITapGestureRecognizer){
        for child in sceneView.scene.rootNode.childNodes{
            if child.name != nil {
            print(child.name!)
            if child.name!.contains("_Bio"){
                child.geometry?.firstMaterial?.diffuse.contents = UIImage(named: "art.scnassets/" + child.name! + ".PNG")
                child.name = String(child.name!.dropLast(4))
            }
            else {
                child.geometry?.firstMaterial?.diffuse.contents = UIImage(named: "art.scnassets/" + child.name! + ".PNG")
                child.name = child.name! + "_Bio"
            }
        }
    }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .vertical

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }

    // MARK: - ARSCNViewDelegate
    
/*
    // Override to create and configure nodes for anchors added to the view's session.
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
     
        return node
    }
*/
    
    @IBAction func swipe(_ sender: Any) {
        for child in sceneView.scene.rootNode.childNodes{
            child.position = SCNVector3(child.position.x - 1, child.position.y, child.position.z )
        }
    }
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
}
