//
//  BMSubtitles.swift
//  Pods
//
//  Created by BrikerMan on 2017/4/2.
//
//

import Foundation

public class BMSubtitles {
    public var groups: [Group] = []
    
    public struct Group: CustomStringConvertible {
        var index: Int
        var start: TimeInterval
        var end  : TimeInterval
        var text : String
        
     init(index: Int, start: String, end: String, text: String) {
            self.index = index
            self.start = Group.parseDuration(start)
            self.end   = Group.parseDuration(end)
            self.text  = text
        }
        
        static func parseDuration(_ fromStr:String) -> TimeInterval {
            var h: TimeInterval = 0.0, m: TimeInterval = 0.0, s: TimeInterval = 0.0, c: TimeInterval = 0.0
            let scanner = Scanner(string: fromStr)
            scanner.scanDouble(&h)
            scanner.scanString(":", into: nil)
            scanner.scanDouble(&m)
            scanner.scanString(":", into: nil)
            scanner.scanDouble(&s)
            scanner.scanString(",", into: nil)
            scanner.scanDouble(&c)
            return (h * 3600.0) + (m * 60.0) + s + (c / 1000.0)
        }
        
        public var description: String {
            return "Subtile Group ==========\nindex : \(index),\nstart : \(start)\nend   :\(end)\ntext  :\(text)"
        }
    }
    
    public init(url: URL, encoding: String.Encoding? = nil) {
        DispatchQueue.global(qos: .background).async {
            do {
                let string: String
                if let encoding = encoding {
                    string = try String(contentsOf: url, encoding: encoding)
                } else {
                    string = try String(contentsOf: url)
                }
                
                self.groups = BMSubtitles.parseSubRip(string) ?? []
            } catch {
                print("| BMPlayer | [Error] failed to load \(url.absoluteString) \(error.localizedDescription)")
            }
        }
    }
    public init(vttUrl: URL, encoding: String.Encoding? = nil) {
        DispatchQueue.global(qos: .background).async {
            do {
                if let encoding = encoding {
                    let subTitle = try String(contentsOf: vttUrl, encoding: encoding)
                    if subTitle.contains("WEBVTT") {
                        let convert = subTitle.replacingOccurrences(of: "WEBVTT", with: "")
                        let scr = self.convertvttToSrt(convert)
                        self.groups = BMSubtitles.parseSubRip(scr) ?? []
                    } else {
                        self.groups = BMSubtitles.parseSubRip(subTitle) ?? []
                    }
                } else {
                    let subTitle = try String(contentsOf: vttUrl)
                    if subTitle.contains("WEBVTT") {
                        let convert = subTitle.replacingOccurrences(of: "WEBVTT", with: "")
                        let scr = self.convertvttToSrt(convert)
                        self.groups = BMSubtitles.parseSubRip(scr) ?? []
                    } else {
                        self.groups = BMSubtitles.parseSubRip(subTitle) ?? []
                    }
                }
                
            } catch {
                print("| BMPlayer | [Error] failed to load \(vttUrl.absoluteString) \(error.localizedDescription)")
            }
        }
    }
    func convertvttToSrt(_ payLoad: String) -> String {
        var datas = payLoad.components(separatedBy: "\n\n")
        var scrText = String()
        for index in 0..<datas.count where !datas[index].isEmpty {
            let add = String(index) + "\n" + datas[index] + "\r\n\r\n"
            datas[index] = add
            scrText.append(add)
        }
        return scrText
    }
    /**
     Search for target group for time
     
     - parameter time: target time
     
     - returns: result group or nil
     */
    public func search(for time: TimeInterval) -> Group? {
        let result = groups.first(where: { group -> Bool in
            if group.start <= time && group.end >= time {
                return true
            }
            return false
        })
        return result
    }
    
    /**
     Parse str string into Group Array
     
     - parameter payload: target string
     
     - returns: result group
     */
    fileprivate static func parseSubRip(_ payload: String) -> [Group]? {
          /*
             var groups: [Group] = []
             let scanner = Scanner(string: payload)
             while !scanner.isAtEnd {
                 var indexString: NSString?
                 scanner.scanUpToCharacters(from: .newlines, into: &indexString)
                 
                 var startString: NSString?
                 scanner.scanUpTo(" --> ", into: &startString)
                 
                 // skip spaces and newlines by default.
                 scanner.scanString("-->", into: nil)
                 
                 var endString: NSString?
                 scanner.scanUpToCharacters(from: .newlines, into: &endString)
                 
                 
                 var textString: NSString?
                 scanner.scanUpTo("\r\n\r\n", into: &textString)
                 
                 if let text = textString {
                     textString = text.trimmingCharacters(in: .whitespaces) as NSString
                     textString = text.replacingOccurrences(of: "\r", with: "") as NSString
                 }
                 
                 if let indexString = indexString,
                     let index = Int(indexString as String),
                     let start = startString,
                     let end   = endString,
                     let text  = textString {
                     let group = Group(index, start, end, text)
                     groups.append(group)
                 }
             }
             return groups
             */
             var groups: [Group] = []
             let scanner = Scanner(string: payload)
             var index = 0
             while !scanner.isAtEnd {
                 var line: NSString?
                 scanner.scanUpToCharacters(from: .newlines, into: &line)
                 
                 guard let timeline = line else {continue}
                 if !timeline.contains(" --> ") {continue}
                 
                 let times = String(timeline).components(separatedBy: " --> ")
                 if times.count != 2 {continue}
                 
                 var textString: NSString?
                 scanner.scanUpToCharacters(from: .newlines, into: &textString)
                 guard let text = textString else {continue}
                 
                 index += 1
                 let group = Group(index: index, start: times[0], end: times[1], text: String(text))
                 
                 groups.append(group)
             }
             return groups
    }
}
