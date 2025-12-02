 



rm(list = ls())
library(readxl)
library(ggplot2)
library(tidyverse)
library(sandwich)
#Key definitions 
#xBA=expected batting average
#BA= Batting average
#DRS= Defensive runs saved
#K%= strikeout percentage for hitters
#EV= Exit velocity on balls hit
#PA= Plate appearances 
#Pitch%= Percent of pitches a hitter sees vs the shift
#LA= Launch angle average of the hitters balls in play

# Just a note that shift means a team having more then two infielders on one side of second base.
# Because this is now illegal offenses should have more room to hit the ball on the ground
data<-read_excel("C:/Users/owner/shift_percentage_of_top_10_teams.xlsx", sheet = "def")

length(which(data$`Shift percentage over last 3 seasons`>32))
#32% is the average percent of how often a team shifted
length(which(data$`Shift percentage over last 3 seasons`>36.4))
# A team had to shift at least 36.4% of the time to be placed in the top 10 in defensive shift percentage
## Bring in the file from wherever it is saved.
LSP<-read_excel("C:/Users/owner/shift_percentage_of_top_10_teams.xlsx", sheet = "LSP")
head(LSP)
ggplot(LSP,aes(x=LeagueYear ,y=ShiftPercentage))+
  geom_line(colour= "red")+ ylim(0,40)+
xlab("League Year")+ylab("Shift Percentage")+
  theme_classic()
  
#How often teams shifted since 2016 
#we can see an dramatic increase over time 
## Bring in the file from where ever it is saved
LSH<-read_excel("C:/Users/owner/shift_percentage_of_top_10_teams.xlsx", sheet = "LSH")
head(LSH)
ggplot(LSH,aes(x=Year, y=Strikeouts))+
  geom_line(colour= "blue") +ylim(15000,45000)+
  theme_classic()
#As Shift Percentage went up so did strikeouts
#exception was 2020 shortened season because of Covid
#in 2020 only 60 games were played instead of 162

LVR<-read_excel("C:/Users/owner/shift_percentage_of_top_10_teams.xlsx", sheet = "LVR")
head(LVR)
LVR %>% glimpse()
ggplot(data=LVR,aes(x=LHPitch,))+
  geom_boxplot(fill= "dodger blue")+
  coord_flip()+ xlim(0,100)+
  ggtitle("% of Pitches Against the Shift") +
  xlab("Left Handed Hitters %")

ggplot(data=LVR,aes(x=RHPitch,))+
  geom_boxplot(fill= "orange")+
  coord_flip()+ xlim(0,100)+
  ggtitle("% of Pitches Against the shift")+
  xlab("Right Handed Hitters %")

#Ran Summary to compare RHH to LHH 
#Left handed hitters vs the shift
#The percent of pitches the top 50 hitters faced vs the shift

merged<-read_excel("C:/Users/owner/shift_percentage_of_top_10_teams.xlsx", sheet = "merged")
head(merged)
ggplot(merged,aes(x=SP,y=DRS,))+geom_point()+xlim(10,60)+ylim(0,40)+
theme(panel.background = element_rect(fill = "light blue", color = "black"))+
ggtitle("Shift Percentage vs DRS")+  
annotate("text", x = 20, y = 30, label = "Target Teams")+
geom_vline(xintercept=33)+geom_hline(yintercept=15)
length(which(merged$SP<33 & merged$DRS >15))
  

#9 teams shift less than league average but have more than league average defensive runs saved

sortedData2<-merged[order(merged$SP, merged$DRS),]
#Using the sort function by Shift percentage first we can see in ascending order of the team's shift percentage
#Then by sorting by defensive runs saved we can see the 9 target teams
#League average for DRS was 15
#League average for shift percentage was 33%

FA<-read_excel("C:/Users/owner/shift_percentage_of_top_10_teams.xlsx", sheet = "FAEV")
head(FA)
ggplot(FA,aes(x=EV,y=OAA,color="EV/OAA"))+geom_point()+xlim(80,95)+ylim(-12,12)+
geom_vline(xintercept=88)+geom_hline(yintercept=0)+
 theme(panel.background = element_rect(fill = "light green", color = "black"))+
annotate('text', x = 89.5, y = 8.5, label = 'Bellinger')+
annotate('text', x = 92, y = 7, label = 'Nimmo')+
annotate('text', x = 93, y = -10, label = 'Pederson')
length(which(FA$EV>88 & FA$OAA >0))
sortedFA1<-FA[order(FA$EV, FA$OAA, decreasing = TRUE),]

#5 players have above average Exit Velocity and above 0 Outs Above Average
#Bellinger and Nimmo are two players who are above average in EV but are also great defensive players which is needed without a shift
#Pederson is a great offensive player but a liability on defense so his future contract should relflect that
#League average is 0 for Outs above replacement
#League average for Exit Velocity was just below 88 MPH

#Top 15 Left handed hitters available in FA
#Teams should seek higher then average EV paired with outs above average on defense
#Table separating hitters into pull frequency categories 
Pull<-read_excel("C:/Users/owner/shift_percentage_of_top_10_teams.xlsx", sheet = "ABstats")
Pull$PitchPercent <- cut(Pull$PitchPercent,
                         breaks = c(0, 30, 60, 90, Inf),
                         labels = c("Barely Shifted", "Average Shift", "Pull Hitter", "Extreme Pull"))
table(Pull$PitchPercent)
Pull<-read_excel("C:/Users/owner/shift_percentage_of_top_10_teams.xlsx", sheet = "ABstats")
recencyBins <- quantile(Pull$PitchPercent, probs=seq(0, 1, by=0.20))
recencyBins
Pull$PitchPercent <- cut(Pull$PitchPercent,
                    breaks=recencyBins,labels=c("1", "2", "3", "4", "5"), 
                    include.lowest=TRUE, right=FALSE)
head(Pull$PitchPercent)



#Out of a sample of 400 hitters, 97 were barely shifted, 103 were average
#91 were classified as pull hitters and 9 were extreme pull
#the 9 extreme pull hitters should benefit the most from the shift ban

#Null hypothesis or H0= Bavg1=Bavg2
#Alternative or Ha= Bavg1<> Bavg2
#Bavg1= Batting average of players before the ban.
#Bavg2= Expected batting average if the shift was banned this season
#Sample size 200 LHH and 200 RHH
#sorted by the 400 hitters who faced the most pitches vs the shift
Htest<-read_excel("C:/Users/owner/shift_percentage_of_top_10_teams.xlsx", sheet = "Htest")
Hypothesis=data.frame(Htest)
mean(Hypothesis$LHBA,)
colMeans(Hypothesis[sapply(Hypothesis, is.numeric)])

t.test(Htest$LHBA, mu= .216, alternative="two.sided") 
t.test(Htest$RHBA, mu= .216, alternative="two.sided") 
#After running the average of the columns LHH had an average .216 before the ban and an expected average .223
#RHH had an average of .242 against the shift but the expected batting average with no shift goes down to .239
#Hypothesis testing 2
#Because Left handed hitters faced the shift more often they should have an expected batting average higher then right handed hitters.
Htest<-read_excel("C:/Users/owner/shift_percentage_of_top_10_teams.xlsx", sheet = "Htest")
Left<-c(Htest$LHxBA)
Right<-c(Htest$RHxBA)
t.test(Left, Right,alternative = "greater", var.equal=FALSE)
#H0= LHH XBA > RHH XBA
#HA= LHH XBA = or < RHH XBA
#Sample size 200 RHH and 200 LHH
#Welch Two sample t-test shows that right handed hitters have a higher expected batting average
#Have to reject the null hypothesis
Lshift<-c(Htest$`Pitch %...4`)
Rshift<-c(Htest$`Pitch %...11`)
t.test(Lshift, Rshift, alternative= "less", var.equal=FALSE)
#H0= Left handed hitters shift percentage > than right handed hitters
#Ha= Left handed hitters shift percentage = or < than right handed hitters
#Welch's test shows that 100% of the time left handed hitters had a higher percentage of pitches vs the shift


Htest<-read_excel("C:/Users/owner/shift_percentage_of_top_10_teams.xlsx", sheet = "Htest")
Hypothesis=data.frame(Htest)
mean(Hypothesis$LHBA,)
colMeans(Hypothesis[sapply(Hypothesis, is.numeric)])
t.test(Htest$LHxBA, mu=.223, alternative= "greater")

t.test(Htest$RHxBA, mu=.239, alternative= "less")
summary(aov(Htest$LHxBA~Htest$`Pitch %...4`))
summary(aov(Htest$RHxBA~Htest$`Pitch %...11`))
#LHH expected batting average without the shift is .223 
#RHH expected batting average without the shift is .239

#what is the probability if 
#.2% of baseball players have over a 90 average EV
# and 25% of the baseball players are left handed
#what is the probability that a player bats left handed and has an EV over 90?
bayesTheorem <- function(pA, pB, pBA) {
  pAB<-pA*pBA/pB
  return(pAB)
}
pEV<-.31
pLeft<-.25
pLHEV<-.08
bayesTheorem(pEV,pLeft,pLHEV)
#Suppose a hitter has a 31% chance of having an Exit Velocity over 90 MPH
#A hitter has a 25% chance of being Left handed
#The probability that the player is left handed and has an EV over 90 is 9%

ppois(.25, lambda=.30,)
#Using the Poisson distribution there is a 74% chance left handed hitters stay below 30% of total hitters in the MLB
#Knowing this left handed hitters who are creating elite exit velocity and OAA on defense should be extremely vaulable in FA. 


data<-read_excel("C:/Users/owner/shift_percentage_of_top_10_teams.xlsx", sheet = "regression")
head(data)
#need to turn off scientific notation
options(scipen=999)
Multiple<-lm(xBA~PA+BA+EV, data=data)
summary(Multiple)
#Adjusted R squared=.1939

#looking at variables without including handedness of hitter

Multiple2<-lm(xBA~PA+BA+EV+Handedness, data=data)
summary(Multiple2)
#adds handedness into the regression to see if it is significant 
#Adjusted R squared=.1912
Multiple3<-lm(xBA~PA+EV+Handedness+League, data=data)
summary(Multiple3)
# Takes out batting average and adds either American League or National League
#Adjusted R squared=.1637
ABstats<-read_excel("C:/Users/owner/shift_percentage_of_top_10_teams.xlsx", sheet = "ABstats")
Multiple4<-lm(xBA~PitchPercent+BIP+Kpercent+EV,data=ABstats)
summary(Multiple4)
# different data set... Looking at specific variables related to how often and how hard the ball is hit
#Adjusted R squared= .5868
ABstats<-read_excel("C:/Users/owner/shift_percentage_of_top_10_teams.xlsx", sheet = "ABstats")
Multiple5<-lm(xBA~PitchPercent+BIP+Kpercent+EV+LA, data=ABstats)
summary(Multiple5)
#Adjusted R squared=.6005
#highest adjusted r squared of the gorup.. added launch angle
ABstats<-read_excel("C:/Users/owner/shift_percentage_of_top_10_teams.xlsx", sheet = "ABstats")
Multiple6<-lm(xBA~PitchPercent+BIP+Kpercent+EV+LA+Handness, data=ABstats)
summary(Multiple6)
#adjusted r squared=5.999
#added handedness which was not significant 


##Using the 5th regression model 
#wanted to show relationships between xBA and the variables by having the best fit lines

Bestfit<-read_excel("C:/Users/owner/shift_percentage_of_top_10_teams.xlsx", sheet = "regression")
#Best fit for exit velocity and xBA
EVBA=data.frame(Bestfit)
ggplot(EVBA, aes(x=EV, y=xBA)) +
  geom_point() + ylim(.1,.40)+
  geom_smooth(method=lm, se=FALSE)+
  ggtitle("How Exit Velocity Impacts Expected Batting Average")+
  geom_vline(xintercept=87)+
  theme_classic()
#87MPH is league average so we can see a positive relationship
#with expected batting average for players who average above average exit velocity

#Best fit for Plate appearances and xBA
#not as significant because less then 50 plate appearances does not qualify hitters for awards or statistics 
#only looked at ABs vs the shift
Bestfit<-read_excel("C:/Users/owner/shift_percentage_of_top_10_teams.xlsx", sheet = "regression")
PAxBA=data.frame(Bestfit)
ggplot(PAxBA, aes(x=PA,y=xBA))+
  geom_point()+
  geom_smooth(method=lm, se=FALSE)
#best for for balls in play compared to xBA
#does putting the ball in play always lead to a higher average?
Bestfit<-read_excel("C:/Users/owner/shift_percentage_of_top_10_teams.xlsx", sheet = "ABstats")
BIPxBA=data.frame(Bestfit)
head(BIPxBA)
ggplot(BIPxBA, aes(x=BIP, y=xBA))+
  geom_point()+
  geom_smooth(method=lm, se=FALSE)+theme_bw()

#K% compared to xBA
#we can see that the goal should be to strikeout less then 20% of the time or see diminishing return on expected BA
Bestfit<-read_excel("C:/Users/owner/shift_percentage_of_top_10_teams.xlsx", sheet = "ABstats")
KxBA=data.frame(Bestfit)
head(KxBA)
ggplot(KxBA, aes(x=Kpercent, y=xBA))+
  geom_point()+
  geom_smooth(method=lm, se=FALSE)+
  ggtitle("How K% impacts XBA")+theme_classic()
#one of the most interesting charts
#players were able to have above average EV while having over 400 balls in play. These players hit the ball hard and often which will lead to them succeeding vs the shift
Bestfit<-read_excel("C:/Users/owner/shift_percentage_of_top_10_teams.xlsx", sheet = "ABstats")
BIPxEV=data.frame(Bestfit)
head(BIPxEV)
ggplot(BIPxEV, aes(x=EV, y=BIP))+
  geom_point()+
  geom_smooth(method=lm, se=FALSE)

