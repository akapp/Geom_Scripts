function h = cv_plottangent(x,y,z,B,T,N,c,f)

% c is a color vector 1x3

% Matrix #1
figure; hold on
if ~iscell(x) && size(x,2)==3
try
    plot3(x(1:end-3,1),x(1:end-3,2),x(1:end-3,3),'*','color',c)
catch
    plot3(x(1:end-3,1),x(1:end-3,2),x(1:end-3,3),'*')
end
for j=1:length(x)
    quiver3(x(j,1),x(j,2),x(j,3),B(j,1),B(j,2),B(j,3),'b'); %blue
    quiver3(x(j,1),x(j,2),x(j,3),T(j,1),T(j,2),T(j,3),'g'); %green
    quiver3(x(j,1),x(j,2),x(j,3),N(j,1),N(j,2),N(j,3),'r'); %red
    pause
end

% Matrix #2
elseif ~iscell(x) && size(x,2)==1
    try
        plot3(x(1:end-3),y(1:end-3),z(1:end-3),'*','color',c)
    catch
        plot3(x(1:end-3),y(1:end-3),z(1:end-3),'*')
    end
    for j=1:length(x)
        quiver3(x(j,1),y(j,1),z(j,1),B(j,1),B(j,2),B(j,3),'b'); %blue
        quiver3(x(j,1),y(j,1),z(j,1),T(j,1),T(j,2),T(j,3),'g'); %green
        quiver3(x(j,1),y(j,1),z(j,1),N(j,1),N(j,2),N(j,3),'r'); %red
        pause
    end

% Cell #1
elseif iscell(x) && size(x{1},2)==3
    for i=1:length(x)
        if ~isempty(x(i))
        l=x{i};
        try
            plot3(l(1:end-3,1),l(1:end-3,2),l(1:end-3,3),'*','color',c)
        catch
            plot3(l(1:end-3,1),l(1:end-3,2),l(1:end-3,3),'*')
        end
        for j=1:length(l)
            quiver3(l(j,1),l(j,2),l(j,3),B(j,1),B(j,2),B(j,3),'b'); %blue
            quiver3(l(j,1),l(j,2),l(j,3),T(j,1),T(j,2),T(j,3),'g'); %green
            quiver3(l(j,1),l(j,2),l(j,3),N(j,1),N(j,2),N(j,3),'r'); %red
            pause
        end
        end
    end
    
% Cell #2 = Single
elseif iscell(x) && size(x{1},2)==1
    for i=1:length(x)
        if ~isempty(x(i))
            if exist('c','var')
                plot3(x{i},y{i},z{i},'*','color',c(i,:))
            else
                plot3(x{i},y{i},z{i},'*')
            end
            if exist('T','var') && iscell(T)
                for j=1:length(x{i})-3
                    quiver3(x{i}(j),y{i}(j),z{i}(j),B{i}(j,1),B{i}(j,2),B{i}(j,3),'g'); %blue
                    quiver3(x{i}(j),y{i}(j),z{i}(j),T{i}(j,1),T{i}(j,2),T{i}(j,3),'b'); %green
                    quiver3(x{i}(j),y{i}(j),z{i}(j),N{i}(j,1),N{i}(j,2),N{i}(j,3),'r'); %red
                    %pause
                end
            elseif ~exist('T','var') || ~iscell(T)
                for i=1:length(x)
                    [~,~,T,N,B] = ifrenetserret([x{i},y{i},z{i}]);
                    % [kappa,tau,T,N,B,s,ds,dX,dT,dB] = ifrenetserret([x{i},y{i},z{i}])
                    for j=1:length(x{i})-3
                        quiver3(x{i}(j),y{i}(j),z{i}(j),B(j,1),B(j,2),B(j,3),'g'); %blue
                        quiver3(x{i}(j),y{i}(j),z{i}(j),T(j,1),T(j,2),T(j,3),'b'); %green
                        quiver3(x{i}(j),y{i}(j),z{i}(j),N(j,1),N(j,2),N(j,3),'r'); %red
                        %pause
                    end
                end
                % pause
            end
        end
        
    end
    
end
