function animation_trailer(obj,trajectoryx, vehicle,save_video)
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
    theta_trailer = x(:,4);

    robot_radius = vehicle.axisLength/2;

    trailer_width = vehicle.axisLengthTrailer;
    trailer_length  = (1/2) * vehicle.axisLength;
    b1x = vehicle.hookLength;

    x_trailer = x_robot - b1x*cos(theta_trailer);
    y_trailer = y_robot - b1x*sin(theta_trailer);

    % margins                
    margin = vehicle.axisLength;
    xmin = min([x_robot; x_trailer]) - margin;
    xmax = max([x_robot; x_trailer]) + margin;
    ymin = min([y_robot; y_trailer]) - margin;
    ymax = max([y_robot; y_trailer]) + margin;

    figure();
    axis equal;
    axis([xmin xmax ymin ymax]);
    grid on;
    hold on;
    xlabel('x');
    ylabel('y');       

    % robot
    plot(x_robot, y_robot, '--', 'LineWidth', 1);
    h_robot = rectangle('Position',[0 0 0 0], ...
                        'Curvature',[1 1], ...
                        'FaceColor',[0.2 0.6 0.9], ...
                        'FaceAlpha',0.7);

    h_center_robot = plot(nan, nan, 'ko', 'MarkerFaceColor', 'k', 'MarkerSize', 4);
    h_heading_robot = plot(nan, nan, 'k-', 'LineWidth', 2);

    % trailer
    plot(x_trailer, y_trailer, ':', 'LineWidth', 1);
    h_trailer = patch(nan, nan, [0.9 0.5 0.2], 'FaceAlpha', 0.7);
    h_center_trailer = plot(nan, nan, 'ko', 'MarkerFaceColor', 'k', 'MarkerSize', 4);
    h_heading_trailer = plot(nan, nan, 'k-', 'LineWidth', 2);

    % hook link
    h_link = plot(nan, nan, 'k-', 'LineWidth', 1.5);

    for k = 1:length(x_robot)
        p_robot = [x_robot(k); y_robot(k)];
        p_trailer = [x_trailer(k); y_trailer(k)];

        % robot
        set(h_robot, 'Position', [ ...
            p_robot(1) - robot_radius, ...
            p_robot(2) - robot_radius, ...
            2*robot_radius, ...
            2*robot_radius]);
        set(h_center_robot, 'XData', p_robot(1), 'YData', p_robot(2));

        % trailer
        trailer_xy = obj.orientedRectangle(p_trailer, theta_trailer(k), trailer_length, trailer_width);
        set(h_trailer, 'XData', trailer_xy(1,:), 'YData', trailer_xy(2,:));
        set(h_center_trailer, 'XData', p_trailer(1), 'YData', p_trailer(2));

        % hook link
        set(h_link, 'XData', [p_robot(1), p_trailer(1)], ...
                    'YData', [p_robot(2), p_trailer(2)]);

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