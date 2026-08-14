function corners_rectangle = orientedRectangle(obj,center, angle, L, W)            
        corners_local = [ ...
            -L/2, -W/2;
             L/2, -W/2;
             L/2,  W/2;
            -L/2,  W/2;
            -L/2, -W/2]';            
        R = [cos(angle), -sin(angle);
             sin(angle),  cos(angle)];            
        corners_rectangle = R * corners_local + center;
end