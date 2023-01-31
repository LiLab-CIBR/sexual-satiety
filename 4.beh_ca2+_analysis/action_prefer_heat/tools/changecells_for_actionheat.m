function [A,B,C,D] = changecells_for_actionheat(A,B,C,D,delcellidx)

% A = Acelltrace{i};
% B = Bcelltrace{i};
% C = bothcelltrace{i};
% D = othercelltrace{i};
% delcellidx = delcell;

alength(1) = size(A,1);
alength(2)  = size(B,1);
alength(3)  = size(C,1);
alist{1} = 1:1:alength(1);
alist{2} = 1:1:alength(2);
alist{3} = 1:1:alength(3);
alength(4)  = size(D,1);
alist{4} = 1:1:alength(4);

a = A;
b = B;
c = C;
d = D;
for i =1:length(delcellidx)
    if delcellidx(i) <= alength(1)
        alist{1}(alist{1} == delcellidx(i)) = [];
    elseif delcellidx(i) > alength(1)&&delcellidx(i) <= alength(2)+ alength(1)
        alist{2}(alist{2} == delcellidx(i)-alength(1)) = [];
    elseif delcellidx(i) > alength(2)+ alength(1)&&delcellidx(i) <= alength(2)+ alength(1)+alength(3)
        alist{3}(alist{3} == delcellidx(i)-alength(2)- alength(1)) = [];
    elseif delcellidx(i) > alength(3) + alength(2)+ alength(1)&&delcellidx(i) <= alength(2)+ alength(1)+alength(3)+alength(4)
        alist{4}(alist{4} == delcellidx(i)- alength(3)- alength(2)- alength(1)) = [];
    end
end
a = a(alist{1},:);
b = b(alist{2},:);
c = c(alist{3},:);
d = d(alist{4},:);

A = a;
B = b;
C = c;
D = d;
end