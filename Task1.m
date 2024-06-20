%% Reading the data from JustEat6M and saving it into 2 different variables

data = readtable('JustEat6M.xlsx');
dates = data.Date;
closingPrice = data.Close;


%% Calculating the moving averages for 7 and 14 days

ma7Days = movmean(closingPrice, 7);
ma14Days = movmean(closingPrice, 14);

%% Implementing our trading strategy of moving average crossover

budget = 1000000; % £1 million is up for grabs
portfolio = 0; % At first, no shares are owned
transactions = zeros(size(dates)); % Records buy and sell transactions
total_profit_loss = 0; % Initialize total profit/loss as 0 and then we will add into it
Buy_count = 0; % Initialize total buy count as 0 in order to add in it.
Sell_count = 0; % Initialize total sell count as 0 in order to add in it.
totalPortfolioValue = 1000000; %For counting the value of portfolio for add profits and loss
 
% We will use for loop her to execute the trade based on our conditions
for i = 15:length(dates) % Start from the 15th day to ensure enough data for calculation as the max ma we used is of 14-days
    if ma7Days(i) > ma14Days(i) && ma7Days(i-1) <= ma14Days(i-1) % Buy signal
        numOfSharesToBuy = floor(budget / closingPrice(i));
        if numOfSharesToBuy > 0
            buyPrice = closingPrice(i);
            portfolio = portfolio + numOfSharesToBuy;
            budget = budget - numOfSharesToBuy * closingPrice(i);
            transactions(i) = numOfSharesToBuy;
            Buy_count= Buy_count+1;
            fprintf('Bought %d shares on %s at price of %.2f\n', numOfSharesToBuy, char(dates(i)), closingPrice(i));
        end
    elseif ma7Days(i) < ma14Days(i) && ma7Days(i-1) >= ma14Days(i-1) % Sell signal
        if portfolio > 0
            % Calculating the profit/loss before selling the stock
            profit_loss = (closingPrice(i)-buyPrice) * portfolio;
            total_profit_loss = total_profit_loss + profit_loss; % Updating total profit/loss here
            budget = budget + portfolio * closingPrice(i);
            Sell_count=Sell_count+1;
            totalPortfolioValue = totalPortfolioValue+profit_loss;
            fprintf('Sold %d shares on %s at price of %.2f.\n', portfolio, char(dates(i)), closingPrice(i));
            fprintf('P&L: £%.2f\n', profit_loss);
            fprintf('Portfolio value: £%.2f\n',totalPortfolioValue);
            transactions(i) = -portfolio;
            portfolio = 0;
        end
    end
end

%% Displaying of total profit/loss

fprintf('\nTotal profit/loss: £%.2f\n', total_profit_loss);
fprintf('\nTotal Buy Orders: %.0f\n', Buy_count);
fprintf('\nTotal Sell Orders: %.0f\n', Sell_count);


%% Plot the closing prices and moving averages

plot(dates(15:end), closingPrice(15:end),'LineWidth',2); % Exclude first 14 days due to moving average calculation for making the vector size similar
hold on;
plot(dates(15:end), ma7Days(15:end),'-g');
hold on;
plot(dates(15:end), ma14Days(15:end),'-r');
legend('Closing Prices for JustEat', '7Days Moving Average', '14Days Moving Average');
xlabel('Date');
ylabel('Price');
title('JustEat with Moving Average Crossover');

