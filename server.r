library(shiny)

simudice <- function(armies){
  score<- armies
  a_dice <- min(armies[1]-1,3)
  d_dice <- min(armies[2],2)
  
  a_roll <- sample(1:6,a_dice,replace = TRUE)
  d_roll <- sample(1:6,d_dice,replace = TRUE)
  #print("attacker rolls")
  #print(a_roll)
  #print("defender rolls")
  #print(d_roll)
  
  at_risk <- min(a_dice,d_dice)
  #print("armies at risk")
  #print(at_risk)
  
  #outcome of highest
  out1<- battle(a_roll,d_roll,1)
  
  
  #   
  #   if (max(a_roll) > max(d_roll)){
  #     defender <- defender -1
  #   } else {
  #     attacker <- attacker -1
  #   }
  
  #outcome of next highest if applicable
  if (at_risk >1){
    out2<-battle(a_roll,d_roll,2)    
  }else { out2<- c(0,0)
  }
  
  #print("dice rolled")
  #print(c(a_dice,d_dice))
  
  return(score + out1 + out2)
  
  
  
  #end of simudice
}


battle <- function(a_roll, d_roll,n){
  if (sort(a_roll,decreasing = TRUE)[n] > sort(d_roll,decreasing = TRUE)[n]){
    loss <- c(0,-1)
  } else {
    loss <- c(-1,0)
  }
  
  return(loss)
  #end of battle2
}

wargame2<- function(armies){
  score <- armies
  for (i in 1:10000){
    #print(score)
    score <- simudice(score)
    if (score[1]<2){
      #print("Defender wins")
      tally <- (c(0,1))
      break}
    if (score[2]<1){
      #print("Attacker Wins")
      tally <- (c(1,0))
      break}
  }
  #print(score)
  return(c(tally,score))
  
  #end of wargame
}

metawargame2 <- function(attack_armies,defender_armies,trials){
  armies<- c(attack_armies,defender_armies)
  tally <- c(0,0)
  score_a <- vector(mode="numeric", length=0)
  score_d <- vector(mode="numeric", length=0)
  
  for (i in 1:trials){
    temp <- wargame2(armies)
    tally <- tally + temp[1:2]
    score_a <- append(score_a,temp[3])
    score_d <- append(score_d,temp[4])
  }
  
  #print (tally)
  attack_odds <- (tally[1]/(tally[1]+tally[2]))
  
  return (list("attack_odds" = attack_odds,"attack_armies" = score_a, "defender_armies" = score_d))
  
}

shinyServer(  
  function(input, output) {    
    
    output$myHist <- renderPlot({      
      temp <- metawargame2(input$a_armies,input$d_armies,1000)
      avg_a <- round(mean(temp$attack_armies),1)
      prob_v <- temp$attack_odds
      hist_title <- paste("Probability of Victory ",prob_v)
      hist(temp$attack_armies, xlab='Remaining number of attacking armies', col='lightblue',main = hist_title,breaks = 50, xlim = c(0,60))      
      abline(v = avg_a, col = "red", lwd = 2)
     
      text(avg_a,20 , paste("mean armies= ", avg_a))      
    })
  
  
  }
)