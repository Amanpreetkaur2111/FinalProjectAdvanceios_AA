//
//  RouteViewController.swift
//  FinalProjectAdvanceios
//
//  Created by Amanpreet Kaur on 2020-01-27.
//  Copyright © 2020 Amanpreet Kaur. All rights reserved.
//

import UIKit
import MapKit

class RouteViewController: UIViewController,MKMapViewDelegate, CLLocationManagerDelegate {
    
    @IBOutlet var mapView: MKMapView!
    
    @IBOutlet var routeBtn: UIButton!
   var coordinate: CLLocationCoordinate2D!
    var locationManager = CLLocationManager()
    
    
    var latit : CLLocationDegrees = 0.0
    var longi: CLLocationDegrees = 0.0

    override func viewDidLoad() {
        super.viewDidLoad()

        
        
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        // Do any additional setup after loading the view.
        coordinate = CLLocationCoordinate2D(latitude: latit, longitude: longi)
        
        mapView.delegate = self
        
        mapView.setRegion(MKCoordinateRegion(center: CLLocationCoordinate2DMake(43.7733, -79.3359), span: MKCoordinateSpan(latitudeDelta: 1, longitudeDelta: 1)), animated: true)
        print(mapView.annotations.count)
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        print(coordinate.latitude)
        print(coordinate.longitude)
        mapView.addAnnotation(annotation)
        print(mapView.annotations.count)
        
    }
    
    
    @IBAction func RouteAction(_ sender: Any) {
        
    show_Direction(destination: coordinate, type:  .automobile)
        
}
    
    
    func show_Direction(destination: CLLocationCoordinate2D, type: MKDirectionsTransportType){
        
        if destination != nil  {
        
    let sourceCoordinate = mapView.annotations[0].coordinate
    let destinationCoordinate = mapView.annotations[1].coordinate
        
        let sourcePlacemark = MKPlacemark(coordinate: sourceCoordinate)
        let destinationPlacemark = MKPlacemark(coordinate: destinationCoordinate)
        
        let sourceItem = MKMapItem(placemark: sourcePlacemark)
        let destItem = MKMapItem(placemark: destinationPlacemark)
        
        let request = MKDirections.Request()
        request.source = sourceItem
        request.destination = destItem
        request.transportType = .automobile
        
        let direction = MKDirections(request: request)
        direction.calculate {(respons , error) in
            
        guard let respons = respons else {
        if let error = error {
                    
                    print("Something went Wrong")
                }
                return
            }
            
            let route = respons.routes[0]
            print(route)
            self.mapView.addOverlay(route.polyline)
        }
        } else {
            
        }
       
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
           if overlay is MKPolyline {
                let rendrer = MKPolylineRenderer(overlay: overlay)
               rendrer.strokeColor = .orange
               rendrer.lineWidth = 5.0
               return rendrer
               }
           
           return MKOverlayRenderer()
       }
    
    
    
    
    
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    
    
    
    
    
    
    
    
    
}
