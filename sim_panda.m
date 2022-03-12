clear;
[Slist,Mlist,Glist,M,w,p] = load_urdf("panda.urdf",7)
thetalist = [0,0,0,0,0,0,0]';
dthetalist = [0,0,0,0,0,0,0]';
ddthetalist= [0,0,0,0,0,0,0]';
mMat = MassMatrix(thetalist, Mlist, Glist, Slist)
cMat = VelQuadraticForces(thetalist, dthetalist, Mlist, Glist, Slist)
g = [0; 0; -9.8];


%draw FK & FD
dt = 0.01;
endTime = 1;
for t = linspace(0,endTime,endTime/dt)
    FKlist = getFKlist(w,p,thetalist,M);

    clf;
    plot3([],[],[]);
    grid on;
    line_x = [];
    line_y = [];
    line_z = [];
    for i = 1:1:length(FKlist)
        drawAxis(FKlist{i},0.1,1);
        hold on;
        line_x = [line_x,FKlist{i}(1,4)];
        line_y = [line_y,FKlist{i}(2,4)];
        line_z = [line_z,FKlist{i}(3,4)];
    end
    line(line_x,line_y,line_z)
    daspect([1,1,1])
    view(120,30)
    axis([-max([M(1,4),M(2,4),M(3,4)]), max([M(1,4),M(2,4),M(3,4)]),-max([M(1,4),M(2,4),M(3,4)]), max([M(1,4),M(2,4),M(3,4)]),0,2])
    hold off;
    gMat = GravityForces(thetalist, g, Mlist, Glist, Slist)
    drawnow;

    thetalist(2) = thetalist(2)+pi*sin(dt);
end