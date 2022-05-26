function [F1cueF1,F1cueM1,M1cueM1,M1cueF1,bothcueF1,bothcueM1] = changecells(F1cueF1,F1cueM1,M1cueM1,M1cueF1,bothcueF1,bothcueM1,changecell)

delcellidx = changecell.delcellidx;
move_to_female_cellidx = changecell.move_to_female_cellidx;
move_to_male_cellidx = changecell.move_to_male_cellidx;
move_to_both_cellidx = changecell.move_to_both_cellidx;

delcellidx = [delcellidx,move_to_female_cellidx,move_to_male_cellidx,move_to_both_cellidx];
alength(1) = size(F1cueF1,1);
alength(2)  = size(M1cueM1,1);
alength(3)  = size(bothcueF1,1);
alist{1} = 1:1:alength(1);
alist{2} = 1:1:alength(2);
alist{3} = 1:1:alength(3);

f1f = F1cueF1;
f1m = F1cueM1;
m1m = M1cueM1;
m1f = M1cueF1;
b1f = bothcueF1;
b1m = bothcueM1;

for i =1:length(delcellidx)
    if delcellidx(i) <= alength(1)
        alist{1}(alist{1} == delcellidx(i)) = [];
    elseif delcellidx(i) > alength(1)&&delcellidx(i) <= alength(2)+ alength(1)
        alist{2}(alist{2} == delcellidx(i)-alength(1)) = [];
    elseif delcellidx(i) > alength(2)+ alength(1)&&delcellidx(i) <= alength(2)+ alength(1)+alength(3)
        alist{3}(alist{3} == delcellidx(i)-alength(2)- alength(1)) = [];
    end
end
f1f = f1f(alist{1},:);
f1m = f1m(alist{1},:);
m1m = m1m(alist{2},:);
m1f = m1f(alist{2},:);
b1f = b1f(alist{3},:);
b1m = b1m(alist{3},:);

f1fadd = [];
f1madd = [];
m1fadd = [];
m1madd = [];
b1madd = [];
b1fadd = [];

for i =1:length(move_to_female_cellidx)
    if move_to_female_cellidx(i) <= alength(1)
%         f1fadd = [f1fadd;F1cueF1(move_to_female_cellidx(i),:)];
%         f1madd = [f1madd;F1cueM1(move_to_female_cellidx(i),:)];
    elseif move_to_female_cellidx(i) > alength(1)&&move_to_female_cellidx(i) <= alength(2)+ alength(1)
        f1fadd = [f1fadd;M1cueF1(move_to_female_cellidx(i)-alength(1),:)];
        f1madd = [f1madd;M1cueM1(move_to_female_cellidx(i)-alength(1),:)];
    elseif move_to_female_cellidx(i) > alength(2)+ alength(1)&&move_to_female_cellidx(i) <= alength(2)+ alength(1)+alength(3)
        f1fadd = [f1fadd;bothcueF1(move_to_female_cellidx(i)-alength(2)- alength(1),:)];
        f1madd = [f1madd;bothcueM1(move_to_female_cellidx(i)-alength(2)- alength(1),:)];
    end
end

for i =1:length(move_to_male_cellidx)
    if move_to_male_cellidx(i) <= alength(1)
        m1fadd = [m1fadd;F1cueF1(move_to_male_cellidx(i),:)];
        m1madd = [m1madd;F1cueM1(move_to_male_cellidx(i),:)];
    elseif move_to_male_cellidx(i) > alength(1)&&move_to_male_cellidx(i) <= alength(2)+ alength(1)
%         m1fadd = [m1fadd;M1cueF1(move_to_male_cellidx(i)-alength(1),:)];
%         m1madd = [m1madd;M1cueM1(move_to_male_cellidx(i)-alength(1),:)];
    elseif move_to_male_cellidx(i) > alength(2)+ alength(1)&&move_to_male_cellidx(i) <= alength(2)+ alength(1)+alength(3)
        m1fadd = [m1fadd;bothcueF1(move_to_male_cellidx(i)-alength(2)- alength(1),:)];
        m1madd = [m1madd;bothcueM1(move_to_male_cellidx(i)-alength(2)- alength(1),:)];
    end
end

for i =1:length(move_to_both_cellidx)
    if move_to_both_cellidx(i) <= alength(1)
        b1madd = [b1madd;F1cueM1(move_to_both_cellidx(i),:)];
        b1fadd = [b1fadd;F1cueF1(move_to_both_cellidx(i),:)];
    elseif move_to_both_cellidx(i) > alength(1)&&move_to_both_cellidx(i) <= alength(2)+ alength(1)
        b1madd = [b1madd;M1cueM1(move_to_both_cellidx(i)-alength(1),:)];
        b1fadd = [b1fadd;M1cueF1(move_to_both_cellidx(i)-alength(1),:)];
    elseif move_to_both_cellidx(i) > alength(2)+ alength(1)&&move_to_both_cellidx(i) <= alength(2)+ alength(1)+alength(3)
%         b1madd = [b1madd;bothcueM1(move_to_both_cellidx(i)-alength(2)- alength(1),:)];
%         b1fadd = [b1fadd;bothcueF1(move_to_both_cellidx(i)-alength(2)- alength(1),:)];
    end
end

F1cueF1 = [f1f;f1fadd];
M1cueF1 = [m1f;m1fadd];
bothcueM1 = [b1m;b1madd];
F1cueM1 = [f1m;f1madd];
M1cueM1 = [m1m;m1madd];
bothcueF1 = [b1f;b1fadd];

end