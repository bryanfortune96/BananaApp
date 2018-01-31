//
//  MapTrafficDetailsViewController.swift
//  Banana
//
//  Created by TQM on 10/27/17.
//  Copyright © 2017 Minh Tran. All rights reserved.
//

import UIKit
import GoogleMaps
import Alamofire

class MapTrafficDetailsViewController: BaseViewController,GMSMapViewDelegate {

    @IBOutlet weak var distanceLb: UILabel!
    @IBOutlet weak var mapView: GMSMapView!
    var sourceCoor: CLLocationCoordinate2D?
    var destCoor: CLLocationCoordinate2D?
    var density: Int?
    var distance = ""
    {
        didSet{
            self.hideLoading()
            self.distanceLb.text = "Distance:  \(distance)"
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setupMap()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupMap()
    {
        // Create a GMSCameraPosition that tells the map to display the
        // coordinate -33.86,151.20 at zoom level 6.
        let latitude = ((sourceCoor?.latitude)! + (destCoor?.latitude)!)/2
        let longitude = ((sourceCoor?.longitude)! + (destCoor?.longitude)!)/2
        let camera = GMSCameraPosition.camera(withLatitude: (latitude),
                                              longitude: (longitude), zoom: 16.0)
        self.mapView.camera = camera
        mapView.delegate = self
        drawPolylineRoute(from: sourceCoor!, to: destCoor!, density: density!)
        
        
    }
    
    // Pass your source and destination coordinates in this method.
    func drawPolylineRoute(from source: CLLocationCoordinate2D, to destination: CLLocationCoordinate2D,density: Int){
        self.showLoading()
        let url = URL(string: "https://maps.googleapis.com/maps/api/directions/json?origin=\(source.latitude),\(source.longitude)&destination=\(destination.latitude),\(destination.longitude)&sensor=false&mode=driving&key=\(Strings.locationAPIKey)")!
        print("\(url)\n")
        Alamofire.request(url).responseJSON { response in
            print("Request: \(String(describing: response.request))\n")   // original url request
            print("Response: \(String(describing: response.response))\n") // http url response
            print("Result: \(response.result)\n")                         // response serialization result
            
            if let result = response.result.value {
                let json = result as! NSDictionary
                print(json)
                
                let routes = json["routes"] as? [Any]
                if routes?.count == 0
                {
                    return
                }
                else{
                    //find polyline in returned data to draw
                    let inside_routes = routes?[0] as? [String: Any]
                    let overview_polyline = inside_routes?["overview_polyline"] as?[String: String]
                    let polyString = overview_polyline?["points"]
                    
                    //Call this method to draw path on map
                    self.showPath(polyStr: polyString!,density: density)
                
                    //find distance in returned data to show
                    let legs = inside_routes?["legs"] as? [Any]
                    let inside_legs = legs?[0] as? [String: Any]
                    let distance = inside_legs?["distance"] as? [String: Any]
                    let distance_text = distance?["text"] as? String
                    self.distance = distance_text!
                }
                
            }
            
        }
    }
    
    func showPath(polyStr :String,density: Int){
        let path = GMSPath(fromEncodedPath: polyStr)
        let polyline = GMSPolyline(path: path)
        polyline.strokeWidth = 4.0
        switch density {
        case -1:
            polyline.strokeColor = UIColor.blue
        case 0:
            polyline.strokeColor = UIColor.green
        case 1:
            polyline.strokeColor = UIColor.yellow
        case 2:
            polyline.strokeColor = UIColor.orange
        case 3:
            polyline.strokeColor = UIColor.red
        case 4:
            polyline.strokeColor = UIColor.brown
        default:
            break
        }
        polyline.map = mapView
        
    }
    
    @IBAction func cancelPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
