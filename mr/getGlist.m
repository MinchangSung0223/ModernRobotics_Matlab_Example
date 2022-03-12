function Glist_ = getGlist(InertiaList,mass)
    Glist = {};
    Glist_ = [];
    for i = 1:1:length(mass)
        G =eye(6);
        Inertia = InertiaList{i};
        G(1,1) = Inertia(1);
        G(2,2) = Inertia(2);
        G(3,3) = Inertia(3);        
        G(1,2) = Inertia(4);
        G(2,1) = Inertia(4);
        G(2,3) = Inertia(5);
        G(3,2) = Inertia(5);
        G(1,3) = Inertia(6);
        G(3,1) = Inertia(6);
        G(4,4) = mass(i);
        G(5,5) = mass(i);
        G(6,6) = mass(i);
        Glist{end+1} = G;
        Glist_ = cat(3,Glist_,G);
    end
end