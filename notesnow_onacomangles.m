figure; hold on
for i=1:length(xs)
    if ~isempty(xs(i))
        if exist('c','var')
            plot3(xs{i},ys{i},zs{i},'*','color',c(i,:))
        end
    end
end


for i=1:length(xs)
    for j=1:length(xs{i})-3
        quiver3(xs{i}(j),ys{i}(j),zs{i}(j),B{i}(j,1),B{i}(j,2),B{i}(j,3),'g');
        %quiver3(xs{i}(j),ys{i}(j),zs{i}(j),T{i}(j,1),T{i}(j,2),T{i}(j,3),'b'); %green
        %quiver3(xs{i}(j),ys{i}(j),zs{i}(j),N{i}(j,1),N{i}(j,2),N{i}(j,3),'r'); %red
    end
end
%axis equal
set(gca,'view',[180,0])



%% find redundant lines and manually remove from idx

t1=find(cell2mat(xs(idx))==o1.Position(1));
t2=find(cell2mat(ys(idx))==o1.Position(2));
t3=find(cell2mat(zs(idx))==o1.Position(3));
if isequal(t1,t2) && isequal(t2,t3)
   for i=1:length(idx)
       linesize(i)=size(xs{idx(i)},1);
   end
   cumlinesize=cumsum(linesize);
   linenow=find(t1<cumlinesize);
   linenow = idx(linenow(1))
   ptnow=t1
end

%% Now delete from all variables

for i = setdiff(1:length(xs),idx)
    xs{i}=[];
    ys{i}=[];
    zs{i}=[];
    
    kappa{i}=[];
    tau{i}=[];
    T{i}=[];
    N{i}=[];
    B{i}=[];
    s{i}=[];
    ds{i}=[];
    dX{i}=[];
    dT{i}=[];
    dB{i}=[];
    X{i}=[];
end

%%
idx1=2;
idx2=7;
l1 =[xs{idx1}(3:end),ys{idx1}(3:end),zs{idx1}(3:end)]; %RACA
l2 = [flipud(xs{idx2}(1:end-3)),flipud(ys{idx2}(1:end-3)),flipud(zs{idx2}(1:end-3))]; %R_Acomm

a1 = B{idx1}(3:end,:); %RACA
a2 = flipud(B{idx2}(1:end-3,:)); %R_Acomm

figure; hold on
plot3(l1(:,1),l1(:,2),l1(:,3),'*','color',c(idx1,:))
plot3(l2(:,1),l2(:,2),l2(:,3),'*','color',c(idx2,:))

quiver3(l1(1:end-3,1),l1(1:end-3,2),l1(1:end-3,3),a1(:,1),a1(:,2),a1(:,3),'g');
quiver3(l2(1:end-3,1),l2(1:end-3,2),l2(1:end-3,3),a2(:,1),a2(:,2),a2(:,3),'r');

%axis equal
set(gca,'view',[180,0])

for i=1:min([size(a1,1),size(a2,1)])
    angles(i) = atan2(norm(cross(a1(i,:),a2(i,:))), dot(a1(i,:),a2(i,:)));
end