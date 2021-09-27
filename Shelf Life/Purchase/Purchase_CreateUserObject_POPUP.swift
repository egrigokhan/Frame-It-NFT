//
//  Purchase_CreateUserObject_POPUP.swift
//  Shelf Life
//
//  Created by Gokhan Egri on 6.07.2021.
//

import SwiftUI
import StoreKit

struct Purchase_CreateUserObject_POPUP: View {
    var title: String
    var message: String
    var buttonText: String
    @Binding var show: Bool

    var body: some View {
        ZStack {
            if show {
                Color.init("text").opacity(show ? 0.3 : 0).edgesIgnoringSafeArea(.all)                // PopUp Window
                ZStack {
                    Color.init("background")
                    VStack(alignment: .center, spacing: 0) {
                        Text("Create your own objects")
                            .frame(maxWidth: .infinity)
                            .frame(alignment: .center)
                            .font(Font.system(size: 18, weight: .bold))

                        Text("With a one-time purchase of only $0.99, you can turn your own, real-life objects into pixel-art and place them on your screen! You can even make stickers out of your photos for a more personal experience.")
                            .multilineTextAlignment(.center)
                            .font(Font.system(size: 12, weight: .regular))
                            .padding(EdgeInsets(top: 16, leading: 8, bottom: 8, trailing: 8))
                        
                        /*
                        Text("You can also share Shelf-Life on your socials to get some FREE passes!")
                            .bold()
                            .multilineTextAlignment(.center)
                            .font(Font.system(size: 12, weight: .regular))
                            .padding(EdgeInsets(top: 16, leading: 8, bottom: 8, trailing: 8))
                        */
                        
                        TabView {
                            ForEach(1..<3) { i in
                                ZStack {
                                    Color.init(UIColor.init(named: "light-background")!)
                                    HStack {
                                            Image("sl_p_" + String(i))
                                                .interpolation(.none)
                                                .resizable()
                                                .scaledToFit()
                                    }
                                }
                                .clipShape(RoundedRectangle(cornerRadius: 10.0, style: .continuous))
                            }
                            .padding(16)
                        }
                        .frame(height: 300)
                        .tabViewStyle(PageTabViewStyle())

                        Button(action: {
                            Purchase_CreateUserObject().buy()
                        }, label: {
                            HStack {
                                Text("Buy ($0.99)")
                                    .frame(maxWidth: .infinity, alignment: .center)
                                    .font(Font.system(size: 16, weight: .bold))
                                    .padding(EdgeInsets.init(top: 8, leading: 8, bottom: 8, trailing: 8))
                            }
                        }).buttonStyle(PlainButtonStyle())
                        .background(Color.init("light-background"))
                        .padding(EdgeInsets.init(top: 4, leading: 8, bottom: 4, trailing: 8))
                        .cornerRadius(12)
                        
                        Button(action: {
                            Purchase_CreateUserObject().restorePurchases()
                        }, label: {
                            HStack {
                                Text("Already got it, restore my purchase")
                                    .frame(maxWidth: .infinity, alignment: .center)
                                    .font(Font.system(size: 16, weight: .regular))
                                    .padding(EdgeInsets.init(top: 8, leading: 8, bottom: 8, trailing: 8))
                            }
                        }).buttonStyle(PlainButtonStyle())
                        .background(Color.init("light-background"))
                        .padding(EdgeInsets.init(top: 4, leading: 8, bottom: 4, trailing: 8))
                        .cornerRadius(12)
                        
                        Button(action: {
                            let av = UIActivityViewController(activityItems: ["Check out Shelf-Life to liven up your phone screen, available on the iOS App Store! #shelflife", URL(string: "https://apps.apple.com/us/app/shelf-life/id1574161725")], applicationActivities: nil)
                            
                            av.completionWithItemsHandler = {(activityType: UIActivity.ActivityType?, completed: Bool, returnedItems: [Any]?, error: Error?) in
                                
                                if !completed {
                                    // User canceled
                                    return
                                }
                                // User completed activity
                                if (activityType == UIActivity.ActivityType.postToTwitter || activityType == UIActivity.ActivityType.postToFacebook) {
                                    Purchase_CreateUserObject().addTrials()
                                }
                            }

                            
                                UIApplication.shared.windows.first?.rootViewController?.present(av, animated: true, completion: nil)
                        }, label: {
                            HStack {
                                Text("Share Shelf-Life on Twitter or Facebook to get a free trial")
                                    .multilineTextAlignment(TextAlignment.center)
                                    .frame(maxWidth: .infinity, alignment: .center)
                                    .font(Font.system(size: 16, weight: .regular))
                                    .padding(EdgeInsets.init(top: 8, leading: 8, bottom: 8, trailing: 8))
                            }
                        }).buttonStyle(PlainButtonStyle())
                        .background(Color.init("light-background"))
                        .padding(EdgeInsets.init(top: 4, leading: 8, bottom: 4, trailing: 8))
                        .cornerRadius(12)
                        
                        Button(action: {
                            // Dismiss the PopUp
                            withAnimation(.linear(duration: 0.3)) {
                                show = false
                            }
                        }, label: {
                            HStack {
                                Text("Not interested in unlimited content, thanks!")
                                    .multilineTextAlignment(TextAlignment.center)
                                    .frame(maxWidth: .infinity, alignment: .center)
                                    .font(Font.system(size: 16, weight: .regular))
                                    .padding(EdgeInsets.init(top: 8, leading: 8, bottom: 8, trailing: 8))
                            }
                        }).buttonStyle(PlainButtonStyle())
                        .background(Color.init("light-background"))
                        .padding(EdgeInsets.init(top: 4, leading: 8, bottom: 4, trailing: 8))
                        .cornerRadius(12)
                    }
                }
                .frame(maxWidth: 300, maxHeight: 670)
                .cornerRadius(20)
            }
        }
    }
}
