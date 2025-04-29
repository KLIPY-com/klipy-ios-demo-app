//
//  Message.swift
//  KlipyiOS-demo
//
//  Created by Tornike Gomareli on 14.01.25.
//

import Foundation

struct Message: Identifiable {
  let id = UUID().uuidString
  let content: String
  let mediaItem: GridItemLayout?
  let isFromCurrentUser: Bool
  let timestamp: Date
  
  var isMessageContaintsMp4: Bool {
    mediaItem?.mp4Media != nil
  }
  
  static let klipyExample = [
    Message(
      content: "",
      mediaItem: GridItemLayout(
        id: 8993561733800269,
        url: "https://static.klipy.com/ii/3c0182fcf3214c9108021774efc5f3a4/fd/ff/xtKdANeU.gif",
        highQualityUrl: "https://static.klipy.com/ii/3c0182fcf3214c9108021774efc5f3a4/fd/ff/GzzfapaL.gif",
        mp4Media: nil,
        previewUrl: "data:image/jpeg;base64,/9j//gAPTGF2YzYxLjkuMTAwAP/bAEMACAQEBAQEBQUFBQUFBgYGBgYGBgYGBgYGBgcHBwgICAcHBwYGBwcICAgICQkJCAgICAkJCgoKDAwLCw4ODhERFP/EAHUAAAIDAQEAAAAAAAAAAAAAAAYFBwQCAAMBAQEBAQEAAAAAAAAAAAAAAAUEBgMCEAABAwMEAgIDAQAAAAAAAAABBAMCBQARITESBhMiYXFBMoIHEQACAQMFAQADAQAAAAAAAAABAgMEABExIRMSBUFRMnFC/8AAEQgAHgAeAwESAAISAAMSAP/aAAwDAQACEQMRAD8AkLB+bzF2EwTD2xvix77JRTuoYLsb1eTfB66GNurMAb5ycWYGc5cYjUk3Qqz0VTBTDPKUgMDc3yAJOBfto5KeQAjDfL7M/UEk7C5a+piajdle/KKrsb77q2nBp1GyCZA/scb4shWtimdVbRtsxZcfZ4mQGCMjf7umKgUIOxPY3VQwmcjsfm9xVvtO0pRRlQbNc63jrvZU1ap8XYmPOPq5HI9ZDQ3D8Y9k6xVF7CRU743HDMDJ/J3uSSQwHoQdr0VJ5/niLvVIpycLm04m517g62ZBNOCyxk7a2dtVOooHHItsCcZfNpKjUZJM4Lh/qwKKt4oQrjSzoJ55D+wt6r8zmk7A4u6SdF/xdlZ21SgXhwJeTsPYR3BNjsq3JpaFBgZkHaRzak1I/oypOjIipr2OLhqFmnpjFylQRqu1j1SxUsBhk7HOhA0tJuGYkPGDmyJd/rtQVTbbXIZR1AHEaRH1Y8sqUlakKPHGJI2wMWzQ0EsM/LzxshGAAwNhUMk1DEIhI7hfyTYEywtABErFvpxeiSjpQgHGLc0+SevLFSsRxE4A5aWkSPqoSc8b0mwTkiOgvQ+xWmMRRo2cbnFhv6Eh1AP9sPwqFm5XkTGdhm9DHTQDYLi//9k=",
        width: 100,
        height: 100,
        originalWidth: 100,
        originalHeight: 100,
        type: "gif",
        title: "Chill Out Waiting GIF by Pudgy Penguins",
        slug: "chill-out-waiting-gif-by-pudgy-penguins"
      ),
      isFromCurrentUser: false,
      timestamp: Date().addingTimeInterval(-4000)
    ),
    Message(
      content: "Hi! Welcome to the KLIPY Demo App",
      mediaItem: nil,
      isFromCurrentUser: false,
      timestamp: Date().addingTimeInterval(-3700)
    ),
    Message(
      content: "",
      mediaItem: GridItemLayout(
        id: 1655649420248309,
        url: "https://static.klipy.com/ii/3bbfac09dcb32c2b1e87ad063c4ac16e/f5/5c/HrF798GA.gif",
        highQualityUrl: "https://static.klipy.com/ii/3bbfac09dcb32c2b1e87ad063c4ac16e/f5/5c/uk7Bwpko.gif",
        mp4Media: nil,
        previewUrl: "data:image/jpeg;base64,/9j//gARTGF2YzU4LjEzNC4xMDAA/9sAQwAIBAQEBAQFBQUFBQUGBgYGBgYGBgYGBgYGBwcHCAgIBwcHBgYHBwgICAgJCQkICAgICQkKCgoMDAsLDg4OEREU/8QAgAABAQEBAAAAAAAAAAAAAAAABQQDBwEAAwEBAQEAAAAAAAAAAAAABgQFAgMAARAAAQMDAwUAAwEAAAAAAAAAAREDAhIABCEGBTFRMmFBFHGxFREAAQMCBAUCBQUBAAAAAAAAAQACEQMDEhMhBQZBFHExUSIWUmGxgTPRQiMyB//AABEIABcAHgMBEgACEgADEgD/2gAMAwEAAhEDEQA/AOMyw4RkkQaR0XqfZtzI4R5ptpwREg4NNRonVbYLS52Fsx91bGx5b2RBJGs8kzl4tXLzrrA1rsQg/VacVtlvJx8dxuK1wWR7a23tHjORLUYtuQQTpMJIU1UXvZOHLNQynuuPtc2XSq200fSUzQ+6cLZ9g107qXWV0VV2092ENdAH4S+9X6brnS3UgGR2UvKbLwmdu5r+QKHm0k2oQgj997R3/wD6DGKMV92M5PkTlGKCmMemnu1eINm263tr8lgxMGMP7ckxvAt1tD09MMMmHEnUhfLG43RuVPaZLmXJkre0mlzM2IwNgE/Vc9/Ccl4gk27icXJKgUJFhwp33GywT6hFu18KsbaxFwlw1CrB0aFKXa+3i8qV3nnnWQ2UjL5IVfyzj5Rsadx3UvtwaW2HDw4FQeS7HZ4P67o9E6fKf4Hdk+GfbepLtOsoqRGZ92KPGye3/wBHw2Mp1DJiC4PH7IW5qXUcNdRJz4PIxJCqpTce8nOXzXcqTdJn8UlB2FhZP2yb49uwBao2tj5nSh62plrYm2LIt5sx/ICCVQetHNzZ7UkZMYiznPKyD453mP68q0PQNn7qMzwkmbfZtmNXd13P+vwv/9k=",
        width: 90,
        height: 68,
        originalWidth: 90,
        originalHeight: 68,
        type: "gif",
        title: "astonished",
        slug: "astonished-62"
      ),
      isFromCurrentUser: true,
      timestamp: Date().addingTimeInterval(-1800)
    ),
    Message(
      content: "Feel free to use all the fun content",
      mediaItem: nil,
      isFromCurrentUser: false,
      timestamp: Date().addingTimeInterval(-3700)
    ),
  ]
  
  static let alexExample = [
   
    Message(
      content: "Hey, how's it going?",
      mediaItem: nil,
      isFromCurrentUser: true,
      timestamp: Date().addingTimeInterval(-3900)
    ),
    Message(
      content: "",
      mediaItem:  GridItemLayout(
        id: 9972865512661830,
        url: "https://static.klipy.com/ii/d7aec6f6f171607374b2065c836f92f4/e6/cb/FFxZjbVj.gif",
        highQualityUrl: "https://static.klipy.com/ii/d7aec6f6f171607374b2065c836f92f4/e6/cb/9LBpy5Aw.gif",
        mp4Media: nil,
        previewUrl: "data:image/jpeg;base64,/9j//gARTGF2YzU4LjEzNC4xMDAA/9sAQwAIBAQEBAQFBQUFBQUGBgYGBgYGBgYGBgYGBwcHCAgIBwcHBgYHBwgICAgJCQkICAgICQkKCgoMDAsLDg4OEREU/8QAdQAAAgMBAQAAAAAAAAAAAAAABgQFAwECAAEAAwEBAAAAAAAAAAAAAAAAAgEDAAQQAAEDAwEIAwEBAAAAAAAAAAEAAgQRBQMxM1ESBiOBIiFTQREBAQADAAIBBQEAAAAAAAAAAAERAhIxE0NBFDJRAyH/wAARCAAoACgDARIAAhIAAxIA/9oADAMBAAIRAxEAPwAfGqwObXULl1KOmtVjaVXLXCuqJoE6cx07Qsx8ITywK1WFwDVw8VCeSZngQuQKJ5JmBBvdw7fzuRmzx22fyb0QyVXmOjjVD27fsP2C5SpDvdX5RNjssHEPpjAU1eIp/TWTwl7KUbcsLBQlOCyxHGpapZU9ep8l3VOKWzLom2QYUfcEGcj41h3WwPVpZPAQqcTUCmNTL/UDC8iOTIAf9URbtszmoe/bvAPkX+3nGVPjGWHKMjA7eq4ewbyXVrcxtPxjk2mKe/mmAVjU2CyJvkedmf6XEJ6Xqh3lvgVFpZ9SiCbDvNON3VS40UuN1FOtAP/Z",
        width: 100,
        height: 100,
        originalWidth: 100,
        originalHeight: 100,
        type: "gif",
        title: "Robin Williams Hello GIF by 20th Century Fox Home Entertainment",
        slug: "robin-williams-hello-gif-by-20th-century-fox-home-entertainment"
    ),
      isFromCurrentUser: true,
      timestamp: Date().addingTimeInterval(-3900)
    ),
    Message(
      content: "",
      mediaItem: GridItemLayout(
        id: 5029488822232418,
        url: "https://static.klipy.com/ii/d7aec6f6f171607374b2065c836f92f4/41/48/dGLaB7K3.gif",
        highQualityUrl: "https://static.klipy.com/ii/d7aec6f6f171607374b2065c836f92f4/41/48/akVk6TFL.gif",
        mp4Media: nil,
        previewUrl: "data:image/jpeg;base64,/9j//gARTGF2YzU4LjEzNC4xMDAA/9sAQwAIBAQEBAQFBQUFBQUGBgYGBgYGBgYGBgYGBwcHCAgIBwcHBgYHBwgICAgJCQkICAgICQkKCgoMDAsLDg4OEREU/8QAbAAAAwEBAAAAAAAAAAAAAAAABAMFBgIBAAMBAQAAAAAAAAAAAAAAAAQBAwIAEAACAgICAgIDAQEAAAAAAAACAQMABQQhETESEyJBUWEyBhEAAgMAAwEBAQAAAAAAAAAAAAEDEQIEEiEiMSP/wAARCAAeACgDARIAAhIAAxIA/9oADAMBAAIRAxEAPwDOzZGSXgatwtNJUfUyB3bZXEDCcpJFHAYh5Obs/FMxWw8Zqe74bpMKcrHxvjFsGmahyLk/03RpMVh4NbpB+KFic/7/AGJrq3xhIWNWDySa0PeKD8xMWqH+fr+6r/od6I8PIY9N9cXe/EKTazhsnhWzUcb1IkCw7/yB2NzeHzpDIQSccvzUmRxOmxawEScdpC/i9ZBLyk73HzRUq0h0F3eaM5YRvbAS6iAeOLwMYnw7Tc66UiTRjED72yticKM0m0o2bQd0gIRgL2Dh23HmetURXz+EeTAs5tFtfX6WMocY6qgRdrqyJdiQ/LbpPJkXWkDPTYNxYn27MJWUgLb0QRMg4f8AK2SRu96n4cc0mvRM/9k=",
        width: 100,
        height: 75,
        originalWidth: 100,
        originalHeight: 75,
        type: "gif",
        title: "White Cat Hello",
        slug: "white-cat-hello"
    ),
      isFromCurrentUser: false,
      timestamp: Date().addingTimeInterval(-3900)
    ),
    Message(
      content: "Everything is good! Thanks!",
      mediaItem: nil,
      isFromCurrentUser: false,
      timestamp: Date().addingTimeInterval(-3900)
    ),
  ]
  
  static let saraExample = [
    Message(
      content: "Please remind me about my appointment time",
      mediaItem: nil,
      isFromCurrentUser: true,
      timestamp: Date().addingTimeInterval(-3900)
    ),
    Message(
      content: "",
      mediaItem: GridItemLayout(
        id: 4643712550241892,
        url: "https://static.klipy.com/ii/d7aec6f6f171607374b2065c836f92f4/ca/6a/sopIx6iR.gif",
        highQualityUrl: "https://static.klipy.com/ii/d7aec6f6f171607374b2065c836f92f4/ca/6a/nbqpCCOS.gif",
        mp4Media: nil,
        previewUrl: "data:image/jpeg;base64,/9j//gARTGF2YzU4LjEzNC4xMDAA/9sAQwAIBAQEBAQFBQUFBQUGBgYGBgYGBgYGBgYGBwcHCAgIBwcHBgYHBwgICAgJCQkICAgICQkKCgoMDAsLDg4OEREU/8QAggAAAwEBAQAAAAAAAAAAAAAABAUGBwMAAQACAwEBAQAAAAAAAAAAAAAEBgMCBQEABxAAAQQBAwMDBAMBAAAAAAAAAQADBQIEBhIRMSFBUTNxQxQHE2GRNRURAAEEAgEDAwUAAwEAAAAAAAEAAwIEBREhMRIGQTITUZEUcSJhMxU0/8AAEQgAKAAoAwESAAISAAMSAP/aAAwDAQACEQMRAD8AS58hl2oWa0JBT2Ei2nrgPN7imttmO+5ZWZy06z8Q04O0rK+F49IlE+MZynmTKAiNhRL2M/v71PJVplwDd5XZVsbSfRbkUPirUXqomTvhCfjPE6ESmjB1mn8hOLjX8x9SOFKR0Y7dypNLf0tThdKR7DdLuN157eFO5vRWZlsuW9wbKXW8Vbnz8cvsm3M3KtUFtmEd9Oik24uR+1ptbsKfC0ZzAYy8S+MywK2FTwQFLOzXg4e6Q2Fgl2cnw5OR1vZCWIY+UeJ8KXJOOzrulv36OllkjUY5DfUjqmsxDFjMdo7U7tx6plqx+aPd6eiz6/kldmEYcDQURr1gdd43+0k3sxlqtpyMpS4J+qbORGVGgONcH1VBqGPaxmahtzfa3hfPqPmP/VtRal3cnhG1PFaVCxByEeQU6eJ+JWMI93zieUwjNfKOYAAJJFsftyC+7xyEzw4q7eOD5J7pwxz/+Lioy3zIIFy0ZMQaHAiFoEs0aRdAAnIdfVY+RysrMQ3HiIR18d22JW7YXXPzaRkPyeu1D5TIxYhN9w8DlB5uo5dqyZgCe7hDWXZ2nieTsonBtMuWgXSBEfVexZiseBZ0D+VI5U05l7qg8gqCh5Tj8g58UZgS3pZ+N8HsMTDsRIHe0MaNgQ7jA6/SaXbuFbh8cpQPGvRPpdmJ1Bcusmoc88Kcwch7CsTXd3RXk9tzHMB+EuP8K+WwF67XDTmyAvn9/xJnKOmUYf168J6pHBxcMoyhs/pGOTrr21y9iQEt+gFo9Zdy8lvZEdL3qrjSuQ1Ks7T1CG/HKlE+FWPtVNLp6rrryLcpEOWqeNqYa+/xHvhF4vsm+BIAquK/wDTFRWHXWYEwkQuXP8AUVmsLiv5Ltu/HBRWm/dv8rXeDLURqIXLntCFD77p5mfuqMdUf/zHW6GxIKPd9kqEyamddqjj7lNB19vkTP3Xj0X/2Q==",
        width: 90,
        height: 90,
        originalWidth: 90,
        originalHeight: 90,
        type: "gif",
        title: "Cat Kitten",
        slug: "cat-kitten-DS1"
    ),
      isFromCurrentUser: true,
      timestamp: Date().addingTimeInterval(-3900)
    ),
    Message(
      content: "at 4",
      mediaItem: nil,
      isFromCurrentUser: false,
      timestamp: Date().addingTimeInterval(-3700)
    ),
    Message(
      content: "",
      mediaItem:  GridItemLayout(
        id: 4575274497440569,
        url: "https://static.klipy.com/ii/d7aec6f6f171607374b2065c836f92f4/01/ef/5D5Lt4aL.gif",
        highQualityUrl: "https://static.klipy.com/ii/d7aec6f6f171607374b2065c836f92f4/01/ef/5D5Lt4aL.gif",
        mp4Media: nil,
        previewUrl: "data:image/jpeg;base64,/9j//gARTGF2YzU4LjEzNC4xMDAA/9sAQwAIBAQEBAQFBQUFBQUGBgYGBgYGBgYGBgYGBwcHCAgIBwcHBgYHBwgICAgJCQkICAgICQkKCgoMDAsLDg4OEREU/8QAcQAAAgMBAQAAAAAAAAAAAAAAAwQCBwEABQEAAwEBAAAAAAAAAAAAAAAAAAMCAQQQAAICAgEEAQUBAAAAAAAAAAIBAwARBAVBMSESIhNRBnGRFBEAAgMAAgMBAQEAAAAAAAAAAAEDAhEhEhNBYSIyBP/AABEIAB4AKAMBEgACEgADEgD/2gAMAwEAAhEDEQA/ALK2JxgD2qQKViUc3ldLyqms27W8DqUdrYPt04tQhzfIenHGcflsXj90n+eI4/pkOUu2aUj5wK6Ljht2fwt2atq9lS8Pw/Hcv+cufZgkUQyZAmnjGbcWhp6YfIYgEl1ws1vjTqZR6iI7ryvv6FzJ9tJcXqlDACPuklTBsgUjjXdUpTqUV/okVrcEOjS0LeoBIHm/Ih+fh1nbhHGanNLkrxp0vKv88oVDd7gsCfZ/2zH7dKvTGNzTTQIoXnpZoF64t0vjJJvRWX03eQes09pkut2LAbCSVZW22Ji/omRZCipVsWj16tA5gP/Z",
        width: 100,
        height: 75,
        originalWidth: 100,
        originalHeight: 75,
        type: "gif",
        title: "nails manicure",
        slug: "nails-manicure-2"
    ),
      isFromCurrentUser: false,
      timestamp: Date().addingTimeInterval(-3700)
    ),
  ]
  
  // Example messages for preview
  static let johnBrowExample = [
    Message(
      content: "Hey John",
      mediaItem: GridItemLayout(
        id: 9103889546577958,
        url: "https://static.klipy.com/ii/8ce8357c78ea940b9c2015daf05ce1a5/d1/53/5R5TB5u9.gif",
        highQualityUrl: "https://static.klipy.com/ii/8ce8357c78ea940b9c2015daf05ce1a5/d1/53/5R5TB5u9.gif",
        mp4Media: nil,
        previewUrl: "data:image/jpeg;base64,/9j//gARTGF2YzU4LjEzNC4xMDAA/9sAQwAIBAQEBAQFBQUFBQUGBgYGBgYGBgYGBgYGBwcHCAgIBwcHBgYHBwgICAgJCQkICAgICQkKCgoMDAsLDg4OEREU/8QAewAAAwEBAQAAAAAAAAAAAAAABwUGAgQDAQADAQEBAAAAAAAAAAAAAAAAAQMCBAUQAAEDAwIDBwMFAQAAAAAAAAEEAwIFABEGEiETMUFxgSKxBxRyNFEzkaFFYVMRAAMAAgMBAQEBAQAAAAAAAAABAgMRIRIEMUETgTL/wAARCAAoACgDARIAAhIAAxIA/9oADAMBAAIRAxEAPwA3LUa9xbCbc8N9otgSPyLaa0IAMSci2yd0hkRtTWU78ZuvfI2tiJyM/wCWA6lSA5lukR1b903KHqSScgzZE8HHZxuC1QqZW6lcTNOCc5vbf5vF+iJejmuXWUpHlyXPbR3YskR5/wDA80StJ65Tm1LUh54g9bndA0RXTUCXmKfLtB2ZvrT2thj0oSPNqXL0zWZ9sjaH6VGvgunOc8t9gthCcSOEgb02tCMAKa6FidwPxe2NjqM2v9z6jNDRpmJIJ/FjpTPJL1trHwOZdVot4Jl5eTlVVYrW3G+ZkEEHjYyZ1w8ncLQcJlI462qrt+nPieRrQ5nrrg6804U9mqzomKevyqTT4BEt4Ge3reKmtWvxjLeTN3p43bhCnE97ZGU39+Dv0T10kekdeahbqrSFtVjiIAA+Fz6OirmtYIZuyluLkDjxseTJ20bWt60WjzeZ4u3G0crq+rargPWjUdZ+O28seMxOIP723okdtLTA/wDOPpdY/wCORr4R9Ll5H1WkYrlsTa1p71UbKebYk0QeNsq10PcbKiankPwcXUPgyvoJpe2iOC+T0p482QLqlf6k+83JRKfAy7yVX1mScOnWo1RG2DugJxtn/apfrHrbSCfoNvQP4xo/7WtqqujqjZA5Yicd12qT7Vn6B6WfzXbZsX9n10TZxU12oQUcicMNwGAe6+lP93O3paD8D9A//9k=",
        width: 132.0,
        height: 132.0,
        xPosition: 0.0,
        yPosition: 0.0,
        originalWidth: 90.0,
        originalHeight: 90.0,
        newWidth: 132.0,
        type: "gif",
        title: "",
        slug: ""
      ),
      isFromCurrentUser: true,
      timestamp: Date().addingTimeInterval(-3900)
    ),
    Message(
      content: "Hi, how's it going?",
      mediaItem: GridItemLayout(
        id: 4365604958860190,
        url: "https://static.klipy.com/ii/c98c4a4935d23b95805f0befee091d8a/bb/67/vgHce9Yh.webp",
        highQualityUrl: "https://static.klipy.com/ii/c98c4a4935d23b95805f0befee091d8a/bb/67/vgHce9Yh.webp",
        mp4Media: nil,
        previewUrl: "data:image/jpeg;base64,iVBORw0KGgoAAAANSUhEUgAAABQAAAALCAYAAAB/Ca1DAAAACXBIWXMAAAAAAAAAAQCEeRdzAAADb0lEQVR4nCWNW0ybZQCG/xgTE93ChdGZuXiMZiwat8QNGBOIpdnINjBmLPGECWRjZk6BMXY1nS5ekCzRCzCLzo5CS1s61hbGIaPNhBVcacvZlbYcClS0pfw90P87/d9BphfPzfMmzyshJHZsZfjzcoy+Jq/TNzNx+jJMs+cI4DsJ5DuQwnOyabYrFaevJqI0N7GqvpWMqnu34vQllGbPqpA/w4h4ilPxpGDiCUnO8heicbYvtKCWBOdIWSRASmIRdb/8D31j++T1+DrNXY2oh0IBop2bxB/O+nBlcBKXrwVI0cZ2PB2nr4Ak24WzPIci/rS0lGT7vCv0WL8PX+hxwW+dTnjZM4Zqpibw6ckpcsrjw1WuUfSV3Qm/M92FP5nsoKWnFzQPu2DDpAd9GpzBx9eCpFBeU3OVBHtR8m/yw7ZFWv2jm7Rcs0PHdYti/+UO0Lf1wVbdAGy90QN117tB9zdm4LrUATxNbYr3ml75vcWiWDsc4GfHAPzBfR9+HfLjiniYHJSGN4Xm5hKrrxtVrZ/Y0XSVAYRqDWD2vBn4v7BA/1kjmPtcDxYr28B6+S2Q+EAHEh/pQPSsHgTqjWD8exMY0t1Wbo0MwcawD1VITlkcbVnml6o9tFfbR5ZKLEjWdEK51IQSGhPaLDXApEYPt4r1EBS2I1zYDnFxO1S02/6EEcY+M4DwVTNw2vpA89QorJJcSaFtXeEXa3zUprlHwgV2vFlwG6fyu/+nsAul3jOj1BEzyhSYkZJnRiDfgpT8LrR1xIqTJ61otfEOvG8egs1+D6qS3GlR1BbltQ0z9LfKB+qD4/fIXNkgnj82SILbzJ8YII/K+/Gjk314vqwXLxztwcvaXhwpvYsj2n6yeHqQTFxx4S6bBzfN/EnKpZmseKd/g5e3LLLLV2Zoa5NX1TeOq4aGcdVY76XGRi9t/895VGPdmGq94Ca2827iODemOs49pLbH241p9epImJ5aitJ3pSgSe2a3xH7XBi+zR9nH1gir7lpmNeYIO9O5ws6YVnmNeYXVdC6z2o4F9mVbiNXpQrThZphd/HWRNRgirNb5F6sIJviBRIbvkVJU5PyNxe5wVuydTYsD00l+cErmhyaSIs+XEvn+lMh7jFcWhx8mePFYnL8/GueakQ2uHU4I7R+yKApkxNsxIHYrROz8FxGFfNNyHCqAAAAAAElFTkSuQmCC",
        width: 257.0,
        height: 142.0,
        xPosition: 0.0,
        yPosition: 912.0,
        originalWidth: 100.0,
        originalHeight: 55.0,
        newWidth: 258.0,
        type: "sticker",
        title: "",
        slug: ""
      ),
      isFromCurrentUser: false,
      timestamp: Date().addingTimeInterval(-3700)
    ),
    Message(
      content: "All good",
      mediaItem: nil,
      isFromCurrentUser: true,
      timestamp: Date().addingTimeInterval(-3500)
    )
  ]
}
