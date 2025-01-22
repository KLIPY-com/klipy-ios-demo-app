//
//  Message.swift
//  KlipyiOS-demo
//
//  Created by Tornike Gomareli on 14.01.25.
//

import Foundation

struct Message: Identifiable {
  let id = UUID()
  let content: String
  let mediaItem: GridItemLayout?
  let isFromCurrentUser: Bool
  let timestamp: Date
  
  // Example messages for preview
  static let examples = [
    Message(
      content: "Hey John",
      mediaItem: GridItemLayout(
        id: 9103889546577958,
        url: "https://static.klipy.com/ii/8ce8357c78ea940b9c2015daf05ce1a5/d1/53/ukJxZvQu.gif",
        previewUrl: "data:image/jpeg;base64,/9j//gARTGF2YzU4LjEzNC4xMDAA/9sAQwAIBAQEBAQFBQUFBQUGBgYGBgYGBgYGBgYGBwcHCAgIBwcHBgYHBwgICAgJCQkICAgICQkKCgoMDAsLDg4OEREU/8QAewAAAwEBAQAAAAAAAAAAAAAABwUGAgQDAQADAQEBAAAAAAAAAAAAAAAAAQMCBAUQAAEDAwIDBwMFAQAAAAAAAAEEAwIFABEGEiETMUFxgSKxBxRyNFEzkaFFYVMRAAMAAgMBAQEBAQAAAAAAAAABAgMRIRIEMUETgTL/wAARCAAoACgDARIAAhIAAxIA/9oADAMBAAIRAxEAPwA3LUa9xbCbc8N9otgSPyLaa0IAMSci2yd0hkRtTWU78ZuvfI2tiJyM/wCWA6lSA5lukR1b903KHqSScgzZE8HHZxuC1QqZW6lcTNOCc5vbf5vF+iJejmuXWUpHlyXPbR3YskR5/wDA80StJ65Tm1LUh54g9bndA0RXTUCXmKfLtB2ZvrT2thj0oSPNqXL0zWZ9sjaH6VGvgunOc8t9gthCcSOEgb02tCMAKa6FidwPxe2NjqM2v9z6jNDRpmJIJ/FjpTPJL1trHwOZdVot4Jl5eTlVVYrW3G+ZkEEHjYyZ1w8ncLQcJlI462qrt+nPieRrQ5nrrg6804U9mqzomKevyqTT4BEt4Ge3reKmtWvxjLeTN3p43bhCnE97ZGU39+Dv0T10kekdeahbqrSFtVjiIAA+Fz6OirmtYIZuyluLkDjxseTJ20bWt60WjzeZ4u3G0crq+rargPWjUdZ+O28seMxOIP723okdtLTA/wDOPpdY/wCORr4R9Ll5H1WkYrlsTa1p71UbKebYk0QeNsq10PcbKiankPwcXUPgyvoJpe2iOC+T0p482QLqlf6k+83JRKfAy7yVX1mScOnWo1RG2DugJxtn/apfrHrbSCfoNvQP4xo/7WtqqujqjZA5Yicd12qT7Vn6B6WfzXbZsX9n10TZxU12oQUcicMNwGAe6+lP93O3paD8D9A//9k=",
        width: 132.0,
        height: 132.0,
        xPosition: 0.0,
        yPosition: 0.0,
        originalWidth: 90.0,
        originalHeight: 90.0,
        newWidth: 132.0,
        type: "gif"
      ),
      isFromCurrentUser: true,
      timestamp: Date().addingTimeInterval(-3900)
    ),
    Message(
      content: "Hi, how's it going?",
      mediaItem: GridItemLayout(
        id: 4365604958860190,
        url: "https://static.klipy.com/ii/c98c4a4935d23b95805f0befee091d8a/bb/67/5E25D4Yn.gif",
        previewUrl: "data:image/jpeg;base64,iVBORw0KGgoAAAANSUhEUgAAABQAAAALCAYAAAB/Ca1DAAAACXBIWXMAAAAAAAAAAQCEeRdzAAADb0lEQVR4nCWNW0ybZQCG/xgTE93ChdGZuXiMZiwat8QNGBOIpdnINjBmLPGECWRjZk6BMXY1nS5ekCzRCzCLzo5CS1s61hbGIaPNhBVcacvZlbYcClS0pfw90P87/d9BphfPzfMmzyshJHZsZfjzcoy+Jq/TNzNx+jJMs+cI4DsJ5DuQwnOyabYrFaevJqI0N7GqvpWMqnu34vQllGbPqpA/w4h4ilPxpGDiCUnO8heicbYvtKCWBOdIWSRASmIRdb/8D31j++T1+DrNXY2oh0IBop2bxB/O+nBlcBKXrwVI0cZ2PB2nr4Ak24WzPIci/rS0lGT7vCv0WL8PX+hxwW+dTnjZM4Zqpibw6ckpcsrjw1WuUfSV3Qm/M92FP5nsoKWnFzQPu2DDpAd9GpzBx9eCpFBeU3OVBHtR8m/yw7ZFWv2jm7Rcs0PHdYti/+UO0Lf1wVbdAGy90QN117tB9zdm4LrUATxNbYr3ml75vcWiWDsc4GfHAPzBfR9+HfLjiniYHJSGN4Xm5hKrrxtVrZ/Y0XSVAYRqDWD2vBn4v7BA/1kjmPtcDxYr28B6+S2Q+EAHEh/pQPSsHgTqjWD8exMY0t1Wbo0MwcawD1VITlkcbVnml6o9tFfbR5ZKLEjWdEK51IQSGhPaLDXApEYPt4r1EBS2I1zYDnFxO1S02/6EEcY+M4DwVTNw2vpA89QorJJcSaFtXeEXa3zUprlHwgV2vFlwG6fyu/+nsAul3jOj1BEzyhSYkZJnRiDfgpT8LrR1xIqTJ61otfEOvG8egs1+D6qS3GlR1BbltQ0z9LfKB+qD4/fIXNkgnj82SILbzJ8YII/K+/Gjk314vqwXLxztwcvaXhwpvYsj2n6yeHqQTFxx4S6bBzfN/EnKpZmseKd/g5e3LLLLV2Zoa5NX1TeOq4aGcdVY76XGRi9t/895VGPdmGq94Ca2827iODemOs49pLbH241p9epImJ5aitJ3pSgSe2a3xH7XBi+zR9nH1gir7lpmNeYIO9O5ws6YVnmNeYXVdC6z2o4F9mVbiNXpQrThZphd/HWRNRgirNb5F6sIJviBRIbvkVJU5PyNxe5wVuydTYsD00l+cErmhyaSIs+XEvn+lMh7jFcWhx8mePFYnL8/GueakQ2uHU4I7R+yKApkxNsxIHYrROz8FxGFfNNyHCqAAAAAAElFTkSuQmCC",
        width: 257.0,
        height: 142.0,
        xPosition: 0.0,
        yPosition: 912.0,
        originalWidth: 100.0,
        originalHeight: 55.0,
        newWidth: 258.0,
        type: "sticker"
      ),
      isFromCurrentUser: false,
      timestamp: Date().addingTimeInterval(-3700)
    )
  ]
}
