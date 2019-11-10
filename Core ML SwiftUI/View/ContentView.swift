//
//  ContentView.swift
//  Core ML SwiftUI
//
//  Created by Dmitry Novosyolov on 10/11/2019.
//  Copyright © 2019 Dmitry Novosyolov. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var imageCModel: ImageClassificationModel
    @State private var isPresented = false
    @State private var takePhoto = false
    
    fileprivate func classification() {
        self.imageCModel.updateClassification()
    }
    var body: some View {
        NavigationView {
            VStack {
                self.imageCModel.image == nil
                    ?
                        PlaceholderView()
                            .toAnyView()
                    :
                    ZStack {
                        Image(uiImage: self.imageCModel.image!)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .edgesIgnoringSafeArea(.bottom)
                            .navigationBarTitle("ML Classification", displayMode: .inline)
                            .onTapGesture { self.classification()}
                        
                        Text(self.imageCModel.classificationText.localizedCapitalized)
                            .foregroundColor(.white)
                            .font(.system(size: 22))
                            .shadow(color: .black, radius: 1, x: 2, y: 2)
                            .padding()
                            .background(Rectangle()
                                .foregroundColor(Color.init(.systemBackground))
                                .opacity(0.33)
                                .cornerRadius(10))
                    }.toAnyView()
            }.navigationBarItems(
                leading:
                Button(action: {
                    self.takePhoto = false
                    self.imageCModel.classificationText = "Tap to Classification"
                    self.isPresented.toggle()
                }, label: { Image(systemName: "photo")}),
                trailing: Button(action: {
                    self.takePhoto = true
                    self.imageCModel.classificationText = "Tap to Classification"
                    self.isPresented.toggle()
                }, label: { Image(systemName: "camera")})
            ).font(.title)
        }.sheet(isPresented: self.$isPresented) { ShowImagePicker(image: self.$imageCModel.image, takePhoto: self.$takePhoto)}
    }
}

struct PlaceholderView: View {
    var body: some View {
        ZStack {
            Color(.systemBackground)
            Image(systemName: "umbrella")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .foregroundColor(Color.init(.systemRed))
                .shadow(color: .secondary, radius: 5)
        }.padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(ImageClassificationModel())
    }
}
