function [timeseries_1989, timeseries_2000, timeseries_2011, timeseries_2002, timeseries_2002_segment] = load_data()
    % Load timeseries datafiles
    addpath("EruptionData/");
    timeseries_1989 = load("EruptionData/eruption1989.dat");
    timeseries_2000 = load("EruptionData/eruption2000.dat");
    timeseries_2011 = load("EruptionData/eruption2011.dat");
    timeseries_2002 = load("EruptionData/eruption2002.dat");

    % Get a randomly selected segment of initial timeseries
    timeseries_2000 = timeseries_2000(278:575);
    timeseries_2011 = timeseries_2011(893:1190);
    timeseries_2002_segment = timeseries_2002(1827:2326);

end