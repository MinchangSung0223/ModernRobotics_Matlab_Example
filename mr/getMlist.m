function Mlist_ = getMlist(rpy,com)
    Mlist_=[];
    Mlist={};
    for i = 1:1:length(com)
        T =eye(4);
        R = eul2rotm(rpy(i,:));
        T(1:3,1:3) = R;
        T(1,4) = com(i,1);
        T(2,4) = com(i,2);
        T(3,4) = com(i,3);
        Mlist{end+1} = T;
    end
    Mlist_=cat(3,Mlist_,Mlist{1})
     for i = 2:1:length(com)
        M = TransInv(Mlist{i-1} )*Mlist{i}
        Mlist_ = cat(3,Mlist_,M);
    end   
end