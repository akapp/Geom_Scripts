% function cv_processcenterlines(ptdir)

options.ptdir = '/Users/arikappel/GoogleDrive/CRC_Lab/Geometry/Geom_Data/BB061';

[data,varNames] = cv_readindat(options);

[x,y,z,segs,figH,cH] = cv_plotcenterlines(options,data);


buttonpanel(figH,'Select Segment')
