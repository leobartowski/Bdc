<div align="center">
  <img src="https://github.com/user-attachments/assets/d0e9b840-aeb4-4802-bd13-0f2ad8355242"/>
</div>
<br>

# BdC

**Bdc** is an app created to take the attendance of a group of friends who meet on daily basis in a common place.
<br>
  <div align="center">
    <img src="https://github.com/user-attachments/assets/97679415-be0e-49e9-9912-361cd6971079" width="730"/>
  </div>
<br>

### Why

This app was created as a solution to replace traditional methods like Excel files, time sheets, or similar tools for managing attendance. It is designed for a single administrator to track attendance for all users and share the data via PDF, with options to filter by time frame.<br>
The app features a dedicated section for detailed attendance statistics, offering insights on both individual and group data.<br>
Over time, many specific features have been added, many of which are still in the works, such as attendance difficulties, confetti to celebrate 100% attendance in a given period and the inability to register attendance on holidays.<br>
I created this project for **personal use** and not for commercial distribution so many features have not been created in the best way possible but only with the purpose of being functional to my needs.
<br><br>

<br>
  <div align="center">
    <img src="https://user-images.githubusercontent.com/28431608/200068483-343f0a2f-5e7e-455c-97b6-ceba9bccda02.svg" width="180"/>
  </div>
<br>

# Detail
The app is divided in four main section: 
- [Calendar](#Calendar)  
- [Ranking](#Ranking)
- [Statistics](#Statistics)  
- [Settings](#Settings)   

## Calendar
It's the view displayed when the app starts and it's used to take attendances or to view the attendees of a past day.
<br>
  <div align="center">
    <img src="https://user-images.githubusercontent.com/28431608/200119111-82973029-d9f6-409b-a76a-9af46a7f6ad7.png" width="730"/>
  </div>
<br>

The calendar is displayed weekly by default but with a scroll it can become monthly. Clicking on a specific person's card makes them present for that day in that specific slot (morning or afternoon) while the long press gives them a warning (system created to avoid unfulfilled reservations).
At the bottom of the collection view, a counter displays the number of people present and those admonished.
<br>
  <div align="center">
    <img src="https://github.com/user-attachments/assets/3b9d1931-69e0-4bdd-9f2c-df60180ffaa2" width="343"/>
  </div>
<br>

## Ranking
The primary purpose of this section is to display the number of appearances made during a specific period. By default, the display shows weekly data, which can be navigated using horizontal scrolling to move between weeks. Clicking on a person's name opens a modal with their individual statistics ([Statistics](#Statistics) for details), while clicking elsewhere on the cell expands it to reveal detailed information about the specific days of the week when attendance or warnings were recorded.
<br>
  <div align="center">
    <img src="https://user-images.githubusercontent.com/28431608/200119232-0c385900-fe36-4de0-bf3e-9e3058559920.png" width="730"/>
  </div>
<br>
The user, using the two button on the top left, can change the time period (week, month, year or all-time)  and the slot (morning, evening or both) used to calculate the number of attendances.
<br>
  <div align="center">
    <img src="https://user-images.githubusercontent.com/28431608/200117808-988002e6-fb85-4f3a-be52-8edb3931826c.png" width="600"/>
  </div>
<br>
After the user has chosen the time frame and the slot he is interested in, he can share attendance in pdf. The app will automatically generate a file indicating the filters chosen and the number of appearances and warnings for each user.
<br>
  <div align="center">
    <img src="https://user-images.githubusercontent.com/28431608/200118095-9718ef17-cc45-45b3-9532-5f78cc0f2db8.png" width="600"/>
  </div>
<br>

## Statistics
The Statistics section of the app provides detailed insights into attendance data, catering to both group-level and individual-level analysis. While both modes share the same view controller for a consistent user experience, each mode includes sections tailored to its specific focus.

- **Group Statistics**: Accessible via an item in the tab bar, this mode provides an overview of attendance data for the entire group. It offers aggregated insights and trends that help identify patterns across all users.
- **Individual Statistics**: To view the statistics of a specific person, navigate to the Ranking tab and click on their name. This action opens the individual statistics view, which highlights the attendance history and trends of the selected person.

<br>
  <div align="center">
    <img src="https://github.com/user-attachments/assets/41e1eb5f-5ccf-4438-b8eb-4e91e282a489" width="730"/>
  </div>
<br>

## Settings
The settings allow the user to customize different things around all the app such as: avoid modification old days, show percentage of attendance in chosen time frame,  show/hidden confetti it a person complete a perfect period (100 % attendance) and the possibility of multiplying the all-time attendance by a difficulty coefficient based on the distance between the chosen location and the person's residence. 
<br>
  <div align="center">
    <img src="https://github.com/user-attachments/assets/30ff3024-4a15-4b6e-a745-bdbdfad3d6ce" width="730"/>
  </div>
<br>

As you can see, the people list is dynamic and people can be added / removed at any time.<br>
In the settings it's possible to see all the <b>amazing open-source projects (❤️)</b> that helped the creation of this app. 
<br>
  <div align="center">
    <img src="https://github.com/user-attachments/assets/d2b70c22-23af-47b5-96e6-a54ba1be02e2" width="730"/>
  </div>
<br><br>

# Development
### How
The app is fully developed in **Swift (UIKit)**, it doesn't have any networking and all the attendance are saved using **CoreData**. All the design is made entirely by me using Figma.<br><br>
I use <a href="https://trello.com/b/8DADGcxG/bdc">this Trello board</a> to keep track of bugs and 
nice things to implement, take a look if you want. Suggestions and constructive criticisms are always welcome so feel to leave a comment!

## Requirements

iOS Deployment Target | Xcode Version | Swift Language Version
------------ | ------------- | -------------
17.0 | 16.0 | Swift 5

### Installation
1. Install [CocoaPods](https://cocoapods.org).
2. Go to the project directory in terminal and execute `pod install`.

### Configure Signing
1. Open `Bdc.xcworkspace` with Xcode.
2. In Xcode navigate to the [Signing & Capabilities panel](https://developer.apple.com/documentation/xcode/adding_capabilities_to_your_app) of the project editor.
3. Change `Team` to your team.
4. Change `Bundle identifier` to something unique.

### Run
1. In Xcode use the Scheme menu to select the Bdc scheme.
2. Run  the app.
<br><br>

# License
This project is licensed under the terms of the <a href="https://github.com/leobartowski/Bdc/blob/main/LICENSE">MIT</a> license.
