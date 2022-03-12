function FKlist = getFKlist(w,p,thetalist,M)

    Slist = w_p_to_Slist(w,p);
    % draw FK result
     matS={};
     FKlist={};
     for i = 1:1:length(Slist)
         M_ = eye(4);
         M_(1,4) = p(i,1);
         M_(2,4) = p(i,2);
         M_(3,4) = p(i,3);
        
         S_ =Slist(:,i);
         matS{end+1} = MatrixExp6(VecTose3(S_)*thetalist(i));
         prodmatS = eye(4);
         for j = 1:1:length(matS)
             prodmatS =prodmatS*matS{j}; 
         end
         FKlist{end+1} = prodmatS*M_;
     end
     FKlist{end+1} = FKinSpace(M,Slist,thetalist);
end