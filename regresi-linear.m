# Data of Lumens and Watts
# Halogen incandescent (tungsten halogen) 230 V
lumens = [375, 600, 900, 1125, 1670, 2565, 3520];
watts = [25, 40, 60, 75, 100, 150, 200];

x = [lumens];
y = [watts];

n = length(x);
global mean_x = mean(x)
global mean_y = mean(y)

function plotData(x,y)
  plot(x,y,'ro','MarkerSize',8); % Plot the data
  
  xlabel('Lumens'); % Set the x-axis label
  ylabel('Watts'); % Set the y-axis label
end

# Simple linear regression formula -> y = a + B.x

global e_x = [];
global e_y = [];

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

function B = slope (num, denom)
  B = num/denom;
  return
endfunction

function a = intercept (B)
  global mean_x;
  global mean_y;

  a = mean_y - B * mean_x;
  return
endfunction

function Y = prediction (n, a, B, x)
  Y = [];

  for i = 1:n,
    predict = a + B * x(i);
    Y = vertcat(Y, [predict]);
  end
  return;
endfunction

function plotPredict(x,Y)
  plot(x,Y,'bo','MarkerSize',8); % Plot the Y prediction
end

function plotLine(x, Y)
  plot(x,Y,'r-','linewidth',2); % Plot the regression line
end

function rmse = estimateTheError(n, y, Y)
  substract = [];
  squared_error = [];
  for i = 1:n,
    subs = Y(i) - y(i);
    substract = vertcat(substract, [subs]);
    square = power(substract(i), 2);
    squared_error = vertcat(squared_error, [square]);
  end
  rmse = sqrt(sum(squared_error)/5);
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

plotData(x,y);
hold on;
plotPredict(x,Y);
hold on;
plotLine(x,Y);
legend('Training data','Predicted Y','Linear Regression')
hold off;

printf('\n');
fprintf('Program paused. Press enter to exit.\n');

pause;