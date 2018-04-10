ptdir = '/Users/arikappel/GoogleDrive/CRC_Lab/Geometry/Geom_Data/BB061/vmtk';
data = cv_readindat(ptdir);

segment = load([ptdir,'/seg_lA1.mat']);
figH = figure;
plot(segment.area)
sel = cv_brushui(figH);

clean_segment = segment;
clean_segment.cleanidx = sel(:,1);
clean_segment.area = sel(:,2);

%%

 h = uicontrol('Position', [20 20 200 40], 'String', 'Continue', ...
                      'Callback', 'uiresume(gcbf)');
        disp('This will print immediately');
        uiwait(gcf);
        disp('This will print after you click Continue'); close(f);
        
        
%%
