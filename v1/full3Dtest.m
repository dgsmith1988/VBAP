setup3D;
for gamma = 45:-45:-45
    for theta = 0:15:360
        new_pos = [cosd(theta)*cosd(gamma); sind(theta)*cosd(gamma);sind(gamma)];
        vbap;
        print3D;
        plot3D;
        pause;
    end
end