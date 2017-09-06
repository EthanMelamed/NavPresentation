//
//  ViewController.swift
//  EthansARApp
//
//  Created by Ethan  on 2017-08-05.
//  Copyright © 2017 Ethan . All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate, UIGestureRecognizerDelegate, SCNPhysicsContactDelegate, UIPopoverPresentationControllerDelegate {
    
    @IBOutlet var sceneView: ARSCNView!
    
    // A dictionary of all the current planes being rendered in the scene
    var planes: [UUID:Plane] = [:]
    var cubes: [Cube] = []
    var config = Config()
    var arConfig = ARWorldTrackingSessionConfiguration()
    var virtualObject: VirtualObject?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupScene()
        self.setupLights()
        self.setupPhysics()
        self.setupRecognizers()
        
        // Create a ARSession configuration object we can re-use
        self.arConfig = ARWorldTrackingSessionConfiguration()
        self.arConfig.isLightEstimationEnabled = true
        self.arConfig.planeDetection = ARWorldTrackingSessionConfiguration.PlaneDetection.horizontal
        
        let config = Config()
        config.showStatistics = false
        config.showWorldOrigin = true
        config.showFeaturePoints = true
        config.showPhysicsBodies = false
        config.detectPlanes = true
        self.config = config
        self.updateConfig()
        
        // Stop the screen from dimming while we are using the app
        UIApplication.shared.isIdleTimerDisabled = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        // Run the view's session
        self.sceneView.session.run(self.arConfig)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
    
    func setupScene() {
        // Setup the ARSCNViewDelegate - this gives us callbacks to handle new
        // geometry creation
        self.sceneView.delegate = self
        
        // A dictionary of all the current planes being rendered in the scene
        self.planes = [:]
        
        // A list of all the cubes being rendered in the scene
        self.cubes = []
        
        // Make things look pretty
        self.sceneView.antialiasingMode = SCNAntialiasingMode.multisampling4X
        
        // This is the object that we add all of our geometry to, if you want
        // to render something you need to add it here
        let scene = SCNScene()
        self.sceneView.scene = scene
    }
    
    func setupPhysics() {
        // For our physics interactions, we place a large node a couple of meters below the world
        // origin, after an explosion, if the geometry we added has fallen onto this surface which
        // is place way below all of the surfaces we would have detected via ARKit then we consider
        // this geometry to have fallen out of the world and remove it
        let bottomPlane = SCNBox(width: 1000, height: 0.5, length: 1000, chamferRadius: 0)
        let bottomMaterial = SCNMaterial()
        
        // Make it transparent so you can't see it
        bottomMaterial.diffuse.contents = UIColor(white: 1.0, alpha: 0)
        bottomPlane.materials = [bottomMaterial]
        let bottomNode = SCNNode(geometry: bottomPlane)
        
        // Place it way below the world origin to catch all falling cubes
        bottomNode.position = SCNVector3Make(0, -10, 0)
        bottomNode.physicsBody = SCNPhysicsBody(type: SCNPhysicsBodyType.kinematic, shape: nil)
        bottomNode.physicsBody?.categoryBitMask = CollisionCategory.bottom.rawValue
        bottomNode.physicsBody?.contactTestBitMask = CollisionCategory.cube.rawValue
        
        let scene = self.sceneView.scene
        scene.rootNode.addChildNode(bottomNode)
        scene.physicsWorld.contactDelegate = self
    }
    
    func setupLights() {
        // Turn off all the default lights SceneKit adds since we are handling it ourselves
        self.sceneView.autoenablesDefaultLighting = false
        self.sceneView.automaticallyUpdatesLighting = false
        
        let env = UIImage(named: "./Assets.scnassets/Environment/spherical.jpg")
        self.sceneView.scene.lightingEnvironment.contents = env
    }
    
    func setupRecognizers() {
        // Single tap will insert a new piece of geometry into the scene
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(insertCubeFrom))
        tapGestureRecognizer.numberOfTapsRequired = 1
        self.sceneView.addGestureRecognizer(tapGestureRecognizer)
        
        // Press and hold will open a config menu for the selected geometry
        let materialGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(geometryConfigFrom))
        materialGestureRecognizer.minimumPressDuration = 0.5
        self.sceneView.addGestureRecognizer(materialGestureRecognizer)
        
    }
    
    @objc func insertCubeFrom(recognizer: UITapGestureRecognizer) {
        // Take the screen space tap coordinates and pass them to the hitTest method on the ARSCNView instance
        let tapPoint = recognizer.location(in: self.sceneView)
        }
        
    }
    
    @objc func explodeFrom(recognizer: UITapGestureRecognizer) {
        }
        }
    }
    
    @objc func geometryConfigFrom(recognizer: UITapGestureRecognizer) {
        if recognizer.state != UIGestureRecognizerState.began {
            return
        }
        let holdPoint = recognizer.location(in: self.sceneView)
        let planeHit = self.sceneView.hitTest(holdPoint, types: ARHitTestResult.ResultType.existingPlaneUsingExtent)
        if planeHit.count == 0 {
            return
        }
        let plane = planes[(planeHit.first?.anchor?.identifier)!]
        plane?.changeMaterial();
        loadAirplane()
    }
    
    func hidePlanes() {
        for (planeID, _) in self.planes {
            self.planes[planeID]?.hide()
        }
    }
    
    func disableTracking(disabled: Bool) {
        // Stop detecting new planes or updating existing ones.
        
        if disabled {
            self.arConfig.planeDetection = ARWorldTrackingSessionConfiguration.PlaneDetection.init(rawValue: 0)
        } else {
            self.arConfig.planeDetection = ARWorldTrackingSessionConfiguration.PlaneDetection.horizontal
        }
        
        self.sceneView.session.run(self.arConfig)
    }
    
    func explode(hitResult: ARHitTestResult) {
        for cubeNode in self.cubes {
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Called just before we transition to the config screen
        let configController = segue.destination as? ConfigViewController
        
        // NOTE: I am using a popover so that we do't get the viewWillAppear method called when
        // we close the popover, if that gets called (like if you did a modal settings page), then
        // the session configuration is updated and we lose tracking. By default it shouldn't but
        // it still seems to.
        configController?.modalPresentationStyle = UIModalPresentationStyle.popover
        configController?.popoverPresentationController?.delegate = self
        configController?.config = self.config
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.none
    }
    
    @IBAction func settingsUnwind(segue: UIStoryboardSegue) {
        // Called after we navigate back from the config screen
        
        let configView = segue.source as! ConfigViewController
        let config = self.config
        
        config.showPhysicsBodies = configView.physicsBodies.isOn
        config.showFeaturePoints = configView.featurePoints.isOn
        config.showWorldOrigin = configView.worldOrigin.isOn
        config.showStatistics = configView.statistics.isOn
        self.updateConfig()
    }
    
    @IBAction func detectPlanesChanged(_ sender: Any) {
        let enabled = (sender as! UISwitch).isOn
        
        if enabled == self.config.detectPlanes {
            return
        }
        
        self.config.detectPlanes = enabled
        if enabled {
            self.disableTracking(disabled: false)
        } else {
            self.disableTracking(disabled: true)
        }
    }
    
    func updateConfig() {
        var opts = SCNDebugOptions.init(rawValue: 0)
        let config = self.config
        if (config.showWorldOrigin) {
            opts = [opts, ARSCNDebugOptions.showWorldOrigin]
        }
        if (config.showFeaturePoints) {
            opts = ARSCNDebugOptions.showFeaturePoints
        }
        if (config.showPhysicsBodies) {
            opts = [opts, SCNDebugOptions.showPhysicsShapes]
        }
        self.sceneView.debugOptions = opts
        if (config.showStatistics) {
            self.sceneView.showsStatistics = true
        } else {
            self.sceneView.showsStatistics = false
        }
    }
    
    // MARK: - SCNPhysicsContactDelegate
    
    func physicsWorld(_ world: SCNPhysicsWorld, didBegin contact: SCNPhysicsContact) {
        // Here we detect a collision between pieces of geometry in the world, if one of the pieces
        // of geometry is the bottom plane it means the geometry has fallen out of the world. just remove it
        guard let physicsBodyA = contact.nodeA.physicsBody, let physicsBodyB = contact.nodeB.physicsBody else {
            return
        }
        
        let categoryA = CollisionCategory.init(rawValue: physicsBodyA.categoryBitMask)
        let categoryB = CollisionCategory.init(rawValue: physicsBodyB.categoryBitMask)
        
        let contactMask: CollisionCategory? = [categoryA, categoryB]
        
        if contactMask == [CollisionCategory.bottom, CollisionCategory.cube] {
            if categoryA == CollisionCategory.bottom {
                contact.nodeB.removeFromParentNode()
            } else {
                contact.nodeA.removeFromParentNode()
            }
        }
    }
    
    // MARK: - ARSCNViewDelegate
    
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        guard let estimate = self.sceneView.session.currentFrame?.lightEstimate else {
            return
        }
        
        // A value of 1000 is considered neutral, lighting environment intensity normalizes
        // 1.0 to neutral so we need to scale the ambientIntensity value
        let intensity = estimate.ambientIntensity / 1000.0
        self.sceneView.scene.lightingEnvironment.intensity = intensity
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        if !anchor.isKind(of: ARPlaneAnchor.classForCoder()) {
            return
        }
        
        // When a new plane is detected we create a new SceneKit plane to visualize it in 3D
        let plane = Plane(anchor: anchor as! ARPlaneAnchor, isHidden: false, withMaterial: Plane.currentMaterial()!)
        plane.name = "plane_"+UUID.init().uuidString
        planes[anchor.identifier] = plane
        node.addChildNode(plane)
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        guard let plane = planes[anchor.identifier] else {
            return
        }
        
        // When an anchor is updated we need to also update our 3D geometry too. For example
        // the width and height of the plane detection may have changed so we need to update
        // our SceneKit geometry to match that
        plane.update(anchor: anchor as! ARPlaneAnchor)
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didRemove node: SCNNode, for anchor: ARAnchor) {
        // Nodes will be removed if planes multiple individual planes that are detected to all be
        // part of a larger plane are merged.
        self.planes.removeValue(forKey: anchor.identifier)
    }
    
    func loadAirplane(plane: Plane? = nil) {
        
        // Load the airplane model asynchronously.
        DispatchQueue.global().async {
            let object = VirtualObject.availableObjects[0]
            object.viewController = self
            self.virtualObject = object
            
            object.loadModel()
            
            //set the airplanes position
            DispatchQueue.main.async {
                if plane != nil {
                    //add the airplane to the plane
                }
                else{
                    self.setNewAirplanePosition(SCNVector3Zero)
                }
            }
        }
    }
}
