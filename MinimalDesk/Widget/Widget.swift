

import SwiftUI

let screenWidth = UIScreen.main.bounds.width
let screenHeight = UIScreen.main.bounds.height

struct Widget: View {
   
   @State var widthToSet: CGFloat = 0
   @State var heightToSet: CGFloat = 0
   @State var gap: CGFloat = 0
   
   @State private var isPresented = false
   @State private var isWidgetListPresented = false
   @State private var presentSubscriptionView = false
   
   @AppStorage("subscribed") private var subscribed = false

   var body: some View {
       ZStack {
           Color.black.edgesIgnoringSafeArea(.all)
           
           VStack {
               Image("banner")
                   .resizable()
                   .scaledToFit()
                   .frame(width: screenWidth * 0.92, height: screenHeight * 0.15)
                   .cornerRadius(10)
                   .onTapGesture {
                       if let url = URL(string: "https://apps.apple.com/us/app/scannr-qr-barcode-generator/id6480269610") {
                           UIApplication.shared.open(url)
                       }
                   }
               
               Spacer()
               
               HStack(spacing: gap) {
                   
                   // Customize Widget Button (Restricted)
                   VStack(spacing: 8) {
                       Image("widghet")
                           .resizable()
                           .aspectRatio(contentMode: .fit)
                           .frame(width: 35, height: 35)
                       
                       VStack(spacing: 0) {
                           Text("Customize")
                               .font(.headline)
                               .foregroundColor(Color.white)
                               .frame(maxWidth: .infinity, alignment: .center)
                           
                           Text("Widget")
                               .font(.headline)
                               .foregroundColor(Color.white)
                               .frame(maxWidth: .infinity, alignment: .center)
                       }
                   }
                   .frame(width: widthToSet, height: heightToSet)
                   .background(Color(red: 41/255, green: 44/255, blue: 53/255))
                   .cornerRadius(10)
                   .onTapGesture {
                       if Store.shared.userHasActivePurchase() {
                           isPresented = true
                       } else {
                           presentSubscriptionView = true
                       }
                   }
                   .fullScreenCover(isPresented: $isPresented) {
                       CustomWidget()
                   }
                   
                   // Top Widgets Button (Unrestricted)
                   VStack(spacing: 0) {
                       Image("widghet")
                           .resizable()
                           .aspectRatio(contentMode: .fill)
                           .frame(width: 35, height: 35)
                           .padding(8)
                       
                       VStack(spacing: 0) {
                           Text("Top")
                               .font(.headline)
                               .foregroundColor(Color.white)
                               .frame(maxWidth: .infinity, alignment: .center)
                           Text("Widgets")
                               .font(.headline)
                               .foregroundColor(Color.white)
                               .frame(maxWidth: .infinity, alignment: .center)
                       }
                   }
                   .frame(width: widthToSet, height: heightToSet)
                   .background(Color(red: 41/255, green: 44/255, blue: 53/255))
                   .cornerRadius(10)
                   .onTapGesture {
                       isWidgetListPresented = true
                   }
                   .fullScreenCover(isPresented: $isWidgetListPresented) {
                       WidgetList()
                   }
                   
               }
               .padding(.bottom, 40)
           }
           .background(Color.black)
           .onAppear {
               widthToSet = (screenWidth * 0.85)/2.0
               gap = (screenWidth - widthToSet * 2)/3.0
               heightToSet = (112 * widthToSet) / 176.0
               
               // Optional: Sync AppStorage with actual purchase status
               subscribed = Store.shared.userHasActivePurchase()
           }
       }
       .fullScreenCover(isPresented: $presentSubscriptionView) {
           SubscriptionView()
       }
   }
}

#Preview {
   Widget()
}
