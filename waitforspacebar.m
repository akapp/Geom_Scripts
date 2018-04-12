function waitforspacebar()

fprintf('Press Space bar to continue\r')
key=0;
    while ~strcmp(key,' ')
        w = waitforbuttonpress;
        switch w
            case 1
                key = get(gcf,'currentcharacter'); % Ref: bit.ly/2IJvbKS
        end
        pause(0.2)
    end