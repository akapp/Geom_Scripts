function [kappa,tau,T,N,B,s,ds,dX,dT,dB,X] = cv_getparams(x,y,z)
% calculates the Frenet-Serret frame for each point t along the curve X.

% 1. Arc length reparameterization
% First the curve is reparamterized by arc length, such that there is a 
% parametrization of the line through the associated curvilinear abscissa,
% and we have X(s) which is a unit speed curve.

% 2. The unit tangent vector, T(s), and curvature, k(s)
% The length of the tangent vector, |Xprime(s)| is equal to 1 for all t,
% therefore the unit tangent vector T(s) is defined as: T(s) = Xprime(s).
% Furthermore, Xdblprime(s) = Tprime(s), and Tprime(s) is perpendicular to
% T(s). The curvature then, is defined as the length of the derivative 
% (or rate of change) of the unit tangent vector, T(s), such that the
% curvature k(s) is defined as: k(s) = |Tprime(s)|.

% 3. The unit normal vector, N(s)
% We can now define a unit normal vector, N(s), perpendicular to the unit
% tangent vector, T(s) such that:
% N(s) = Xdblprime(s)/|Xdblprime(s)| 
%      = Tprime(s)/|Tprime(s) 
%      = Tprime(s)/k(s)
% At any point, s along the curve X(s), N(s) points towards the center of 
% curvature (i.e. the center of the osculating circle).
% The plane at any point, s, spanned by N(s) and T(s) is the osuclating
% plane of the curve at that point.

% 4. The unit binormal vector, B(s)
% We complete T(s), N(s) by defining the binormal vector, another unit
% vector, such that: B(s) = T(s) x N(s). Together, T(s), N(s) and B(s) form
% a right handed tripod. The ordered set (T(s),N(s),B(s)) is called the 
% Frenet frame at point s.

% 5. Torsion
% Finally we can relate the normal and binormal vectors to the torsion, tau(s)
% by the following equations:
%    a. B(s) = cross(T(s),N(s))
%    b. Bprime(s) = -tau(s)*N(s)
% such that we have:
%    c. tau(s) = -Bprime(s)/N(s)

% Frenet-Serret Planes
% 1. Spanned by T & N = Osculating plane
% 2. Spanned by N & B = nomral plane
% 3. Spanned by T & B = rectifying plane
%
% Curvature == Deviation from a straight line (bending)
% Torsion   == Twisting

% Summary:
%    _    X'
%    T = ----  (Tangent)
%        |X'|
% 
%    _    T'
%    N = ----  (Normal)
%        |T'|
%    _   _   _
%    B = T x N (Binormal)
% 
%    k = |T'|  (Curvature)
% 
%    t = dot(-B',N) (Torsion)


% By: Ari Kappel, Chander Sadasivan, 08/2014

%%
% NOTE: X must be an n by 3 matrix with n>=4!

% Example:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% t = linspace(0,2*pi,100)'; 
% X = [cos(t),sin(t),t];
% [kappa,tau,T,N,B] = ifrenetserret(X);
% figure;
% for i = 1:length(X)-3
%     plot3v(X(1:end-3,:));
%     h = gca;
%     set(h,'XLim',[-1     1],'YLim',[-1     1],'ZLim',[0     7]);
%     hold on;
%     quiver3(X(i,1),X(i,2),X(i,3),B(i,1),B(i,2),B(i,3)); %blue
%     quiver3(X(i,1),X(i,2),X(i,3),T(i,1),T(i,2),T(i,3)); %green
%     quiver3(X(i,1),X(i,2),X(i,3),N(i,1),N(i,2),N(i,3)); %red
%     top{1} = 'x = cos(t); y = sin(t); z = t';
%     top{2} = ['curvature = ' num2str(kappa(i)) ', torsion = ' num2str(tau(i))];
%     title(top)
%     F(i) = getframe;
%     hold off;
%     clear top;
% end
%     movie(F,1)
% 
% figure; hold on;
% plot(kappa,'b'); plot(tau,'r'); 
% legend('kappa','tau')

%% CODE
if iscell(x)
    
    kappa=cell(size(x));
    tau=cell(size(x));
    T=cell(size(x));
    N=cell(size(x));
    B=cell(size(x));
    s=cell(size(x));
    ds=cell(size(x));
    dX=cell(size(x));
    dT=cell(size(x));
    dB=cell(size(x));
    X=cell(size(x));
    
    for i=1:size(x)
        if ~isempty(x{i})
            X{i}=[x{i},y{i},z{i}];
            
            % 1. find the derivative of X, dX, and the arclength of dX, ds
            dX{i} = derive(X{i});
            ds{i} = sqrt(sum(dX{i}.^2,2));
            
            % 2. The unit tangent vector, T(s), is equal to Xprime(s);
            %    T(s) = Xprime(s)
            %    Find T(s) [aka. X',Xprime]
            Xprime{i} = dX{i}(2:end-1,:)./ds{i}(2:end-1,[1,1,1]);
            T{i} = Xprime{i};
            %T{i} = dX{i}./[ds{i};1];
            
            % 3. The curvature, k(s), is given by the magnitude of Tprime(s)
            %    k(s) = |Tprime(s)|
            %    Find Tprime(s)
            %    When ds is the arclength of X
            ds{i} = sqrt(sum(diff(X{i}).^2,2));
            s{i} = cumsum(ds{i});
            dT{i} = diff(T{i});
            Tprime{i} = dT{i}./ds{i}(1:length(dT{i}),[1,1,1]);
            kappa{i} = sqrt(sum(Tprime{i}.^2,2));
            
            % 4. Find the Unit Normal vector, N(s)
            %    N(s) = Tprime(s)/k(s)
            %         = Tprime(s)/|Tprime(s)|
            N{i} = Tprime{i}./kappa{i}(:,[1,1,1]);

            % 5. Find the Unit Binormal vector, B(s)
            %    B(s) = cross(T(s),N(s))
            B{i} = cross(T{i}(1:length(N{i}),:),N{i});
            
            % 6. The torsion, tau(s), is given by:
            %    tau(s) = -Bprime(s).*N(s)
            %    Find Bprime(s), and calculate the torsion, tau(s)
            dB{i} = diff(B{i});
            Bprime{i} = dB{i}./ds{i}(1:length(dB{i}),[1,1,1]);
            tau{i} = sum(-Bprime{i}.*N{i}(1:length(Bprime{i}),:),2);

        end
    end
end


function [dX] = derive(X)
% X is a vertical matrix, n x m, where m is 1,2 or 3

dX(1,:) = X(2,:)-X(1,:);

for i = 2:length(X)-1
    dX(i,:) = X(i+1,:)-X(i-1,:);
end

dX(end+1,:) = X(end,:) - X(end-1,:);
