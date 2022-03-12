clear;
%% Modern Robotics 파라미터 세팅
[Slist,Mlist,Glist,M,w,p,robot] = load_urdf("indy7.urdf",6)

% 초기값 설정
thetalist = [0,pi/3,0,0,0,0]';
dthetalist = [0,0.1,0,0,0,0]';
ddthetalist= [0,0,0,0,0,0]';

%% Inverse Dynamics 계산
% Mass Matrix 계산
mMat = MassMatrix(thetalist, Mlist, Glist, Slist)
% Corioris Matrix 계산
cMat = VelQuadraticForces(thetalist, dthetalist, Mlist, Glist, Slist)
% Gravity Matrix 계산
g = [0; 0; -9.8];
gMat = GravityForces(thetalist, g, Mlist, Glist, Slist)

%% Simulation 진행
dt = 0.01;
endTime = 1;
thetalist_list ={};
for t = linspace(0,endTime,endTime/dt)
    %조인트 Forward Kinematics 계산
    FKlist = getFKlist(w,p,thetalist,M);

    % Forward Dynamics 계산
    taulist = [0,0,0,0,0,0]';
    Ftip = [0,0,0,0,0,0]';
    ddthetalist = ForwardDynamics(thetalist, dthetalist, taulist, ...
                                           g, Ftip, Mlist, Glist, Slist);
    % Euler 적분 
    [thetalistNext, dthetalistNext] ...
         = EulerStep(thetalist, dthetalist, ddthetalist, dt);
    thetalist_list{end+1} = thetalist;
    thetalist=thetalistNext;
    dthetalist=dthetalistNext;
end


%% Draw robot
config = homeConfiguration(robot)
f = figure(11);
for i=1:1:length(thetalist_list)
    thetalist = thetalist_list{i};
    for j =1:1:length(thetalist)
        config(j).JointPosition = thetalist(j)
    end
    show(robot,config,"FastUpdate",1,"PreservePlot",0);
    view(120,35)
    drawnow
end

