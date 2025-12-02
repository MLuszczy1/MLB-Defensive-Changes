# MLB Shift Ban Defensive Changes from the 2023 Season

## Description
This Project looks at the potential defensive changes after the shift was banned in the 2023 season. Which players will benefit the most and which teams should improve defensively.
Also, looking at free agents and seeing which ones will sign the larger contracts based on league history and potential.
the Bayes Theorem also shows the probability of player performance and free agent decisions going forward.

## Features
Multiple graphs showing defensive performance based on shift percentage.
Offensive output based on how often batters are shifted against.
LHH/RHH and which side benefits the most from the shift ban.
Free agent decisions and future batting handness of players in the league and why the ban happened.
## Project Structure
1. Definitions to know
2. Explaination of increase of shift percentage and how often teams are shifting.
3. This lead to players trying to hit more home runs and strikeouts increased and less balls were put in play.
4. Which free agents will benefit from the shift being bad (Cody Bellinger was a FA and would benefit the most during this project)
5. Used probability of potential players joining the league and past hitting metrics to determine free agent price and why the ban will continue to happen.
6. Offers reason and personal opinions of how teams can be better defensively and why certain players are paid above market price compared to others.
## How to Run the App
I completed this proect a couple years ago so when I brought in the excel file I made sure to read each sheet seperately so I could look back and see what I did.
For the app to work the user just needs to make sure the packages listed are active and then bring in the excel file from wherever they have it saved. 
I already went through and brought the information in from a database and cleaned it in excel so no cleaning needs done.
Once the file is loaded in the user can just read different sheets instead of "reading the excel" everytime to get to a different sheet.
## Required Inputs
(readxl)
(ggplot2)
(tidyverse)
(sandwich)
Key definitions:
xBA=expected batting average,
BA= Batting average,
DRS= Defensive runs saved,
K%= strikeout percentage for hitters,
EV= Exit velocity on balls hit,
PA= Plate appearances, 
Pitch%= Percent of pitches a hitter sees vs the shift,
LA= Launch angle average of the hitters balls in play

## Future Improvements
For the future we can see if the changes helped different hitting metrics and if the ball is put in play more. We can see if the FA contacts worked out for the various players. 
We tried prediciting how many players could hit left or right handed and still have a 90 exit velocity so we can see if the predicitions are close to the players in the league now.
Did the teams who shifted the least actually end up playing the best defense after the ban?

## Author
Mark Luszczynski
