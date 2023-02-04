//
//  SpotifyController.swift
//  SpotifyQuickStart
//
//  Created by Till Hainbach on 02.04.21.
//

import SwiftUI
import SpotifyiOS
import Combine

class SpotifyController: NSObject, ObservableObject {
    @Published var isLoggedIn: Bool = false
    @Published var trackName: String = ""
    @Published var albumName: String = ""
    
    let spotifyClientID = "Your client Id"
    let spotifyRedirectURL = URL(string:"spotify-ios-quick-start://spotify-login-callback")!
    
    var accessToken: String? = nil
    
    var playURI = ""
    
    private var connectCancellable: AnyCancellable?
    
    private var disconnectCancellable: AnyCancellable?
    
    override init() {
        super.init()
        connectCancellable = NotificationCenter.default.publisher(for: UIApplication.didBecomeActiveNotification)
            .receive(on: DispatchQueue.main)
            .sink { _ in
                self.connect()
            }
        
        disconnectCancellable = NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification)
            .receive(on: DispatchQueue.main)
            .sink { _ in
                self.disconnect()
            }

    }
        
    lazy var configuration = SPTConfiguration(
        clientID: spotifyClientID,
        
        redirectURL: spotifyRedirectURL
    )

    lazy var appRemote: SPTAppRemote = {
        let appRemote = SPTAppRemote(configuration: configuration, logLevel: .debug)
        appRemote.connectionParameters.accessToken = self.accessToken
        appRemote.delegate = self
        return appRemote
    }()
    
  
    
    func setAccessToken(from url: URL) {
        let parameters = appRemote.authorizationParameters(from: url)
        
        if let accessToken = parameters?[SPTAppRemoteAccessTokenKey] {
            appRemote.connectionParameters.accessToken = accessToken
            self.accessToken = accessToken
            print(accessToken)
        } else if let errorDescription = parameters?[SPTAppRemoteErrorDescriptionKey] {
            print("Im heree")//debugging
            print(errorDescription)
        }
        
    }
    
    func connect() {
        guard let _ = self.appRemote.connectionParameters.accessToken else {
            self.appRemote.authorizeAndPlayURI("")
            return
        }
        
        appRemote.connect()
        DispatchQueue.main.async {
            self.isLoggedIn.toggle()
        }
    }
    
    func disconnect() {
        if appRemote.isConnected {
            appRemote.disconnect()
            self.isLoggedIn.toggle()
        }
    }
}

extension SpotifyController: SPTAppRemoteDelegate {
    func appRemoteDidEstablishConnection(_ appRemote: SPTAppRemote) {
        self.appRemote = appRemote
        self.appRemote.playerAPI?.delegate = self
        self.appRemote.playerAPI?.subscribe(toPlayerState: { (result, error) in
            if let error = error {
                debugPrint(error.localizedDescription)
            }
           // self.trackName = result.
            
        })
    }
    
    func appRemote(_ appRemote: SPTAppRemote, didFailConnectionAttemptWithError error: Error?) {
        print("failed")
    }
    
    func appRemote(_ appRemote: SPTAppRemote, didDisconnectWithError error: Error?) {
        print("disconnected")
    }
}

extension SpotifyController: SPTAppRemotePlayerStateDelegate {
    
    func playerStateDidChange(_ playerState: SPTAppRemotePlayerState) {
        print("player state changed")
        print(playerState.track.name)
        print(playerState.self)
        print(playerState.track.album.name)
        self.trackName = playerState.track.name + "- by " + playerState.track.artist.name
        self.albumName = playerState.track.album.name

    }
    
    
    
    func playTrack()
    {
        let playlistUri: String = "https://open.spotify.com/playlist/37i9dQZF1DZ06evO1H1lO8"
       // self.appRemote.playerAPI.
        self.appRemote.playerAPI?.play(playlistUri){ error, res in
            if let error = error {
                print("error",error)
            }
           
            
        }
            
        }
    
    func playerName(_ playerState: SPTAppRemotePlayerState) -> String {
        debugPrint("Track name: %@", playerState.track.name)
        return playerState.track.name
    }
    
    func pauseMusic(){
        self.appRemote.playerAPI?.pause()
    }
    
    func resumeMusic(){
        self.appRemote.playerAPI?.resume()
       
    }
    
    func playAlbum()
    {
      //  let albumUri: String = "https://open.spotify.com/album/1XKqjErvJYimD94yD3v6ky"
        let albumUri: String = "spotify:album:1XKqjErvJYimD94yD3v6ky"
        
        // self.appRemote.playerAPI.
        self.appRemote.playerAPI?.play(albumUri){ error, res in
            if let error = error {
                print("error")
                print("error",error)
            }
         
            
        }
        
    }
  
  
    
}

