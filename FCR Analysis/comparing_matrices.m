
x=[1 1; 0.96 0];
y=[1 1;1 0];


% Method 1

%absTol = 1e-3;   % You choose this value to be what you want!
%relTol = 0.05;   % This one too!
%absError = x(:)-y(:);
%relError = absError./x(:);
%relError(~isfinite(relError)) = 0;   % Sets Inf and NaN to 0
%same = all( (abs(absError) < absTol) & (abs(relError) < relTol) );

%%%%%%%%%%%%%%%%%%%%

% Method 2

% This will return a logical matrix which will be true for each element if 
% the relative difference between A and B with respect to B is less than 5 percent.
%tf = abs((x-y)./y)<0.05

% If you want to ask if all of these are true (they all satisfy the above condition):
%all(tf(:))


%%%%%%%%%%%%%%%%%%%%

% Method 3

%function same = tol( x, y )
absTol = 1e-3;
relTol = 0.05;
errVec = abs( x(:) - y(:) );
same = all( (errVec < absTol) | (errVec./x(:) < relTol) );
%relError(x < absTol) = 0;
same
