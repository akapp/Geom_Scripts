% function cv_processcenterlines(ptdir)

options.ptdir =  '/Users/arikappel/GoogleDrive/CRC_Lab/Geometry/Geom_Data/BB061';
options.prefs = cv_defaultprefs;

[data,varNames] = cv_readindat(options);

[x,y,z,segs,figH,cH] = cv_plotcenterlines(options,data);

%% Process results

files = cv_parsedirectory(options);
