function cv_waitforspacebar(handles)

cv_busyaction(handles,'on','Press Space bar to continue')
key=0;
    while ~strcmp(key,' ')
        w = waitforbuttonpress;
        switch w
            case 1
                key = get(gcf,'currentcharacter'); % Ref: bit.ly/2IJvbKS
        end
        pause(0.1)
    end
cv_busyaction(handles,'off')