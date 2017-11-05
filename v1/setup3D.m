%vectors are in the form [x; y; z]
l1 = [1; 0; 0];
l2 = [0; 1; 0];
l3 = [0; 0; 1];
l4 = [-1; 0; 0];
l5 = [0; -1; 0];
l6 = [0; 0; -1];

LS_pairs = cat(3, [l1 l2 l3]', [l2 l3 l4]', [l2 l4 l6]', [l1 l2 l6]', [l1 l5 l6]', [l5 l3 l4]', [l4 l5 l6]', [l1 l5 l3]');

pos_current = [0, 0, 0];