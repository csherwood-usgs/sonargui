%Script to plot all the times from a day in the azimuth file, using the
%handles established in sonargui_nsl_inp.  If you click the save button,
%you create sonar_nsl_output.mat, which contains the handle stucuture, but
%now named hand_save
%
% note: this only works if the sonarGUI window is open elsewhere-
% the handle_save refers to things in there.
figure

load sonar_nsl_output
for ik=1:4
set(hand_save.tindex_edit12,'String',num2str(ik));
plot_azdata2(hand_save)
view(0,90)
colorbar
pause (1)
end
% next we need to figure out how to get consisten colors on the map.
% and blank out the regions we don't want.