DATA = dlmread('C:\TEMP\cmpaBream.csv',';');
% DATA = dlmread('C:\TEMP\cmpaBass.csv',';');

x = DATA(2:19,1); % temperature
x(19:35,:) = 0; % extend x with zeros to same dimension as y
y = DATA(1,2:36); % average weight
[xx,yy] = meshgrid(y,x);
% x1 = linspace(1,1,35);
% x1 = x1';
% x1 = ones(35,35);

% ---------- 1
% f = @(x,y) a*(x - o).^2 + b*x + c;
% f = @(x,y) y*(x - o).^2 + b*x + c;
% f = @(x,y) e*y.^2;
% f = @(x,y) (y*(x - o).^2 + b*x + c + e*y.^2)/yd1;
% ---------- 2
% f = @(x,y) (a*y*(x - o).^2 + b*x + c)/yd1;
% f = @(x,y) sqrt(f*y + g)/yd2;
% f = @(x,y) (a*y*(x - o).^2 + b*x + c)/yd1 + sqrt(f*y + g)/yd2;
% ---------- 3
% f = @(x,y) (a*y*(x - o).^2 + b*x + c)/yd1;
% f = @(x,y) h - exp(f*y + g)/yd2;
% f = @(x,y) (a*y*(x - o).^2 + b*x + c)/yd1 + h - exp(f*y + g)/yd2;
% ---------- 4
o = 24;
yd1 = 7000000;
a = 1/yd1;
b = 1/yd1;
c = -2; % height at 0
d = 0.5; % curvature (also vertical position)
e = 30; % curvature (higher -> less curvy)

% f = @(x,y) a*y*(x - o).^2 + b*x;
f = @(x,y) c + log(d*y + e);
% f = @(x,y) a*y*(x - o).^2 + b*x + c + log(d*y + e);

z = f(xx,yy); % FCR value

fh1 = figure('Position',[0,0,900,675]);
surf(xx,yy,z,'FaceColor','interp');
title('Estimated CompanyA'); xlabel('Temp'); ylabel('Aver.wt.'); zlabel('FCR');
% xlim([0,35]); ylim([0,1000]); zlim([0,6]);
% shading interp;
colorbar;
