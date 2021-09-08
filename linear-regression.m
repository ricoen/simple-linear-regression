function [x, y] = getVars()
  % Data of Dimmable LED's Power (Watt) and Illuminance (lux) with 20 (m^2) of area
  watts = [5, 8, 12, 16, 24, 36];
  lux = [25, 40, 66, 88, 144, 216];
  x = [watts];
  y = [lux];
end

% Function to plot the data
function plotData()
  [x, y] = getVars();

  plot(x, y, 'ro', 'MarkerSize', 8); % Plot the data
  
  xlabel('Watt'); % Set the x-axis label
  ylabel('lux'); % Set the y-axis label
end

% Simple linear regression formula -> y = a + B.x

% Function to calculate the errors
function [e_x, e_y] = calcError ()
  [x, y] = getVars();
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
function num = numerator ()
  [x, y] = getVars();
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
function denom = denominator ()
  [x, _] = getVars();
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
function a = intercept (B)
  [x, y] = getVars();
  a = mean(y) - B * mean(x);
  return
endfunction

% Function to compute Y (prediction)
function Y = prediction (a, B)
  [x, _] = getVars();
  n = length(x);
  Y = [];
  for i = 1:n,
    predict = a + B * x(i);
    Y = vertcat(Y, [predict]);
  end
  return;
endfunction

% Function to plot the prediction
function plotPredict(Y_predict)
  [x, _] = getVars();
  
  plot(x, Y_predict, 'bo', 'MarkerSize', 8); % Plot the prediction
end

% Function to plot the line of linear regression
function plotLine(Y_predict)
  [x, _] = getVars();
  plot(x, Y_predict, 'r-', 'linewidth', 2); % Plot the regression line
end

% Function to calculate the RMSE
function rmse = estimateTheError(Y_predict)
  [x, y] = getVars();
  n = length(x);
  substract = [];
  squared_error = [];
  for i = 1:n,
    subs = Y_predict(i) - y(i);
    substract = vertcat(substract, [subs]);
    square = power(substract(i), 2);
    squared_error = vertcat(squared_error, [square]);
  end
  rmse = sqrt(sum(squared_error) / n);
  return;
endfunction

B = slope(numerator(), denominator());
a = intercept(B);
Y = prediction(a, B);

printf('Prediction: \n');
disp(Y);
printf('\n');
printf('RMSE = %f\n', estimateTheError(Y));

plotData();
hold on;
plotPredict(Y);
hold on;
plotLine(Y);

title ("Simple Linear Regression of Power (Watt) and Illuminance (lux)");
labels = legend('Training data', 'Predicted Y', 'Linear Regression');
legend(labels,"location", "northeastoutside");
set (labels, "fontsize", 10);
hold off;

printf('\n');
fprintf('Program paused. Press enter to exit.\n');

pause;