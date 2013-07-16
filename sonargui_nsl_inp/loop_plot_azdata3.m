%Script to plot all the times from a day in the azimuth file, using the
%handles established in sonargui_nsl_inp.  If you click the save button,
%you create sonar_nsl_output.mat, which contains the handle stucuture, but
%now named hand_save
%
% note: this only works if the sonarGUI window is open elsewhere-
% the handle_save refers to things in there.
figure

load sonar_nsl_output
     fnames=dir(char(hand_save.path));
% use the fnames to make a list of azimuth files to display
    cellnames={fnames.name};  % put all the names in a cell array
    locs=strfind(cellnames,'.cdf'); %find the ones with cdf
    isntcdf=cellfun(@isempty,locs);   %the notCDFs will be []
    iscdf=find(isntcdf==0);           % get the indices
    cdflist=cellnames(iscdf);

    % step through the experiments
    for jj=1:10
        set(hand_save.azdata_popupmenu5,'Value', jj+3)
        %step through the times
        for ik=1:4
            set(hand_save.tindex_edit12,'String',num2str(ik));
            % even though I'm passing in hand_save, it's accessing the current values
            % of handle based on what's in sonargui_nsl_inp
            plot_azdata3(hand_save)
            view(0,90)
            colorbar
            pause (1)
        end
    end

    % we need to have better filtering, and confidence that the area
    % imaged is really what's shown.