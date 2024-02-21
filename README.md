# 20 DMA Strategy
This trading strategy revolves around the dynamic relationship between the Current Market Price (CMP) and the 20-day Daily Moving Average (20 DMA). In this approach, all trades are executed based on the calculated difference between the CMP and the 20 DMA. This differential factor serves as a crucial metric, guiding the decision-making process for buying and selling stocks. The strategy aims to identify the right times to enter or exit trades. 
>
The strategy involves the following steps:
>
1. Split your total investment into N parts.
2. Create three shopping lists: ETFs (42 ETFs), Jewellery (10 ETFs of Gold and Silver), and Top 10 Nifty 50 ETFs by market cap.
3. Each shop will display the top 3 picks based on the Current Market Price's distance from the 20-day Moving Average.
4. Invest one part in one ETF/stock from each shop, with a maximum of 3 purchases per day.
5. Limit overall active positions to 20 (ceiling limit).
6. Sell all units of any script that achieves a profit of P% on any given day.
7. If a script falls by 2.5% (-B%) from the previous buy price, initiate a Buy In Dip (BID) with an investment amount of x/10 (x is the total investment in that script).
8. After deducting all charges, including brokerage, transaction taxes, DP charges, and STCG tax, utilize the remaining profit as the growth amount.
9. Finally, we will compute the Compound Annual Growth Rate (CAGR) to quantify the potential returns and profitability of this strategy. CAGR offers a standardized measure of annual growth over a specific period, providing a clear and comprehensive evaluation of the strategy's financial performance. 

The strategy involves diversifying investments across ETFs, Jewellery, and top Nifty 50 stocks, with a focus on buying low (CMP farthest from 20DMA) and selling high (reaching the target). Additionally, it incorporates risk management through a ceiling limit on active positions and a Buy In Dip strategy for recovering from price dips.

# What is this project about?
The goal of this project is to automate the backtesting process for the outlined trading strategy. Backtesting involves simulating the application of the strategy to historical market data to assess its performance. By feeding past market conditions into the automated system, the strategy's effectiveness can be evaluated, allowing for insights into potential strengths, weaknesses, and overall profitability. This iterative testing approach helps refine and optimize the strategy, providing a data-driven foundation for decision-making and enhancing the likelihood of success in real-world trading scenarios. 

You can also refer to my kaggle notebook regarding this project: [20 DMA strategy](https://www.kaggle.com/code/himanidh/20-dma-strategy/notebook)

# How to run?

1. Download R Studio:
>Go to the R Studio website.
>Download and install RStudio on your computer.

2. Clone Repository:
>Open GitHub Desktop.
>Clone this project repository in GitHub Desktop.

3. Open Project Folder:
>Locate the folder of this project on your computer.

4. Open R Studio and Run Code:
>Open the R files in the sequence written below, and it will automatically open RStudio.
* downloadingSorting.R
* processingManipulating.R
* lists_buy_sell.R
* buying_and_selling.R

# Installation of RStudio:
1. Windows 10/11: [RStudio](https://download1.rstudio.org/electron/windows/RStudio-2023.12.1-402.exe)
2. MacOS 12+ : [RStudio](https://download1.rstudio.org/electron/macos/RStudio-2023.12.1-402.dmg)
* Go to [Posit](https://posit.co/download/rstudio-desktop/) for more information and downloading options.


