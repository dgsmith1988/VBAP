%calculate/setup the basis vectors
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