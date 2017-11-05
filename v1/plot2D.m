sz = 1.5;
%figure
plotv(l1, 'k');
axis([-sz sz -sz sz]);
hold on;
plotv(l2, 'k');
plotv(l3, 'k');
plotv(l4, 'k');
plotv(l5, 'k');
plotv(LS_pairs(1,:,active_LS_set)', 'b');
plotv(LS_pairs(2,:,active_LS_set)', 'b')
plotv(pos_current, ':+r');
hold off;