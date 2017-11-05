fprintf('LS set #%i selected\n', active_LS_set);
fprintf('p = [%f, %f]\n', pos_current);
fprintf('v1 = [%f, %f]\n', LS_pairs(1,:,active_LS_set));
fprintf('v2 = [%f, %f]\n', LS_pairs(2,:,active_LS_set));
fprintf('g_us = [%f, %f]\n', gain_unscaled(:,active_LS_set));
fprintf('g_s = [%f, %f]\n', gain_scaled(:,active_LS_set));
fprintf('nf = %f\n', sqrt(sum(gain_unscaled(:, active_LS_set).^2)));
fprintf('\n');