# BdC app

**Bdc** is an app created to take the attendance of a group of friends who meet on daily basis in a common place.<br> 
It was born as a way to avoid using excel files, time sheets or things like that.
The app is designed to be used by a single administrator who manages the attendance of all users and shares them with others, via a pdf that can be filtered by time frame.<br>
Over time, many specific features have been added, many of which are still in the works, such as attendance difficulties, confetti to celebrate 100% attendance in a given period and the inability to register attendance on holidays.<br>
The app is fully developed in **Swift (UIKit)**, it doesn't have any networking and all the attendance are saved using **CoreData**. All the design is made entirely by me using Figma.
<br><br>
  <div align="center">
    <img src="https://user-images.githubusercontent.com/28431608/200068483-343f0a2f-5e7e-455c-97b6-ceba9bccda02.svg" width="180"/>
  </div>
<br><br>

## Calendar View
It's the view displayed when the app starts and it's used to take attendances or to view the attendees of a past day.
<br>
  <div align="center">
    <img src="https://user-images.githubusercontent.com/28431608/200119111-82973029-d9f6-409b-a76a-9af46a7f6ad7.png" width="730"/>
  </div>
<br>
The calendar is displayed weekly by default but with a scroll it can become monthly. Clicking on a specific person's card makes them present for that day in that specific slot (morning or afternoon) while the long press gives them a warning (system created to avoid unfulfilled reservations).
The collection view used to display the persons has a search bar, visible only when scrolling down, that can be used to filter elements. 
<br><br>

## Ranking View
The main purpose of this section is to display the number of appearances made in a given period. By default, the display is weekly, so using a horizontal scroll you can move from week to week. By clicking on a specific person, the cell expands showing on which days of the week the attendance or warnings were made.
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

<br><br>

## Settings View
The settings allow the user to customize different things around all the app such as: avoid modification old days, show percentage of attendance in chosen time frame,  show/hidden confetti it a person complete a perfect period (100 % attendance) and the possibility of multiplying the all-time attendance by a difficulty coefficient based on the distance between the chosen location and the person's residence. 
<br>
  <div align="center">
    <img src="https://user-images.githubusercontent.com/28431608/200118826-3e960423-a437-4fd1-a9a4-178ea705d592.png" width="730"/>
  </div>
<br>
As you can see, the people list is dynamic and people can be added / removed at any time.

<br><br>

## Future development

