function Slist = w_p_to_Slist(w,p)
Slist = [];
for i = 1:1:size(w,1)
    S=-cross(w(i,:),p(i,:));
    S = [w(i,:),S];
    Slist= [Slist,S'];
end
end