% Data of Dimmable LED's Power (Watt) and Illuminance (lux) with 20 (m^2) of area
watts = [5, 8, 12, 16, 24, 36];
lux = [25, 40, 66, 88, 144, 216];

% Change variable names
global x = [watts];
global y = [lux];

% Function to plot the data
function plotData(x, y)
  plot(x, y, 'ro', 'MarkerSize', 8); % Plot the data
  
  xlabel('Watt'); % Set the x-axis label
  ylabel('lux'); % Set the y-axis label
end

% Simple linear regression formula -> y = a + B.x

% Function to calculate the errors
function [e_x, e_y] = calcError ()
  global x;
  global y;
  n = length(x);
  e_x = []; % errors of x
  e_y = []; % errors of y
  for i = 1:n,
    err_x = x(i) - mean(x);
    err_y = y(i) - mean(y);
    e_x = vertcat(e_x, [err_x]);
    e_y = vertcat(e_y, [err_y]);
  end
endfunction

% Function to calculate the numerator of B (Beta)
function num = numerator (x, y)
  n = length(x);
  [e_x, e_y] = calcError();
  num = 0;
  multiplication = [];
  for i = 1:n,
    x_updated = e_x(i) * e_y(i);
    multiplication = vertcat(multiplication, [x_updated]);
  end
  num = sum(multiplication);
  return;
endfunction

% Function to calculate tht denominator of B (Beta)
function denom = denominator (x)
  n = length(x);
  [e_x, _] = calcError()
  denom = 0;
  square = [];
  for i = 1:n,
    y_updated = power(e_x(i), 2);
    square = vertcat(square, [y_updated]);
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
function a = intercept (B, x, y)
  a = mean(y) - B * mean(x);
  return
endfunction

% Function to compute Y (prediction)
function Y = prediction (a, B, x)
  n = length(x);
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
function rmse = estimateTheError(x, y, Y)
  n = length(x);
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

B = slope(numerator(x, y), denominator(x));
a = intercept(B, x, y);
Y = prediction(a, B, x);

printf('Prediction: \n');
disp(Y);
printf('\n');
printf('RMSE = %f\n', estimateTheError(x, y, Y));

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