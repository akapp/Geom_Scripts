function [refidx,linenow,ptnow,lineref] = cv_processcursor(cursor,xs,ys,zs)

%===============================================================
% Main Function for cv_selectsegment
%===============================================================

idx=find(~cellfun(@isempty,xs))';
t1=find(cell2mat(xs(idx))==cursor.Position(1));
t2=find(cell2mat(ys(idx))==cursor.Position(2));
t3=find(cell2mat(zs(idx))==cursor.Position(3));
if isequal(t1,t2) && isequal(t2,t3)
    for i=1:length(idx)
        linesize(i)=size(xs{idx(i)},1);
    end
    cumlinesize=cumsum(linesize);
    refidx=[]; linenow=[]; ptnow=[]; lineref=[];
    for i=1:length(t1)
        tmp = find(t1(i)<=cumlinesize);
        refidx(i)   = tmp(1);
        linenow(i)  = idx(refidx(i));
        ptnow(i)    = t1(i);
        if refidx(i)~=1 && ~any(ptnow(i)==cumlinesize)
            lineref(i)  = t1(i)-cumlinesize(refidx(i)-1);
        elseif refidx(i)==1 && ~any(ptnow(i)==cumlinesize)
            lineref(i)  = t1(i);
        elseif any(ptnow(i)==cumlinesize)
            lineref(i)  = t1(i)-cumlinesize(refidx(i)-1);
        end
    end
end