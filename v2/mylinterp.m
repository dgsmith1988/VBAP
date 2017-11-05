function [interpolants] = mylinterp(v1,v2,n)
    %this function performs liner interpolation between column vectors 
    %v1 and v2. n is the number of points to interpolate.
    interpolants = zeros(size(v1, 1), n);
    dist = v2-v1;
    step = dist/(n+1);
    for i = 1:n
        interpolants(:, i) = v1 + step*i;
    end
    precision = 10^6;
    interpolants = round(precision*interpolants())/precision;
end