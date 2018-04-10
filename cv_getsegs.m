function segments = cv_getsegs(data)

segments = [0;find(abs(diff(data.clines(:,1)))>1);length(data.clines)];