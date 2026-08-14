function animation_articulatedVehicle(obj,trajectoryx, vehicle, save_video)
    if save_video
        videoName = vehicle.Name;
        v = VideoWriter(strcat('results/',videoName,'.avi'), 'Motion JPEG AVI');
        v.FrameRate = 30;
        open(v);
    end

    x = trajectoryx.X;          

    x_robot = x(:,1);
    y_robot = x(:,2);
    theta_robot = x(:,3);
    gama = x(:,4);
    %gama = theta_robot-theta_trailer
    theta_trailer = theta_robot - gama;

    robot_radius = vehicle.axisLength/2;

    trailer_width = vehicle.axisLengthTrailer;
    trailer_length  = (1/2) * vehicle.axisLength;

    l = vehicle.l; %robot to joint
    l_t = vehicle.l_t; %joint to trailer

    x_G = x_robot - l*cos(theta_robot);
    y_G = y_robot - l*sin(theta_robot);

    x_trailer = x_robot - l*cos(theta_robot) - l_t*cos(theta_trailer);
    y_trailer = y_robot - l*sin(theta_robot) - l_t*sin(theta_trailer);

    % margins                
    margin = vehicle.axisLength;
    xmin = min([x_robot; x_trailer]) - margin;
    xmax = max([x_robot; x_trailer]) + margin;
    ymin = min([y_robot; y_trailer]) - margin;
    ymax = max([y_robot; y_trailer]) + margin;

    fig = figure('Units','pixels','Position',[100 100 800 600]);
    set(fig, 'Resize', 'off');
    axis equal;
    axis([xmin xmax ymin ymax]);
    grid on;
    hold on;
    xlabel('x');
    ylabel('y');       

    % robot
    plot(x_robot, y_robot, '--', 'LineWidth', 1);
    
    h_robot = patch(nan, nan, [0.2 0.6 0.9], ...
                    'FaceAlpha', 0.7);

    h_center_robot = plot(nan, nan, 'ko', 'MarkerFaceColor', 'k', 'MarkerSize', 4);
    h_heading_robot = plot(nan, nan, 'k-', 'LineWidth', 2);

    % G
    h_center_G = plot(nan, nan, 'ko', 'MarkerFaceColor', 'k', 'MarkerSize', 4);
    

    % trailer
    plot(x_trailer, y_trailer, ':', 'LineWidth', 1);
    h_trailer = patch(nan, nan, [0.9 0.5 0.2], 'FaceAlpha', 0.7);
    h_center_trailer = plot(nan, nan, 'ko', 'MarkerFaceColor', 'k', 'MarkerSize', 4);
    h_heading_trailer = plot(nan, nan, 'k-', 'LineWidth', 2);

    % hook link
    h_link1 = plot(nan, nan, 'k-', 'LineWidth', 1.5);
    h_link2 = plot(nan, nan, 'k-', 'LineWidth', 1.5);

    for k = 1:length(x_robot)
        p_robot = [x_robot(k); y_robot(k)];
        p_G = [x_G(k); y_G(k)];
        p_trailer = [x_trailer(k); y_trailer(k)];

        % robot
        set(h_robot, 'Position', [ ...
            p_robot(1) - robot_radius, ...
            p_robot(2) - robot_radius, ...
            2*robot_radius, ...
            2*robot_radius]);
        set(h_center_robot, 'XData', p_robot(1), 'YData', p_robot(2));
        
        % G
        set(h_center_G, 'XData', p_G(1), 'YData', p_G(2));

        % trailer
        trailer_xy = obj.orientedRectangle(p_trailer, theta_trailer(k), trailer_length, trailer_width);
        set(h_trailer, 'XData', trailer_xy(1,:), 'YData', trailer_xy(2,:));
        set(h_center_trailer, 'XData', p_trailer(1), 'YData', p_trailer(2));

        % hook link
        set(h_link1, 'XData', [p_robot(1), p_G(1)], ...
                    'YData', [p_robot(2), p_G(2)]);
        set(h_link2, 'XData', [p_G(1), p_trailer(1)], ...
                    'YData', [p_G(2), p_trailer(2)]);

        % direction arrow
        dir_len_robot = robot_radius;
        set(h_heading_robot, ...
            'XData', [p_robot(1), p_robot(1) + dir_len_robot*cos(theta_robot(k))], ...
            'YData', [p_robot(2), p_robot(2) + dir_len_robot*sin(theta_robot(k))]);

        % trailer
        dir_len_trailer = 0.5 * trailer_length;
        set(h_heading_trailer, ...
            'XData', [p_trailer(1), p_trailer(1) + dir_len_trailer*cos(theta_trailer(k))], ...
            'YData', [p_trailer(2), p_trailer(2) + dir_len_trailer*sin(theta_trailer(k))]);

        drawnow;
        itm_formatfig(8, 'LineWidth', 1.5);
        
        if save_video
            frame = getframe(gcf);
            writeVideo(v, frame);
        end

        pause(0.03);
    end
end