setup2D;
for theta = 0:15:360
    pos_new = [cosd(theta); sind(theta)];
    vbap;
    print2D;
    plot2D;
    pause;
end