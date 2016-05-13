DATA = dlmread('C:\TEMP\fcr_model.csv',';');
% DATA = dlmread('C:\TEMP\fcr_interp.csv',';');

x = DATA(2:24,1); % temperature
y = DATA(1,2:24); % average weight
%x = DATA(2:78,1); % temperature
%y = DATA(1,2:78); % average weight
[xx,yy] = meshgrid(y,x);
% z = f(x,y)
z = DATA(2:24,2:24); % FCR value
%z = DATA(2:78,2:78); % FCR value

fh1 = figure('Position',[0,0,900,675]);
surf(xx,yy,z,'FaceColor','interp');
title('Estimated CompanyA'); xlabel('Temp'); ylabel('Aver.wt.'); zlabel('FCR');
% xlim([0,35]); ylim([0,1000]); zlim([0,6]);
% shading interp;
colorbar;
