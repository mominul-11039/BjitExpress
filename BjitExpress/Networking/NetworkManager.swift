//
//  NetworkManager.swift
//  BjitExpress
//
//  Created by apple on 2023/05/19.
//

import Foundation
import CoreLocation

struct NetworkManager {
    let busReservationViewModel = BusReservationViewModel()
    
    init() {
        //        self.calculateDuration()
    }
    
    func calculateDuration() {
        let origin = "\(Constant.userLocation!.latitude),\(String(describing: Constant.userLocation!.latitude))"
        print(origin)
        let destination = "23.797530,90.423378"
        
        let apiKey = "AIzaSyCNBoNrWX5TuGtk64gPDdDbskKfbHgvpkM"
        
        guard let url = URL(string: "https://maps.googleapis.com/maps/api/directions/json?origin=\(origin)&destination=\(destination)&key=\(apiKey)") else {
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                return
            }
            
            guard let data = data else {
                return
            }
            
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                if let routes = json?["routes"] as? [[String: Any]], let route = routes.first, let legs = route["legs"] as? [[String: Any]], let leg = legs.first, let duration = leg["duration"] as? [String: Any], let durationText = duration["text"] as? String {
                    print(durationText)
                    let arrivalTime = extractArrivalTime(from: durationText)
                    //                    DispatchQueue.main.async {
                    //                        busReservationViewModel.bookSeat(busNo: 1, arrivalTime: arrivalTime)
                    //                    }
                }
                let arrivalTime = extractArrivalTime(from: "0 hours 20 mins")
                DispatchQueue.main.async {
                    busReservationViewModel.bookSeat(busNo: 0, arrivalTime: arrivalTime)
                }
            } catch {
                print("Error: \(error.localizedDescription)")
            }
        }.resume()
    }
    
    func extractArrivalTime(from durationText: String) -> (hour: Int, minute: Int) {
        let components = durationText.components(separatedBy: " ")
        if components.count >= 2 {
            let timeComponent = components[0]
            let timeParts = timeComponent.components(separatedBy: ":")
            if timeParts.count == 2, let hour = Int(timeParts[0]), let minute = Int(timeParts[1]) {
                return (hour: hour, minute: minute)
            }
        }
        // Return a default value if extraction fails
        return (hour: 0, minute: 0)
    }
}
