shinyUI(pageWithSidebar(  
  headerPanel("Risk Battle Simulator!"),  
  sidebarPanel(    
    h4('Welcome to the Risk Battle Simulator.'),
    p('This app is designed to simulate attacking a territory in the boardgame "Risk" from Hasbro, and display statistics on the probability of conquering the territory, and the number of armies the attacker is likely to have left at the end of the attack'),
    p(''),
    h4('Instructions:'),
    p('To use this app, simply use the sliders below to select the number of armies that both the attacker and defender are starting with.  The app will then simulate the full battle 1,000 times and display summary statistics.'),
    sliderInput('a_armies', 'Starting number of attacking armies',value = 20, min = 2, max = 50, step = 1,),  
    sliderInput('d_armies', 'Starting number of defending armies',value = 10, min = 1, max = 50, step = 1,)  ), 
  mainPanel(    
    h4('Histogram of Number of Armies Attacker has Remaining at Conclusion of Battle'),
    plotOutput('myHist'),
    p('* Note: Attacker can never lose all armies on attack role, at 1 remaining army attacker can no longer attack'),
    h4(''),
    h4('Risk Boardgame Instructions:'),
    p('http://www.hasbro.com/common/instruct/risk.pdf')
  )
))