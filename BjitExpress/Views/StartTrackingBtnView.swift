//
//  StartTrackingBtnView.swift
//  BjitExpress
//
//  Created by Sadat Ahmed on 2023/05/19.
//

import SwiftUI

struct StartTrackingBtnView: View {
    var location: LocationViewModel

    var body: some View {
        Button {
            location.requestLocation()
            NetworkManager().calculateDuration()
        } label: {
            Text("Start")
                .foregroundColor(.white)
                .fontWeight(.medium)
                .frame(maxWidth: 250)
                .padding()
                .background(Color.accentColor)
                .cornerRadius(8)
        } //: BUTTON
        .padding()
        .background(.ultraThinMaterial)
    }
}

struct StartTrackingBtnView_Previews: PreviewProvider {
    static var previews: some View {
        StartTrackingBtnView(location: LocationViewModel())
            .preferredColorScheme(.dark)
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
