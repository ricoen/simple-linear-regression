% Data of Dimmable LED's Illuminance (lux) and Power (Watt) with 20 (m^2) of area
lux = [20, 40, 72, 96, 216, 324];
watts = [5, 8, 12, 16, 24, 36];

% Change variable names
x = [watts];
y = [lux];

% Function to plot the data
function plotData(x, y)
  plot(x, y, 'ro', 'MarkerSize', 8); % Plot the data
  
  xlabel('Watt'); % Set the x-axis label
  ylabel('lux'); % Set the y-axis label
end

% Simple linear regression formula -> y = a + B.x

% Find n and mean of x and y
n = length(x);
global mean_x = mean(x)
global mean_y = mean(y)
global e_x = []; % errors of x
global e_y = []; % errors of y

% Function to calculate the errors
function calcError (n, x, y)
  global e_x;
  global e_y;
  global mean_x;
  global mean_y;

  for i = 1:n,
    err_x = x(i) - mean_x;
    err_y = y(i) - mean_y;
    e_x = vertcat(e_x, [err_x]);
    e_y = vertcat(e_y, [err_y]);
  end
endfunction

% Function to calculate the numerator of B (Beta)
function num = numerator (n)
  global e_x;
  global e_y;
  num = 0;
  multiplication = [];

  for i = 1:n,
    x = e_x(i) * e_y(i);
    multiplication = vertcat(multiplication, [x]);
  end

  num = sum(multiplication);
  return;
endfunction

% Function to calculate tht denominator of B (Beta)
function denom = denominator (n)
  global e_x;
  denom = 0;
  square = [];

  for i = 1:n,
    y = power(e_x(i), 2);
    square = vertcat(square, [y]);
  end

  denom = sum(square);
  return
endfunction

% Function to calculate the slope B (Beta)
function B = slope (num, denom)
  B = num / denom;
  return
endfunction

% Function to calculate the intercept a (alpha)
function a = intercept (B)
  global mean_x;
  global mean_y;

  a = mean_y - B * mean_x;
  return
endfunction

% Function to compute Y (prediction)
function Y = prediction (n, a, B, x)
  Y = [];

  for i = 1:n,
    predict = a + B * x(i);
    Y = vertcat(Y, [predict]);
  end
  return;
endfunction

% Function to plot the prediction
function plotPredict(x, Y)
  plot(x, Y, 'bo', 'MarkerSize', 8); % Plot the prediction
end

% Function to plot the line of linear regression
function plotLine(x, Y)
  plot(x, Y, 'r-', 'linewidth', 2); % Plot the regression line
end

% Function to calculate the RMSE
function rmse = estimateTheError(n, y, Y)
  substract = [];
  squared_error = [];

  for i = 1:n,
    subs = Y(i) - y(i);
    substract = vertcat(substract, [subs]);
    square = power(substract(i), 2);
    squared_error = vertcat(squared_error, [square]);
  end
  
  rmse = sqrt(sum(squared_error) / 5);
  return;
endfunction

calcError(n, x, y);
B = slope(numerator(n), denominator(n));
a = intercept(B);
Y = prediction(n, a, B, x);

printf('Prediction: \n');
disp(Y);
printf('\n');
printf('RMSE = %f\n', estimateTheError(n, y, Y));

plotData(x, y);
hold on;
plotPredict(x, Y);
hold on;
plotLine(x, Y);
title ("Simple Linear Regression of Power (Watt) and Illuminance (lux)");
labels = legend('Training data', 'Predicted Y', 'Linear Regression');
legend(labels,"location", "northeastoutside");
set (labels, "fontsize", 10);
hold off;

printf('\n');
fprintf('Program paused. Press enter to exit.\n');

pause;