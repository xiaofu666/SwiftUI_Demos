//
//  LocationManager.swift
//  LocationSearch0422
//
//  Created by Lurich on 2022/4/22.
//

import SwiftUI
import CoreLocation
import MapKit

//使用combine去监测textfield的改变
import Combine


class LocationManager: NSObject, ObservableObject, MKMapViewDelegate, CLLocationManagerDelegate {
    
    @Published var mapView: MKMapView = .init()
    @Published var manager: CLLocationManager = .init()
    
    //搜索内容
    @Published var searchText: String = ""
    var cancellable: AnyCancellable?
    @Published var fetchedPlaces: [CLPlacemark]?
    
    //用户位置
    @Published var userLocation: CLLocation?
    
    //大头针移动后的位置
    @Published var pickedLocation: CLLocation?
    @Published var pickedPlaceMark: CLPlacemark?
    
    override init() {
        
        super.init()
        
        //设置代理
        manager.delegate = self
        mapView.delegate = self
        
        //请求定位访问
        manager.requestWhenInUseAuthorization()
        
        //combine 搜索文本输入监控
        cancellable = $searchText
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
            .removeDuplicates()
            .sink(receiveValue: { value in
                
                if value != "" {
                    
                    self.fetchPlaces(value: value)
                } else {
                    
                    self.fetchedPlaces = nil
                }
                
            })
    }
    
    func fetchPlaces(value: String) {
        
        //获取地名 使用  MKLocalSearch & Asyc/Await
        Task {
            
            do {
                
                let request = MKLocalSearch.Request()
                request.naturalLanguageQuery = value.lowercased()
                
                let response = try await MKLocalSearch(request: request).start()
                
                await MainActor.run(body: {
                    
                    self.fetchedPlaces = response.mapItems.compactMap({ item -> CLPlacemark? in
                        
                        return item.placemark
                    })
                })
                
            }
            catch {
                //处理错误
            }
        }
    }
    
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
        //处理错误
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        guard let currentLocation = locations.last else { return }
        self.userLocation = currentLocation
    }
    
    // 定位权限认证
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        
        switch manager.authorizationStatus {
            
        case .authorizedAlways: manager.requestLocation()
        case .authorizedWhenInUse: manager.requestLocation()
        case .denied: handleLocationError()
        case .notDetermined: manager.requestWhenInUseAuthorization()
        default: ()
        }
    }
    
    func handleLocationError() {
        
    }
    
    //添加可以移动的大头针
    func addDraggablePin(coordinate: CLLocationCoordinate2D) {
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = "Food will be delivered here"
        
        mapView.addAnnotation(annotation)

    }
    
    //大头针的拖动实现
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let marker = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: "DELIVERYRPIN")
        marker.isDraggable = true
        marker.canShowCallout = false
        
        return marker
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, didChange newState: MKAnnotationView.DragState, fromOldState oldState: MKAnnotationView.DragState) {
        
        guard let newLocation = view.annotation?.coordinate else {return}
        
        self.pickedLocation = .init(latitude: newLocation.latitude, longitude: newLocation.longitude)
        updatePlacemark(location: .init(latitude: newLocation.latitude, longitude: newLocation.longitude))
    }
    
    func updatePlacemark(location: CLLocation) {
        
        Task {
            
            do {
                
                guard let place = try await reverseLocationCoordinates(location: location) else {return}
                await MainActor.run(body: {
                    
                    print("+++++")
                    self.pickedPlaceMark = place
                })
            }
            catch let Error {
                
                print(Error.localizedDescription)
                print("-----")
            }
            
            
            
        }
    }
    
    //展示位置信息
    func reverseLocationCoordinates(location: CLLocation) async throws -> CLPlacemark? {
        
        let place = try await CLGeocoder().reverseGeocodeLocation(location).first
        print("+++++" + (place?.name ?? "------"))
        return place
    }
    
}

