function [Slist,Mlist,Glist,M,w,p,robot] = load_urdf(urdf_path,joint_num)
    %% 
    %      Author : Minchang Sung
    %      E-mail : tjdalsckd@gmail.com
    %      Homepage : tjdalsckd.github.io
    


    robot = importrobot(urdf_path)
    Tlist = {};
    axislist = {};
    p = [];
    w = [];
    body_num =[];
    for i = 1:1:length(robot.Bodies)
        jointAxis=robot.Bodies{i}.Joint.JointAxis;
        if norm(jointAxis)~=1 
            continue;
        end
        if ~strcmp(robot.Bodies{i}.Joint.Type,'revolute')
            continue;
        end
        Tlist{end+1} = robot.Bodies{i}.Joint.JointToParentTransform;
        axislist{end+1} = robot.Bodies{i}.Joint.JointAxis;
        R = eye(3);
        T = eye(4);
        for j = 1:1:length(Tlist)
            T_ = Tlist{j};
            R = R*T_(1:3,1:3);
            T = T*T_;
        end
        p = [p;T(1,4),T(2,4),T(3,4)];
        w =[w; (R*axislist{end}')'];
        body_num =[body_num,i];
        if body_num(1)+joint_num < i
            break;
        end
    end
    Tlist{end+1} = robot.Bodies{body_num(end)+1}.Joint.JointToParentTransform;
    M = eye(4);
    for i = 1:1:joint_num+1
        M = M*Tlist{i};
    end
    Slist = w_p_to_Slist(w,p);
    
    massList = [];
    inertiaList = {};
    comXYZList = [];
    comRPYList = [];
    for i = body_num(1):1:body_num(1)+joint_num-1
        inertiaList{end+1} = robot.Bodies{i}.Inertia;
        massList = [massList,robot.Bodies{i}.Mass];
        comXYZList = [comXYZList; robot.Bodies{i}.CenterOfMass];
    end
    com_p = []
    for i =1:1:length(comXYZList)
        com_p=[com_p;p(i,1)+comXYZList(i,1),p(i,2)+comXYZList(i,2),p(i,3)+comXYZList(i,3)]
    end
    com_p = [com_p;M(1,4),M(2,4),M(3,4)]
    Mlist = getMlist(com_p);
    Glist = getGlist(inertiaList,massList);

end

function Slist = w_p_to_Slist(w,p)
Slist = [];
for i = 1:1:size(w,1)
    S=-cross(w(i,:),p(i,:));
    S = [w(i,:),S];
    Slist= [Slist,S'];
end
end

function Mlist_ = getMlist(com)
    Mlist_=[];
    Mlist={};
    for i = 1:1:length(com)
        T =eye(4);
        R = eul2rotm([0,0,0]);
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