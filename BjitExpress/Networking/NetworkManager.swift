//
//  NetworkManager.swift
//  BjitExpress
//
//  Created by apple on 2023/05/19.
//

import Foundation
import CoreLocation
import MapKit

struct NetworkManager {
    let busReservationViewModel = BusReservationViewModel.shared
    
    init() {
    }
    
    func calculateDuration() {
        let origin = "\(Constant.userLocation!.latitude),\(String(describing: Constant.userLocation!.longitude))"
        print(origin)
        let currentLocation = CLLocation(latitude: Constant.userLocation!.latitude,
                                         longitude: Constant.userLocation!.longitude)
        let destinationLocation = CLLocation(latitude: 23.797530,
                                     longitude: 90.423378)
        let destination = "23.797530,90.423378"

        let apiKey = "AIzaSyCNBoNrWX5TuGtk64gPDdDbskKfbHgvpkM"

        guard let url = URL(string: "https://maps.googleapis.com/maps/api/directions/json?origin=\(origin)&destination=\(destination)&key=\(apiKey)") else {
            seatAllocation(currentLocation: currentLocation, destinationLocation: destinationLocation)
            return
        }

        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                seatAllocation(currentLocation: currentLocation, destinationLocation: destinationLocation)
                return
            }

            guard let data = data else {
                seatAllocation(currentLocation: currentLocation, destinationLocation: destinationLocation)
                return
            }

            do {
                let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                if let routes = json?["routes"] as? [[String: Any]], let route = routes.first, let legs = route["legs"] as? [[String: Any]], let leg = legs.first, let duration = leg["duration"] as? [String: Any], let durationText = duration["text"] as? String {
                    print(durationText)
                    let arrivalTime = extractArrivalTime(from: durationText)
                    DispatchQueue.main.async {
                        busReservationViewModel.bookSeat(busNo: 0, arrivalTime: arrivalTime)
                    }
                }
            } catch {
                seatAllocation(currentLocation: currentLocation, destinationLocation: destinationLocation)
                print("Error: \(error.localizedDescription)")
            }
        }.resume()
    }
    
    func extractArrivalTime(from durationText: String) -> (hour: Int, minute: Int) {
        let components = durationText.components(separatedBy: " ")
        if components.count == 2 {
            let min = Int(components[0]) ?? 0
            return (hour: 0, minute: min)
        } else if components.count == 4{
            let hour = Int(components[0]) ?? 0
            let min = Int(components[2]) ?? 0
            return (hour: hour, minute: min)
        }
        // Return a default value if extraction fails
        return (hour: 0, minute: 0)
    }

    private func seatAllocation(currentLocation: CLLocation, destinationLocation: CLLocation) {
        let distance = currentLocation.distance(from: destinationLocation)
        let time = Int((distance / 1000) * 3)
        let hour = Int(time / 60)
        let min = time % 60
        let arrivalTime = extractArrivalTime(from: "\(hour) hours \(min) mins")
        DispatchQueue.main.async {
            busReservationViewModel.bookSeat(busNo: 1, arrivalTime: arrivalTime)
        }
    }
}
