fprintf('LS set #%i selected\n', active_LS_set);
fprintf('p = [%f, %f, %f]\n', p);
fprintf('v1 = [%f, %f, %f]\n', LS_pairs(1,:,active_LS_set));
fprintf('v2 = [%f, %f, %f]\n', LS_pairs(2,:,active_LS_set));
fprintf('v3 = [%f, %f, %f]\n', LS_pairs(3,:,active_LS_set));
fprintf('g = [%f, %f, %f]\n', gain_scaled(:,active_LS_set));
fprintf('\n');