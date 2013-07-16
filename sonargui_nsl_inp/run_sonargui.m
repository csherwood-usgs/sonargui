% this executes the commands necessary to start the sonargui on 11/17/12
%  the program has to run in an old matlab with the old netcdf toolbox
%  because there isn't a Native version of plot_azdata2.m yet.
sonargui_inputs
addpath('C:\Users\emontgomery\mtl\m_contrib\trunk\gridfitdir')
addpath('C:\Users\emontgomery\mtl\m_cmg\trunk\sonarlib\unh_1209\prygui')
addpath('C:\Users\emontgomery\mtl\m_cmg\trunk\sonarlib\unh_1209')
sonargui_nsl_inp (path_names, expnames, fcns)