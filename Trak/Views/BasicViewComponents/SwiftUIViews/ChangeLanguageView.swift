//
//  ChangeLanguageView.swift
//  TrackingApp
//
//  Created by William Yeung on 2/4/21.
//

import SwiftUI

struct ChangeLanguageView: View {
    // MARK: - Properties
    let deviceSize = UIScreen.main.bounds
    
    // MARK: - Body
    var body: some View {
        ScrollView(.vertical, showsIndicators: true) {
            VStack(alignment: .leading) {
                VStack(alignment: .leading) {
                    Text("How to Change App Language".localized())
                        .font(.custom("MADETommySoft-Bold", size: 28, relativeTo: .body))
                        .lineLimit(2)
                        .padding(.bottom, 5)
                    Group {
                        Text("Method 1: System-wide Change".localized())
                            .font(.custom("MADETommySoft-Medium", size: 16, relativeTo: .body))
                            .underline()
                        Text("1. Open the Settings App".localized())
                        Text("2. General -> Language & Region".localized())
                        Text("3. Change Preferred iPhone Language".localized())
                    }
                    .font(.custom("MADETommySoft-Light", size: 16, relativeTo: .body))
                    .padding(.top, 5)
                }
                .padding(.leading, 25)
                HStack {
                    Spacer()
                    Text("OR")
                        .font(.system(size: 16, weight: .black, design: .rounded))
                    Spacer()
                }
                .padding(.vertical, 15)
                VStack(alignment: .leading) {
                    Group {
                        Text("Method 2: App-only Change".localized())
                            .font(.custom("MADETommySoft-Medium", size: 16, relativeTo: .body))
                            .underline()
                        Text("1. Open the Settings App".localized())
                        Text("2. Scroll down until you find Trak".localized())
                        Text("3. Change the Preferred Language".localized())
                    }
                    .font(.custom("MADETommySoft-Light", size: 16, relativeTo: .body))
                    .padding(.bottom, 5)
                }
                .padding(.leading, 25)
                VStack(alignment: .leading) {
                    Text("Tip: Click shortcut link below".localized())
                        .lineLimit(2)
                        .font(.custom("MADETommySoft-Light", size: 12, relativeTo: .body))
                        .padding(.bottom, -1)
                    Button(action: { UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!) }) {
                        HStack {
                            Text("Open App Settings".localized())
                                .lineLimit(1)
                                .font(.custom("MADETommySoft-Medium", size: 16, relativeTo: .body))
                                .minimumScaleFactor(0.5)
                            Spacer()
                            Image(systemName: "arrow.up.forward.app")
                        }
                        .foregroundColor(Color("InvertedDarkMode"))
                        .padding(.horizontal, 10)
                    }
                    .frame(height: 40)
                    .background(Color("InvertedDarkMode").opacity(0.1))
                    .cornerRadius(10)
                }
                .padding([.trailing, .leading], 25)
                .padding(.top)
            }
            .padding(.vertical, 25)
        }
        .background(Color("StandardDarkMode"))
        .edgesIgnoringSafeArea(.vertical)
    }
}

// MARK: - Previews
struct ChangeLanguageView_Previews: PreviewProvider {
    static var previews: some View {
        ChangeLanguageView()
            .preferredColorScheme(.dark)
    }
}
