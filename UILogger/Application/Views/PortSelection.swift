//
//  ContentView.swift
//  UILogger
//
//  Created by Ömer Hamid Kamışlı on 4/22/23.
//

import SwiftUI

struct PortSelection: View {
    @State var port: String = "8082"
    
    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    Text("Port:").font(.title3)
                    TextField("", text: $port)
                    
                    NavigationLink("Start") {
                        LogsView()
                            .onAppear {
                            WebSocketServer.shared?.setPort(port: UInt16(port) ?? 8082)
                            WebSocketServer.shared?.start()
                        }
                    }
                }
                .padding(25)
                Spacer()
                Image("Poikus")
                    .resizable()
                    .scaledToFit().frame(width: 200)
                Text("POIKUS LLC\nOmer Hamid Kamisli").multilineTextAlignment(.center)
                    

            }
            .padding(48)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        PortSelection()
    }
}

