function xy = orientedRoundedRectangle(obj, center, angle, L, W, r, npointsEcke)

    r = min(r, min(L,W)/2);

    cx = L/2 - r;
    cy = W/2 - r;

    % corner arcs, each as 2 x nArc
    a1 = linspace(-pi/2, 0, npointsEcke);       % bottom right
    a2 = linspace(0, pi/2, npointsEcke);        % top right
    a3 = linspace(pi/2, pi, npointsEcke);       % top left
    a4 = linspace(pi, 3*pi/2, npointsEcke);     % bottom left

    p1 = [ cx + r*cos(a1); -cy + r*sin(a1)];
    p2 = [ cx + r*cos(a2);  cy + r*sin(a2)];
    p3 = [-cx + r*cos(a3);  cy + r*sin(a3)];
    p4 = [-cx + r*cos(a4); -cy + r*sin(a4)];

    % complete polygon, size 2 x N
    pts = [p1 p2 p3 p4];

    % close polygon
    pts(:,end+1) = pts(:,1);

    R = [cos(angle), -sin(angle);
         sin(angle),  cos(angle)];

    center = center(:);   % ensure 2 x 1

    xy = R * pts + center;
end