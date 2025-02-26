# RecipeFetch
Coding challenge - A recipe app that displays downloaded recipes

## Summary: 
### Features:
#### System fonts used for accessibility
![](Images/RecipeFetch1.PNG )

![](Images/RecipeFetch3.PNG )

![](Images/RecipeFetch5.PNG )
![](Images/RecipeFetch6.PNG )
![](Images/RecipeFetch7.PNG )
#### Also includes: 
* image caching
* unit tests
* network mocking
* async await networking
* expandable cell for links
* Sorting on Name, Cuisine, Has Recipe Link, Has Video Link
* filters on search text
* Combine functionality for ease in error handling
* Supports light and dark mode

### Focus Areas: What specific areas of the project did you prioritize? Why did you choose to focus on these areas?
I wanted to make the app testable. So, I prioritzed viewmodels for testability.  Also, I wanted to provide mocking for geniune unit tests that did not depend on network connectivity.  I am new to SwiftUI with networking. So, I spent a lot of time learning with Combine tutorials. I took two Udemy classes (SwiftUI & Combine) in order to gain the understanding of what needed to be done. Because of that, a lot of step-wise refinement was involved as I delved deeper into the project and the requirements.

### Time Spent: Approximately how long did you spend working on this project? How did you allocate your time?
I worked on this project only a few hours at a time as I was able.  As well, I frequently had to go investigate areas by visiting and revisiting my Udemy classes. So, calendar-wise, it took me longer than I would like to admit. But, if I were working in one dedicated period, I probably spent 1.5 - 2 weeks (60 - 80 hours)

### Trade-offs and Decisions: Did you make any significant trade-offs in your approach?
To truly be a production app, it should have localization. But I felt like I had spent enough time on this project for now. To get the horrible hard-coded text out of the view, I put them in the viewmodel and made a test for them.  Another trade-off, normally, 1 thing is asserted per test. But, testing text is so trivial. (But not unimportant, with respect to quality review.) I have other tests with multiple asserts. But they are leading up to the main point of the test.

### Weakest Part of the Project: What do you think is the weakest part of your project?
I don't care for the menu. The white on white is awkward.  The colored navigation bar view helps some.  I think the sorts are not interesting. But, there was only so much to sort/filter. Looking at the code, I am bothered by the lack of localization.

### Additional Information: Is there anything else we should know? Feel free to share any insights or constraints you encountere
I didn't even try the test urls until late in the project.  When I realized what I was missing, I tried to integrate those "problems" into the unit tests. So, I mocked them as well. I was not successful. But, I left the mocks for future work.
