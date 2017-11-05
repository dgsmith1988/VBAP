%Make sure to keep the same vector orientations as described in the paper
%i.e. |x|
%     |y|

%These speaker positions are based on the layout in Fig. 4 of article1.pdf
temp = sqrt(2)/2;
l1 = [0; 1];
l2 = [temp; temp];
l3 = [temp; -temp];
l4 = [-temp; -temp];
l5 = [-temp ; temp];

global basisVectors
basisVectors = [l1, l2, l3, l4, l5];

global POSITION_INTERPOLATION_POINTS
POSITION_INTERPOLATION_POINTS = 5;

global GAIN_INTERPOLATION_POINTS
GAIN_INTERPOLATION_POINTS = 5;

global NUM_DIMENSIONS
NUM_DIMENSIONS = size(basisVectors, 1);

global NUM_SPKRS
NUM_SPKRS = size(basisVectors, 2);

global NUM_SPKR_SETS
NUM_SPKR_SETS = size(basisVectors, 2);

global speakers
speakers = Speaker.empty(NUM_SPKRS, 0);
for index = 1:NUM_SPKRS
    speakers(index) = Speaker(basisVectors(:, index), 0.0);
end

global speakerSets
s1 = 1:NUM_SPKR_SETS;
%TODO: see if theres a more concise mathematical trick here you can use to
%shift the indicies as a refactoring opportunity
s2 = circshift(s1, [0 -1]);
for index = s1
    speakerSets(index).spkr1 = speakers(s1(index));
    speakerSets(index).spkr2 = speakers(s2(index));
end

global gainData
gainData = zeros(NUM_SPKRS, 1);

%now that we've set everything up lets test the alogrithm by sweeping
%through a circle
for theta = 0:15:360
    vbap([cosd(theta); sind(theta)]);
    %pause;
end

plot(gainData')
legend('l1 gain','l2 gain','l3 gain','l4 gain','l5 gain')