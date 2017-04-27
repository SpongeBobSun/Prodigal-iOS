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

extension ViewController: WheelViewDelegate {
    
    func onNext() {
        let total = source == .iTunes ? playlist.count - 1 : fileList.count - 1
        if playingIndex == total || playingIndex < 0 {
            return
        }
        player?.stop()
        if (source == .iTunes) {
            play(item: playlist[playingIndex + 1])
        } else {
            play(item: fileList[playingIndex + 1])
        }
        
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
        let total = source == .iTunes ? playlist.count - 1 : fileList.count - 1

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
        if (source == .iTunes) {
            play(item: playlist[index])
        } else {
            play(item: fileList[index])
        }
    }
    func onPlay() {
        if player != nil {
            if (player?.isPlaying)! {
                player?.pause()
            } else {
                player?.play()
                if (source == .iTunes) {
                    InfoCenterHelper.helper.update(withItem: playlist[playingIndex], elapsed: player?.currentTime ?? 0)
                } else {
                    InfoCenterHelper.helper.update(withFile: fileList[playingIndex], elapsed: player?.currentTime ?? 0)
                }
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
                self.artistsList?.show(withType: select.type, andData: MediaLibrary.sharedInstance.fetchAllArtists(), animate: false)
            }
            self.current = self.artistsList
            self.wheelView.tickDelegate = self.artistsList
            break
        case .Albums:
            current.hide {
                self.albumsList?.show(withType: select.type, andData: MediaLibrary.sharedInstance.fetchAllAlbums(), animate: false)
            }
            current = self.albumsList
            self.wheelView.tickDelegate = self.albumsList
            break
        case .Songs:
            current.hide {
                self.songsList?.show(withType: select.type, andData: MediaLibrary.sharedInstance.fetchAllSongs() , animate: false)
            }
            current = self.songsList
            self.wheelView.tickDelegate = self.songsList
            break
        case .Artist:
            current.hide(completion: {
                
            })
            let artist = select.object as! MPMediaItemCollection!
            self.albumsList.show(withType: .Albums, andData: MediaLibrary.sharedInstance.fetchAlbums(byArtist: (artist?.representativeItem?.artistPersistentID)!))
            current = albumsList
            self.wheelView.tickDelegate = self.albumsList
            break
        case .Album:
            current.hide(completion: {
                
            })
            let album = select.object as! MPMediaItemCollection!
            self.songsList.show(withType: .Songs, andData: MediaLibrary.sharedInstance.fetchSongs(byAlbum: (album?.representativeItem?.albumPersistentID)!))
            current = songsList
            self.wheelView.tickDelegate = self.songsList
            break
        case .Song:
            current.hide {
                self.nowPlaying.show(withSong: select.object as! MPMediaItem!)
            }
            self.source = .iTunes
            self.resumeTime = 0
            self.playlist = (current as! ListViewController).playList ?? []
            self.checkShuffle(highlight: select.object)
            current = nowPlaying
            wheelView.tickDelegate = nowPlaying
            self.play(item: select.object as! MPMediaItem!)
            break
            
        case .LocalSongs:
            current.hide {
                self.localListView.show(withType: .LocalSongs, andData: MediaLibrary.sharedInstance.fetchLocalFiles())
            }
            current = localListView
            self.wheelView.tickDelegate = localListView
            break
        case .LocalSong:
            current.hide {
                self.nowPlaying.show(withFile: select.object as! MediaItem!)
            }
            current = nowPlaying
            wheelView.tickDelegate = nowPlaying
            self.source = .Local
            self.resumeTime = 0
            self.fileList = MediaLibrary.sharedInstance.fetchLocalFiles()
            self.play(item: select.object as! MediaItem!)
            break
        case .ShuffleCurrent:
            current.hide {
                self.nowPlaying.show(withSong: select.object as! MPMediaItem!)
            }
            self.source = .iTunes
            self.resumeTime = 0
            self.playlist = (current as! ListViewController).playList ?? []
            current = nowPlaying
            wheelView.tickDelegate = nowPlaying
            self.play(item: select.object as! MPMediaItem!)
            break
        case .Genres:
            current.hide {
                self.genresList?.show(withType: select.type, andData: MediaLibrary.sharedInstance.fetchAllGenres() , animate: false)
            }
            current = genresList
            self.wheelView.tickDelegate = self.genresList
            break
        case .Genre:
            current.hide(completion: {
                
            })
            let genre = select.object as! MPMediaItemCollection!
            self.artistsList.show(withType: .Artists, andData: MediaLibrary.sharedInstance.fetchArtists(byGenre: (genre?.representativeItem?.genrePersistentID)!))
            current = self.artistsList
            self.wheelView.tickDelegate = artistsList
            break
        case .Playlist:
            playListView.show(withType: (source == .iTunes ? .Songs : .LocalSongs), andData: (source == .iTunes ? self.playlist : self.fileList))
            current = playListView
            wheelView.tickDelegate = playListView
            break
        case .ShuffleSongs:
            current.hide(completion: {
                self.nowPlaying.show(type: .push)
            })
            self.source = .iTunes
            self.playlist = MediaLibrary.shuffle(array: MediaLibrary.sharedInstance.fetchAllSongs()) as! Array<MPMediaItem>
            self.resumeTime = 0;
            if self.playlist.count > 0 {
                self.play(item: self.playlist[0])
            }
            current = nowPlaying
            wheelView.tickDelegate = nowPlaying
            break
        case .NowPlaying:
            current.hide {
                if self.source == .iTunes {
                    if self.playingIndex <= self.playlist.count && self.playlist.count > 0 {
                        self.nowPlaying.show(withSong: self.playlist[self.playingIndex])
                    } else {
                        self.nowPlaying.show(withSong: nil)
                    }
                } else {
                    if self.playingIndex <= self.fileList.count && self.fileList.count > 0 {
                        self.nowPlaying.show(withFile: self.fileList[self.playingIndex])
                    } else {
                        self.nowPlaying.show(withSong: nil)
                    }
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
            AppSettings.sharedInstance.rollRepeat()
            return
        case .ShuffleSettings:
            AppSettings.sharedInstance.rollShuffle()
            return
        case .ThemeSettings:
            current.hide {
                self.themeListView.show(withType: .Themes, andData: ThemeManager().fetchAllThemes(), animate: false)
            }
            current  = themeListView
            wheelView.tickDelegate = themeListView
            break
        case .Theme:
            wheelView.loadTheme(named: select.object as! String!)
            loadTheme(named: select.object as! String?)
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
            if source == .iTunes {
                self.playlist = MediaLibrary.shuffle(array: self.playlist, highlight: highlight) as! [MPMediaItem]
            } else {
                self.fileList = MediaLibrary.shuffle(array: self.fileList, highlight: highlight) as! [MediaItem]
            }
        }
    }
}

