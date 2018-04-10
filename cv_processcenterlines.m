% function cv_processcenterlines(ptdir)

options.ptdir = '/Users/arikappel/GoogleDrive/CRC_Lab/Geometry/Geom_Data/BB061';

[data,varNames] = cv_readindat(options);

[figH,h] = cv_plotcenterlines(options,data);
[pind,xs,ys,zs] = selectdata3('selectionmode','lasso','Flip',1);

