DATA = dlmread('C:\TEMP\ardgFCR261014-1.csv',';');
% DATA = dlmread('C:\TEMP\ardgFCR261014-2.csv',';');

x = DATA(2:51,1); % temperature
y = DATA(1,2:36); % average weight
[xx,yy] = meshgrid(y,x);
% z = f(x,y)
z = DATA(2:51,2:36); % FCR value

fh1 = figure('Position',[0,0,900,675]);
surf(xx,yy,z,'FaceColor','interp');
title('Original Ardag'); xlabel('Temp'); ylabel('Aver.wt.'); zlabel('FCR');
% shading interp;
colorbar;

% tri = delaunay(xx,yy);
% trisurf(tri,xx,yy,z,'FaceColor','interp');

xq = linspace(0,500,70);
xq = xq.';
yq = 1:.5:35;
[xxq,yyq] = meshgrid(yq,xq);
% zq = interp2(xx,yy,z,xxq,yyq,'spline');
zq = interp2(xx,yy,z,xxq,yyq);

fh2 = figure('Position',[0,0,900,675]);
surf(xxq,yyq,zq,'FaceColor','interp');
title('Interpolated Ardag'); xlabel('Temp'); ylabel('Aver.wt.'); zlabel('FCR');
% shading interp;
colorbar;
