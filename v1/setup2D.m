%for now lets fix the speaker positions as well as position vector to get
%this up and running first....

%make sure to keep the same vector orientations as described in the paper
%i.e. |x|
%     |y|

%speaker positions based on angle (in degrees) from "median" (aka y-axis)
temp = sqrt(2)/2;
l1 = [0; 1];
l2 = [temp; temp];
l3 = [temp; -temp];
l4 = [-temp; -temp];
l5 = [-temp ; temp];

basisVectors = [l1, l2, l3, l4, l5];

NUMBER_OF_SPKRS = size(basisVectors ,2);
NUMBER_OF_SPKR_SETS = size(basisVectors ,2);

%speakerSets = zeros(1, NUMBER_OF_SPKR_SETS);
for i = 1:NUMBER_OF_SPKR_SETS
    speakerSets(i).spkr1.position = basisVectors(:, i);
    speakerSets(i).spkr1.gain = 0.0;
    speakerSets(i).spkr2.position = basisVectors(mod((i+1), NUMBER_OF_SPKRS) + 1);
    speakerSets(i).spkr2.gain = 0.0;
end

LS_pairs = cat(3, [l1 l2]', [l2 l3]', [l3 l4]', [l4 l5]', [l5 l1]');

pos_current = [0, 0]';