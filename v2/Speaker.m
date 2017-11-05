classdef Speaker < handle
    properties
        position
        gain
    end
    methods
        function spkr = Speaker(position, gain)
            spkr.position = position;
            spkr.gain = gain;
        end
    end
end