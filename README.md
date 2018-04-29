# ARK-Fund
FINA4353 Financial Engineering Structured Product Design Project

@ Description:
  This is a self-designed structured product for course FINA4353.

@ Authors:

    BAI Yang
  
    CAO Wenxin
  
    HUANG Feiqing
  
    LIN Pingyi
  
    LU Yuqiao

@ Date: 4/27/2018

@ URL: https://github.com/Jacobhob/ARK-Fund


# Instruction for Using the Package:

## Files contained and usage:

### Packages installed for runing the code:
"mnormt": For calculating cdf for nomal (binomial nomal) distribution. <br>
"data.table": For writing results to csv files.

### Master scripts:
#### ARK.R: 
This module is developed for generating portfolio performance simulation results <br>
for our structured product. <br>
The default # of trials is 5. <br>
You could freely set the number by changing the variable time in Line 36.

#### Backtest.R: 
This module is developed for generating backtesting results for the portfolio <br>
in bear and bull market using empirical data.

### Supporting modules:
#### simulation.R:
This module provides a supporting function for simulating portfolio performance.
#### options.R:
This module provides functions for pricing component options.
#### backtest.source.R:
This module provides a supporting function for tracking <br>
portfolio performance on historical data.

### Input data:
#### BacktestBear.rds: 
This file contains the historical price data for HSI in 2007~2009 bear market.
#### BacktestBull.rds:
This file contains the historical price data for HSI in 2016~2018 bull market.

### Additional Directory:
#### ARK-Fund_MC:
This directory is similar to the original one. <br>
The only difference is that we use Monte Carlo Method for pricing put on put. <br>
The result is consistent with the original one.

## Run program by command line:
    This program can be executed by command line under Linux environment.
    For R environment, we suggest using R version 3.4.4 (2018-03-15).
#### First, enter the directory of this file by command line
#### To run simulations on current stock price, execute: 

$ R <./code/ARK.R --save <br>

#### Output of the program:

  A directory "Simulations" will be created for storing the results. <br>
  
  Seven csv files will be generated and saved to ./data/Simulations: <br>
  
  
  "BANK.csv" will store the bank revenue for each simulation, <br>
  with specific revenue generated in each 0.5 years stored separately; <br>
  
  
  "CASH.csv" will store the value of investment in risk-free asset <br>
  on each trading day for each simulation; <br>
  
  
  "KNOCKOUT.csv" will store the knockout day for each simulation, <br>
  and x=0 means no knockout occurs in this simulation; <br>
  
  
  "PRICE.csv" will store the simulated HSI price in each simulation; <br>
  
  
  "RETURN.csv" will store the cumulative return of the portfolio; <br>
  
  
  "TOTAL.csv" will store the total value of the portofolio, including investment <br>
  in risk-free asset, value of options, and coupons distributed to investors. <br>
  
  
  "VALUE.csv" will store the value of exsisting options in the portfolio. <br>
  
  Graphs are also generated for each simulation. <br>
  
  Graphs will be stored under ./data/Simulations/Graph/ <br>
  and simulation data will be stored in .csv files under ./data/Simulations/ <br>
#### To run backtesting with two given datasets, execute: 

$ R <./code/Backtest.R --save

#### Output of the program:

  Seven csv files will be generated, which contains the backtesting results <br>
  for bear and bull markets. <br>
  Please refer to last part for the detailed contents of these csv files. <br>
  
  Two graphs will be generated, showing changes in price, value, cash and <br>
  total value for bull and bear markets backtesting. <br>
  
  Data will be stored in .csv files under ./data/Backtests/ and <br>
  graphs of the two backtesting will be stored undner ./data/Backtests/Graph <br>

## Run program using RStudio
#### Download and extract ARK-Fund from Github
#### Then open RStudio by GUI or execute under the directory of this file: 

$ rstudio ./code/*.R &
#### Set up working directory
 
Use setwd({the path of this file}) to change the working directory.
#### Run all the lines in ARK.R to do simulations.
#### Run all the lines in Backtest.R do backtesting on two given datasets.
