function varargout=disptable(pot,varargin)
%DISPTABLE Print the table of an array brml.
% disptable(pot,vars)
% If called as disptable(pot,[var1 var2...]), the table is displayed
% according to the specified variable order.
% If called as disptable(pot,varinf,[var1 var2...]), the table is displayed using the
% variable names and states in varinf
import brml.*
if length(pot)>1; error('Cannot display multiple arrays.'); end
alls=[];
if ~isempty(pot.variables)
    vars=sort(pot.variables); varinf=[];
    if length(varargin)>0
        varinf=varargin{1};
    end
    if length(varargin)==2
        vars=varargin{2};
    end
    if ~isempty(setdiff(pot.variables,vars)); error('The variables you asked to display are not equal to the full set of variables in the potential'); end
    pot=brml.orderpot(pot,vars);
    nstates=size(pot);
    arr=ind2subv(nstates,1:prod(nstates));
    
    for c=1:size(arr,1)
        strc=0;nstr=[]; dstr=[];
        state=arr(c,:);
        if isstruct(varinf)
            for k=1:length(vars)
                kk=vars(k); strc=strc+1;
                nstr(c,strc)=length(char(varinf(kk).name));
                dstr(c,strc)=length(char(varinf(kk).domain(state(k))));
            end
        end
    end
    tmpn=max(nstr)+1; tmpd=max(dstr)+1;
    
    for c=1:size(arr,1)
        str=[];strc=0;
        state=arr(c,:);
        if isstruct(varinf)
            for k=1:length(vars)
                kk=vars(k);strc=strc+1;
                str=[str sprintf('%-*s\t=%-*s\t',tmpn(strc),char(varinf(kk).name),tmpd(strc),char(varinf(kk).domain(state(k))))];
            end
        elseif varinf==1
            str=sprintf('%d ',state);
        end
        if strcmp(class(pot.table(c)),'sym')
            s=sprintf([str '%s'],char(pot.table(c)));
        else
            s=sprintf([str '%s'],pot.table(c));
        end
        
        if nargout==0;disp(s);
        else
            alls{c}=sprintf('\t%s',s);
        end
    end
else
    alls=pot.table;
end
varargout{1}=alls;