POSITION_INTERPOLATION_POINTS = 8;
GAIN_INTERPOLATION_POINTS = 10;

%lets calculate the gain levels for each speaker pair (a.k.a. vector basis)
%to see which one to use
matrix_dim = size(LS_pairs);
gain_unscaled = zeros(matrix_dim(1), matrix_dim(3));
gain_scaled = zeros(matrix_dim(1), matrix_dim(3));

position_interpolants = mylinterp(pos_current, pos_new, POSITION_INTERPOLATION_POINTS);
position_interpolants = [pos_current, position_interpolants, pos_new];

for i = 1:POSITION_INTERPOLATION_POINTS + 2
    for j = 1:size(LS_pairs, 3)
        gain_unscaled(:, j) = position_interpolants(:, i)'/LS_pairs(:, :, j); %use right matrix divide instead of *inv(A)
        gain_scaled(:, j) = gain_unscaled(:, j) / sqrt(sum(gain_unscaled(:, j).^2));
    end
end

pos_current = pos_new;

%now lets go through the calculated gain values to see which set of
%speakers to select. the algorithm works as follows: presumably the correct
%vector base will be the only one where there's no negative gain components
%(based on mathematical intuition... i haven't worked out the proof) so find
%it... in the scenario where there's only one active speaker it might
%appear in several different "solutions" so the algorithm ends up picking
%the last one
active_LS_set = 0;
for i = 1:size(gain_unscaled, 2)
    temp = gain_unscaled(:, i);
    if(size(temp, 1) == 2)
        if(temp(1) < 0 || temp(2) < 0)
            continue
        end
    elseif(size(temp, 1) == 3)
        if(temp(1) < 0 || temp(2) < 0 || temp(3) < 0)
            continue
        end
    end
    active_LS_set = i;
end

%now that we have the active speaker set as well as the calculated gain
%values we should update the applied gains as well as calculate the
%interpolated gain values...
i1 = 1:NUMBER_OF_SPKRS;
i2 = circshift(1:NUMBER_OF_SPKRS, [0 -1]);
appliedGains = zeros(NUMBER_OF_SPKRS, 1);
for i = i1
    appliedGains(i) = speakerSets(i).spkr1.gain;
end

newGains = zeros(NUMBER_OF_SPKRS, 1);
newGains(active_LS_set) = gain_scaled(1, active_LS_set);
newGains(i2(active_LS_set)) = gain_scaled(2, active_LS_set);


appliedGains
newGains
gain_interpolants = mylinterp(appliedGains, newGains, GAIN_INTERPOLATION_POINTS)

%now that we have the interpolated gain values we con consider the new
%gains as being "applied" (aka the speakers have bene set to their values)

for i = i1
    speakerSets(i).spkr1.gain = newGains(i);
    speakerSets(i).spkr2.gain = newGains(i2(i));
end