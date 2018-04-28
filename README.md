# ARK-Fund
FINA4353 Financial Engineering Structured Product Design Project

@ Description:
  This is a self-designed structured product sample for FINA4353 Financial Engineering.

@ Authors:

    BAI Yang
  
    CAO Wenxin
  
    HUANG Feiqing
  
    LIN Pingyi
  
    LU Yuqiao

@ Date: 4/27/2018


# Instruction for Using the Package:

## Files contained and usage:

### Master scripts:
#### ARK.R: 
This module is developed for generating portfolio performance simulation results for our structured product.
#### Backtest.R: 
This module is developed for generating backtesting results for the portfolio in bear and bull market using empirical data.

### Supporting modules:
#### simulation.R:
This module provides a supporting function for simulating portfolio performance on pre-determined conditions.
#### options.R:
This module provides functions for calculating prices for European put, European call, and put on European put.
#### backtest.source.R:
This module provides a supporting function for tracking portfolio performance on historical data.

### Input data:
#### BacktestBear.rds: 
This file contains the historical price data for HSI in 2007 ~ 2009 bear market.
#### BacktestBull.rds:
This file contains the historical price data for HSI in 2016 ~ 2018 bull market.

## Run program by command line:
    This program can be executed by command line under Linux environment.
    For R environment, we suggest using R version 3.4.4 (2018-03-15) -- "Someone to Lean On" to run this set of programs.
#### First, enter the directory of this file by command line
#### To run simulations on current stock price, execute: 

$ R <ARK.R --save <br>

#### Output of the program:

  A directory "Simulations" will be created under the current directory for storing the results. <br>
  
  Seven csv files will be generated and saved to ./Simulations: <br>
  "BANK.csv" will store the bank revenue for each simulation, with specific revenue generated in each 0.5 years stored separately; <br>
  "CASH.csv" will store the value of investment in risk-free asset on each trading day for each simulation; <br>
  "KNOCKOUT.csv" will store the knockout day for each simulation, and x=0 means no knockout occurs in this simulation; <br>
  "PRICE.csv" will store the simulated HSI price on each trading day in each simulation; <br>
  "RETURN.csv" will store the cumulative return of the portfolio at the end of the contract for investors; <br>
  "TOTAL.csv" will store the total value of the portofolio, including investment in risk-free asset, value of options, <br>
   and coupons distributed to investors. <br>
  "VALUE.csv" will store the value of exsisting options in the portfolio on each trading day. <br>
  
  Graphs for price, value, cash and total value are also generated for each simulation. <br>
  
  Graphs will be stored under ./Simulations/Graph/ and simulation data will be stored in .csv files under ./Simulations/ <br>
#### To run backtesting with two given datasets (BacktestBear.xlsx and BacktestBull.xlsx), execute: 

$ R <Backtest.R --save

#### Output of the program:

  Seven csv files will be generated, which contains the backtesting results for bear and bull markets. <br>
  Please refer to last part for the detailed contents of these csv files. <br>
  
  Two graphs will be generated, showing changes in price, value, cash and total value for bull and bear markets backtesting. <br>
  
  Data will be stored in .csv files under ./Backtests/ and graphs of the two backtesting will be stored undner ./Backtests/Graph <br>

## Run program using RStudio
#### First, open RStudio by GUI or execute under the directory of this file: 

$ rstudio *.R &
#### Set up working directory
 
Use setwd({the path of this file}) to change the working directory.
#### Run all the lines in ARK.R using RStudio to run simulations.
#### Run all the lines in Backtest.R using RStudio to run backtests on two given datasets.
