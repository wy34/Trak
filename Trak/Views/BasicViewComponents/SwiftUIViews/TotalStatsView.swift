//
//  StatsNumbersView.swift
//  TrackingApp
//
//  Created by William Yeung on 2/2/21.
//

import SwiftUI

struct TotalStatsView: View {
    // MARK: - Properties
    let coreDataManager = CoreDataManager.shared
    
    // MARK: - Body
    var body: some View {
        let totalDistance = getActivityStats().totalDistance
        let activityCount = getActivityStats().count
        let activitiesPerformed = getActivityStats().activities
        
        VStack(alignment: .leading) {
            Spacer()
            Divider()
                .background(Color("InvertedDarkMode"))
                .padding([.leading, .trailing], 45)
            Text("Total Statistics".localized())
                .font(.custom("MADETommySoft-Medium", size: 20, relativeTo: .body))
                .padding([.top, .trailing])
                .padding(.leading, 45)
                .padding(.top, -10)
            HStack {
                HStack {
                    Image("distance")
                        .renderingMode(.template)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 18, height: 18)
                        .padding(.trailing, 5)
                    VStack(alignment: .leading, spacing: 0) {
                        HStack(alignment: .firstTextBaseline, spacing: 2) {
                            Text("\(totalDistance, specifier: "%.2f")")
                                .font(.custom("MADETommySoft-Regular", size: 20, relativeTo: .body))
                            Text(" mi")
                                .font(.custom("MADETommySoft-Regular", size: 10, relativeTo: .body))
                        }
                        Text("Distance".localized())
                            .foregroundColor(.gray)
                            .font(.custom("MADETommySoft-Light", size: 12, relativeTo: .body))
                    }
                }
                Spacer()
                HStack {
                    Image(systemName: "chart.bar.xaxis")
                        .renderingMode(.template)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 18, height: 18)
                        .padding(.trailing, 5)
                    VStack(alignment: .leading, spacing: 0) {
                        HStack(alignment: .firstTextBaseline, spacing: 2) {
                            Text("\(activityCount)")
                                .font(.custom("MADETommySoft-Regular", size: 20, relativeTo: .body))
                        }
                        Text(activityCount == 1 ? "Activity".localized() : "Activities".localized())
                            .foregroundColor(.gray)
                            .font(.custom("MADETommySoft-Light", size: 12, relativeTo: .body))
                        
                    }
                }
                Spacer()
            }
                .padding(.top, 0)
                .padding(.bottom, 15)
                .padding([.leading], 45)
            VStack(alignment: .leading) {
                Text("Activities Performed".localized())
                    .font(.custom("MADETommySoft-Medium", size: 12, relativeTo: .body))
                    .foregroundColor(.gray)
                    .padding(.bottom, 1)
                HStack {
                    ForEach(activitiesPerformed, id: \.self) { item in
                        Text("\(item)")
                            .font(.custom("MADETommySoft-Regular", size: 18, relativeTo: .body))
                    }
                }
            }
                .padding(.trailing)
                .padding(.top, 8)
                .padding(.leading, 45)
            Spacer()
        }
            .background(Color.clear)
            .ignoresSafeArea(.keyboard, edges: .bottom)
    }
    
    // MARK: - Helpers
    func getActivityStats() -> (totalDistance: Double, count: Int, activities: [String]) {
        let allActivities = coreDataManager.fetchActivities()
        var totalDistanceMiles = 0.0
        var activitiesPerformed = [String]()
        
        for activity in allActivities {
            let activeDistanceMiles = (activity.distance * 0.000621371).roundDownToPlace(2)
            let pausedDistanceMiles = (activity.pausedDistance * 0.000621371).roundDownToPlace(2)
            totalDistanceMiles += (activeDistanceMiles + pausedDistanceMiles)
            
            let activitySessionViewModel = ActivitySessionViewModel(activity)
            if !activitiesPerformed.contains(activitySessionViewModel.typeIcon) {
                activitiesPerformed.append(activitySessionViewModel.typeIcon)
            }
        }
        return (totalDistanceMiles, allActivities.count, allActivities.isEmpty ? ["-"] : activitiesPerformed)
    }
}

// MARK: - Preview
struct TotalStatsView_Previews: PreviewProvider {
    static var previews: some View {
        TotalStatsView().preferredColorScheme(.dark)
    }
}
