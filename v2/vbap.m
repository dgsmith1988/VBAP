function vbap(positionNew)
%This function implements the VBAP algorithm and calculates the linear
%gains values to put an audio source at position

%Globals/constants defitions, these should be setup correctly in the
%corresponding test*D.m files
global basisVectors
global POSITION_INTERPOLATION_POINTS
global GAIN_INTERPOLATION_POINTS
global NUM_DIMENSIONS
global NUM_SPKRS
global NUM_SPKR_SETS
global speakers
global speakerSets
global gainData

persistent positionCurrent
%If this is the first time we're running this function then set the
%current position to the origin
if isempty(positionCurrent)
    positionCurrent = zeros(NUM_DIMENSIONS, 1);
end

gainsUnscaled = zeros(NUM_DIMENSIONS, NUM_SPKR_SETS);
gainsScaled = zeros(NUM_DIMENSIONS, NUM_SPKR_SETS);

positionInterpolants = mylinterp(positionCurrent, positionNew, POSITION_INTERPOLATION_POINTS);
%Lets tack the new position on to the end of the interpolants to make
%the upcoming for loop a bit smoother
positionInterpolants = [positionInterpolants, positionNew];

for positionIndex = 1:POSITION_INTERPOLATION_POINTS + 1
    for speakerSetIndex = 1:NUM_SPKR_SETS
        speakerSetBasis = getSpeakerSetBasis(speakerSetIndex);
        gainsUnscaled(:, speakerSetIndex) = positionInterpolants(:, positionIndex)'/speakerSetBasis; %use right matrix divide instead of *inv(A)
        gainsScaled(:, speakerSetIndex) = gainsUnscaled(:, speakerSetIndex) / sqrt(sum(gainsUnscaled(:, speakerSetIndex).^2));
    end
        %Now that we've gone through all the speaker bases and calculated
        %their gains, lets find which speaker set is the active one and
        %calculate the gain values need to crossfade to it smoothly
        activeSpeakerSetIndex = getActiveSpeakerSetIndex;
        newGains = packNewGains;
        gainInterpolants = mylinterp(getCurrentGains, newGains, GAIN_INTERPOLATION_POINTS);
        plotResults;
        printResults;
        %pause;
        %As we've computed all the gains necessary for this positional
        %interpolation, we can update the gains
        for spkrIndex = 1:NUM_SPKRS
            speakers(spkrIndex).gain = newGains(spkrIndex);
        end
end

%Since we've gone through all the steps for all the position interpolants
%we can consider the new position as the current position
positionCurrent = positionNew;


%HERE BE NESTED FUNCTIONS!!!!
    function basis = getSpeakerSetBasis(speakerSetIndex)
        fields = fieldnames(speakerSets);
        basis = zeros(NUM_DIMENSIONS, NUM_DIMENSIONS);
        for index = 1:NUM_DIMENSIONS
            spkr = speakerSets(speakerSetIndex).(char(fields(index)));
            basis(:, index) = spkr.position';
        end
    end
    function index = getActiveSpeakerSetIndex
        %Now lets find the active loudspeaker set for recently calculated unscaled gain values. The algorithm works as follows: presumably the
        %correct vector base will be the only one where there's no negative gain components(based on mathematical intuition as I haven't worked
        %out the proof) so we need to find it. Where there's only one active speaker it might appear in several different "solutions" (which
        %should only occur if the posiiton is only on one basis vector) the algorithm chooses the first one found
        index = find(sum(gainsUnscaled >= 0) == size(gainsUnscaled, 1), 1);
    end
    function indicies = getActiveSpeakerIndicies
        fields = fieldnames(speakerSets);
        indicies = zeros(1, NUM_DIMENSIONS);
        for index = 1:NUM_DIMENSIONS
            spkr = speakerSets(activeSpeakerSetIndex).(char(fields(index)));
            indicies(index) = find(speakers == spkr);
        end
    end
    function currentGains = getCurrentGains
        currentGains = zeros(NUM_SPKRS, 1);
        for index = 1:NUM_SPKRS
            currentGains(index) = speakers(index).gain;
        end
    end
    function newGainsPacked = packNewGains
        newGainsPacked = zeros(NUM_SPKRS, 1);
        newGainsPacked(getActiveSpeakerIndicies) = gainsScaled(:, activeSpeakerSetIndex);
    end
    function plotResults
        posFigH = 1;
        gainFigH = 2;
        switch NUM_DIMENSIONS
            case 2
                %First plot the position values overlaped on the basis
                %vectors
                figure(posFigH);
                sz = 1.5;
                plotv(basisVectors, 'k');
                title('Speaker Sets and Panning Position', 'FontWeight', 'bold');
                axis([-sz sz -sz sz]);
                hold on;
                plotv(speakerSets(activeSpeakerSetIndex).spkr1.position, 'b');
                plotv(speakerSets(activeSpeakerSetIndex).spkr2.position, 'b');
                if positionIndex <= POSITION_INTERPOLATION_POINTS
                    plotv(positionInterpolants(:, positionIndex), ':+g');
                else
                    %Use a different plotting style to differentiate the
                    %non-interpolated point
                    plotv(positionInterpolants(:, positionIndex), ':.r');
                end
                
                %add some notation to make it easier to interpret the data
                signs = sign(basisVectors);
                offset = .025;
                for i = 1:size(basisVectors, 2)                  
                    text(basisVectors(1, i) + offset*signs(1, i), basisVectors(2, i) + offset*signs(2, i), sprintf('l%i', i));
                end
                hold off;
                
                %Now plot the interpolated gain values
                figure(gainFigH);
                if positionIndex ~= 1
                    hold on;
                end
                %Alternate line specs so it's easier to distinguish between
                %the position interations
                if mod(positionIndex, 2) == 0
                    linSpec = '-o';
                else
                    linSpec = ':+';
                end
                xAxis = (1+(positionIndex-1)*(GAIN_INTERPOLATION_POINTS+1)):(positionIndex*(GAIN_INTERPOLATION_POINTS+1));
                gainData = [gainData, gainInterpolants, newGains];
                plot(xAxis, [gainInterpolants, newGains]', linSpec);
                title('Interpolated Gain Values', 'FontWeight', 'bold');
                xlabel('Interation "step"')
                ylabel('Linear gain values')
                set(gca,'YLim',[0 1])
                legend('l1 gain', 'l2 gain', 'l3 gain', 'l4 gain', 'l5 gain', 'Location', 'NorthEastOutside');
                grid on;
                hold off;
            case 3
                %code for plotting 3D here
        end
    end
    function printResults
       switch NUM_DIMENSIONS
            case 2
                fprintf('Position Interpolation Interation: %i\n', positionIndex);
                fprintf('LS set #%i selected\n', activeSpeakerSetIndex);
                fprintf('p = [%f, %f]\n', positionInterpolants(:, positionIndex));
                basis = getSpeakerSetBasis(activeSpeakerSetIndex);
                fprintf('v1 = [%f, %f]\n', basis(1, :)');
                fprintf('v2 = [%f, %f]\n', basis(2, :)');
                fprintf('g_us = [%f, %f]\n', gainsUnscaled(:, activeSpeakerSetIndex));
                fprintf('g_s = [%f, %f]\n', gainsScaled(:, activeSpeakerSetIndex));
                fprintf('nf = %f\n', sqrt(sum(gainsScaled(:, activeSpeakerSetIndex).^2)));
                fprintf('\n');
                disp('[gainInterpolants, newGains]');
                [gainInterpolants, newGains]
            case 3
                fprintf('Position Interpolation Interation: %i\n', positionIndex);
                fprintf('LS set #%i selected\n', activeSpeakerSetIndex);
                fprintf('p = [%f, %f, %f]\n', positionInterpolants(:, positionIndex));
                basis = getSpeakerSetBasis(activeSpeakerSetIndex);
                fprintf('v1 = [%f, %f, %f]\n', basis(1, :)');
                fprintf('v2 = [%f, %f, %f]\n', basis(2, :)');
                fprintf('v3 = [%f, %f, %f]\n', basis(3, :)');
                fprintf('g_us = [%f, %f, %f]\n', gainsUnscaled(:, activeSpeakerSetIndex));
                fprintf('g_s = [%f, %f, %f]\n', gainsScaled(:, activeSpeakerSetIndex));
                fprintf('nf = %f\n', sqrt(sum(gainsScaled(:, activeSpeakerSetIndex).^2)));
                fprintf('\n');
        end
    end
end