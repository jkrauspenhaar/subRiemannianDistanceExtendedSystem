function animation_robot(obj,trajectoryx, vehicle,save_video)
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

    % Roboter-Geometrie
    robot_radius = vehicle.axisLenght/2;

    % Plotgrenzen                
    margin = vehicle.axisLenght*(2/3);
    xmin = min(x_robot) - margin;
    xmax = max(x_robot) + margin;
    ymin = min(y_robot) - margin;
    ymax = max(y_robot) + margin;

    figure();
    axis equal;
    axis([xmin xmax ymin ymax]);
    grid on;
    hold on;
    xlabel('x');
    ylabel('y');

    plot(x_robot, y_robot, '--', 'LineWidth', 1);

    h_robot = rectangle('Position',[0 0 0 0], ...
                        'Curvature',[1 1], ...
                        'FaceColor',[0.2 0.6 0.9], ...
                        'FaceAlpha',0.7);

    h_center = plot(nan, nan, 'ko', 'MarkerFaceColor', 'k', 'MarkerSize', 4);
    h_heading = plot(nan, nan, 'k-', 'LineWidth', 2);
        
    for k = 1:length(x_robot)
        p = [x_robot(k); y_robot(k)];

        % robot
        set(h_robot, 'Position', [ ...
            p(1) - robot_radius, ...
            p(2) - robot_radius, ...
            2*robot_radius, ...
            2*robot_radius]);

        set(h_center, 'XData', p(1), 'YData', p(2));

        % direction
        dir_len = robot_radius;
        set(h_heading, ...
            'XData', [p(1), p(1) + dir_len*cos(theta_robot(k))], ...
            'YData', [p(2), p(2) + dir_len*sin(theta_robot(k))]);

        drawnow;
        itm_formatfig(8, 'LineWidth', 1.5);

        if save_video
            frame = getframe(gcf);
            writeVideo(v, frame);
        end

        pause(0.03);
    end 
end