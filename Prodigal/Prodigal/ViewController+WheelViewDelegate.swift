//
//  ViewController+WheelViewDelegate.swift
//  Prodigal
//
//   Copyright 2017 Bob Sun
//
//   Licensed under the Apache License, Version 2.0 (the "License");
//   you may not use this file except in compliance with the License.
//   You may obtain a copy of the License at
//
//       http://www.apache.org/licenses/LICENSE-2.0
//
//   Unless required by applicable law or agreed to in writing, software
//   distributed under the License is distributed on an "AS IS" BASIS,
//   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//   See the License for the specific language governing permissions and
//   limitations under the License.
//
//  Created by bob.sun on 27/03/2017.
//
//      _
//         ( )
//          H
//          H
//         _H_ 
//      .-'-.-'-.
//     /         \
//    |           |
//    |   .-------'._
//    |  / /  '.' '. \
//    |  \ \ @   @ / /
//    |   '---------'
//    |    _______|
//    |  .'-+-+-+|              I'm going to build my own APP with blackjack and hookers!
//    |  '.-+-+-+|
//    |    """""" |
//    '-.__   __.-'
//         """
//

import Foundation
import MediaPlayer
import Holophonor

extension ViewController: WheelViewDelegate {
    
    func onNext() {
        let total = playlist.count - 1
        if playingIndex == total || playingIndex < 0 || total <= 0 {
            return
        }
        player?.stop()
        play(item: playlist[playingIndex + 1])
        
    }
    func onMenu() {
        if stack.count == 1 {
            return
        }
        let type = stack.count <= 2 ? AnimType.none : AnimType.pop
        stack.popLast()?.hide(type: type, completion: {
        })
        self.current = self.stack.last
        self.wheelView.tickDelegate = self.current
        self.current.show(type: .pop)
    }
    func onPrev() {
        if (player == nil) {
            self.play()
            return
        }
        var index = playingIndex
        let total = playlist.count - 1

        if playingIndex == 0 || playingIndex < 0 {
            if playingIndex == 0 && (player?.isPlaying)! {
                player?.currentTime = 0
            }
            if total == 0 {
                return
            }
            index = 0
        } else {
            if (player?.isPlaying)! && Int((player?.currentTime)!) > 5 {
                index = playingIndex
            } else {
                index = playingIndex - 1
            }
        }
        player?.stop()
        play(item: playlist[index])
    }
    func onPlay() {
        if player != nil {
            if (player?.isPlaying)! {
                player?.pause()
            } else {
                player?.play()
                InfoCenterHelper.helper.update(withItem: playlist[playingIndex], elapsed: player?.currentTime ?? 0)
            }
            return
        }
        self.play()
        
    }
    func onSelect() {
        let select = current.getSelection()
        switch select.type {
        case .Artists:
            current.hide {
                self.artistsList?.show(withType: select.type, andData: self.holo.getAllArtists(), animate: false)
            }
            self.current = self.artistsList
            self.wheelView.tickDelegate = self.artistsList
            break
        case .Albums:
            current.hide {
                self.albumsList?.show(withType: select.type, andData: self.holo.getAllAlbums(), animate: false)
            }
            current = self.albumsList
            self.wheelView.tickDelegate = self.albumsList
            break
        case .Songs:
            current.hide {
                self.songsList?.show(withType: select.type, andData: self.holo.getAllSongs() , animate: false)
            }
            current = self.songsList
            self.wheelView.tickDelegate = self.songsList
            break
        case .Artist:
            current.hide(completion: {
                
            })
            let artist = select.object as? MediaCollection
            self.albumsList.show(withType: .Albums, andData: holo.getAlbumsBy(artistId: artist?.persistentID ?? ""))
            current = albumsList
            self.wheelView.tickDelegate = self.albumsList
            break
        case .Album:
            current.hide(completion: {
                
            })
            let album = select.object as? MediaCollection
            self.songsList.show(withType: .Songs, andData: album?.items ?? [], animate: true)
            current = songsList
            self.wheelView.tickDelegate = self.songsList
            break
        case .Song:
            current.hide {
                self.nowPlaying.show(withSong: select.object as? MediaItem)
            }
            self.resumeTime = 0
            self.playlist = (current as! ListViewController).playList ?? []
            self.checkShuffle(highlight: select.object!)
            current = nowPlaying
            wheelView.tickDelegate = nowPlaying
            self.play(item: select.object as! MediaItem)
            break
        case .ShuffleCurrent:
            current.hide {
                self.nowPlaying.show(withSong: select.object as? MediaItem)
            }
            self.resumeTime = 0
            self.playlist = (current as! ListViewController).playList ?? []
            current = nowPlaying
            wheelView.tickDelegate = nowPlaying
            self.play(item: (select.object as? MediaItem)!)
            break
        case .Genres:
            current.hide {
                self.genresList?.show(withType: select.type, andData: self.holo.getAllGenres() , animate: false)
            }
            current = genresList
            self.wheelView.tickDelegate = self.genresList
            break
        case .Genre:
            current.hide(completion: {
                
            })
            let genre = select.object as? MediaCollection
            self.artistsList.show(withType: .Artists, andData: self.holo.getArtistsBy(genre: genre?.representativeItem?.genre ?? ""))
            current = self.artistsList
            self.wheelView.tickDelegate = artistsList
            break
        case .Playlist:
            current.hide {
                self.playListView.show(withType: .Songs, andData: self.playlist)
            }
            current = playListView
            wheelView.tickDelegate = playListView
            break
        case .ShuffleSongs:
            current.hide(completion: {
                self.nowPlaying.show(type: .push)
            })
            self.playlist = MediaLibrary.shuffle(array: self.holo.getAllSongs()) as! Array<MediaItem>
            self.resumeTime = 0;
            if self.playlist.count > 0 {
                self.play(item: self.playlist[0])
            }
            current = nowPlaying
            wheelView.tickDelegate = nowPlaying
            break
        case .NowPlaying:
            current.hide {
                if self.playingIndex <= self.playlist.count && self.playlist.count > 0 {
                    self.nowPlaying.show(withSong: self.playlist[self.playingIndex])
                } else {
                    self.nowPlaying.show(withSong: nil)
                }
            }
            current = nowPlaying
            wheelView.tickDelegate = nowPlaying
            break
        case .NowPlayingPopSeek:
            if current != nowPlaying {
                break
            }
            nowPlaying.popSeek()
            break
        case .NowPlayingDoSeek:
            self.player?.currentTime = Double(self.player?.duration ?? 0) * (select.object! as! Double)
            break
        case .CoverGallery:
            current.hide {
                self.gallery.show(type: .none)
            }
            current = gallery
            wheelView.tickDelegate = gallery
            break
        case .Settings:
            current.hide {
                self.settings.show(withType: .Settings, andData: MenuMeta.settingsMenu(), animate: false)
            }
            current = settings
            wheelView.tickDelegate = settings
            break
        case .RepeatSettings:
            _ = AppSettings.sharedInstance.rollRepeat()
            return
        case .ShuffleSettings:
            _ = AppSettings.sharedInstance.rollShuffle()
            return
        case .MoreTheme:
            getMoreTheme()
            return
        case .ThemeSettings:
            current.hide {
                self.themeListView.show(withType: .Themes, andData: ThemeManager().fetchAllThemes(), animate: false)
            }
            current  = themeListView
            wheelView.tickDelegate = themeListView
            break
        case .Theme:
            loadTheme(named: select.object as! String?)
            wheelView.loadTheme()
            return
        case .About:
            current.hide {
                self.aboutView.show(withType: .About, andData: [], animate: true)
            }
            current = aboutView
            wheelView.tickDelegate = aboutView.aboutView
            break
        default:
            return
        }
        stack.append(current)
    }
    
    fileprivate func checkShuffle(highlight: Any) {
        if AppSettings.sharedInstance.getShuffle() == .Yes {
            self.fileList = MediaLibrary.shuffle(array: self.fileList, highlight: highlight) as! [MediaItem]
        }
    }
    
    fileprivate func getMoreTheme() {
        let url = URL(string: "https://github.com/SpongeBobSun/Prodigal-iOS/blob/master/MoreTheme.md")
        UIApplication.shared.open(url!, options: convertToUIApplicationOpenExternalURLOptionsKeyDictionary([:]), completionHandler: nil)
    }
}


// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToUIApplicationOpenExternalURLOptionsKeyDictionary(_ input: [String: Any]) -> [UIApplication.OpenExternalURLOptionsKey: Any] {
	return Dictionary(uniqueKeysWithValues: input.map { key, value in (UIApplication.OpenExternalURLOptionsKey(rawValue: key), value)})
}
