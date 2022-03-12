function drawAxis(T,linelength,linewidth)
    p0 = T*[0;0;0;1];
    px = T*[linelength;0;0;1];
    py = T*[0;linelength;0;1];
    pz = T*[0;0;linelength;1];
    %draw X
    line([p0(1) px(1)],[p0(2) px(2)],[p0(3) px(3)],"Color",[1,0,0],"LineWidth",linewidth);
    hold on;
    %draw Y
    line([p0(1) py(1)],[p0(2) py(2)],[p0(3) py(3)],"Color",[0,1,0],"LineWidth",linewidth);
    %draw Z
    line([p0(1) pz(1)],[p0(2) pz(2)],[p0(3) pz(3)],"Color",[0,0,1],"LineWidth",linewidth);
    
    plot3(p0(1),p0(2),p0(3),"k.","MarkerSize",linewidth*7)
end