//
//  ContentView.swift
//  SpotifyQuickStart
//
//  Created by Till Hainbach on 02.04.21.
//

import SwiftUI
import SpotifyiOS

struct ContentView: View {
    @EnvironmentObject var vm: SpotifyController
    @State var trackPlaying: Bool = false
    @State var albumPlaying: Bool = false
 
    var body: some View {
        VStack(spacing:20) {
            if vm.isLoggedIn {
                // Show your app's content
                Text("you're logged in")
                Button("Play track"){
                    vm.playTrack()
                    trackPlaying = true
                    albumPlaying = false
                }
                if trackPlaying
                {
                    HStack(spacing:20){
                        
                        Button(action: {
                            vm.pauseMusic()
                            
                        }) {
                            Image(systemName: "pause.fill")
                        }
                        
                        Button(action: {
                            vm.playTrack()
                            
                        }) {
                            Image(systemName: "play.fill")
                        }
                        
                       
                    }
                       
                      
                        Text("\(vm.trackName)")
        
                }
                Button("Play Album")
                {
                   
                    vm.playAlbum()
                    trackPlaying = false
                    albumPlaying = true
                }
                if albumPlaying
                {
                   
                    
                    Text("\(vm.albumName)")
                    Text("\(vm.trackName)")
                    
                }
               
                
               
            } else {
                Button("user not logged in") {
                    
                }
            }
           
        }
    }
   

}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
