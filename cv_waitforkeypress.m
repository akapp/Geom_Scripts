function [key] = cv_waitforkeypress(handles,restrictedKeys)

key=[];
while ~any(strcmp(key,restrictedKeys))
    w = waitforbuttonpress;
    switch w
        case 1
            key = get(gcf,'currentcharacter'); % Ref: bit.ly/2IJvbKS
    end
    pause(0.1)
end

