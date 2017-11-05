%sz = 1.5;
%axis([-sz sz -sz sz]);
origin = [0; 0; 0];
quiver3(origin(1), origin(2), origin(3), l1(1), l1(2), l1(3), 'k');
hold on; 
quiver3(origin(1), origin(2), origin(3), l2(1), l2(2), l2(3), 'k');
quiver3(origin(1), origin(2), origin(3), l3(1), l3(2), l3(3), 'k');
quiver3(origin(1), origin(2), origin(3), l4(1), l4(2), l4(3), 'k');
quiver3(origin(1), origin(2), origin(3), l5(1), l5(2), l5(3), 'k');
quiver3(origin(1), origin(2), origin(3), l6(1), l6(2), l6(3), 'k');
%basis vectors
v1 = LS_pairs(1,:,active_LS_set);
v2 = LS_pairs(2,:,active_LS_set);
v3 = LS_pairs(3,:,active_LS_set);
quiver3(origin(1), origin(2), origin(3), v1(1), v1(2), v1(3), 'b');
quiver3(origin(1), origin(2), origin(3), v2(1), v2(2), v2(3), 'b');
quiver3(origin(1), origin(2), origin(3), v3(1), v3(2), v3(3), 'b');
quiver3(origin(1), origin(2), origin(3), p(1), p(2), p(3), ':+r');
hold off;