classdef Visualizer
    properties (SetAccess = private)
        % System   % für später, falls Roboter z.B. gezeichnet werden soll
    end

    methods
        %% Konstruktor
        % function obj = Visualizer(system)
            % if nargin < 1
            %     system = [];
            % end
            % obj.System = system;
        % end
        
        function plotTrajectory(obj, Traj)
            T = Traj.timeGrid();
            X = Traj.data;
            n = Traj.dimension();

            figure();
            for j = 1:n
                subplot(n,1,j);
                plot(T,X(:,j));
                xlabel('t');
                ylabel(Traj.names(j));
                grid on;
            end  
            sgtitle(Traj.title);
        end    
       
        % XY-diagram plotten
        function plotPath(obj, xTraj, idxX, idxY)
            if nargin < 3
                idxX = 1;
                idxY = 2;
            end

            X = xTraj.data();

            figure;
            plot(X(:,idxX), X(:,idxY), 'LineWidth', 2);
            grid on;
            axis equal;
            xlabel(xTraj.names(1));
            ylabel(xTraj.names(2));
            title('x-y diagram');
        end

        function animation(obj,trajectoryx, vehicle,save_video) 
            if isa(vehicle,'Robot')
                obj.animation_robot(trajectoryx, vehicle,save_video) 
            elseif isa(vehicle,'Trailer')
                obj.animation_trailer(trajectoryx, vehicle,save_video) 
            elseif or(isa(vehicle,'ArticulatedVehicle'),isa(vehicle,'ArticulatedVehicleCollapsed'))
                if vehicle.tractor.bool
                    obj.animation_articulatedVehicleTractor(trajectoryx, vehicle,save_video)
                else
                    obj.animation_articulatedVehicle(trajectoryx, vehicle,save_video)
                end
            end            
        end 

        function animationAndCost(obj,trajectoryx, cost, vehicle,save_video) 
            if or(isa(vehicle,'ArticulatedVehicle'),isa(vehicle,'ArticulatedVehicleCollapsed'))
                if vehicle.tractor.bool
                    obj.animation_articulatedVehicleTractorAndCost(trajectoryx, cost, vehicle,save_video)
                end
            end            
        end 
        
     


    end

    methods (Access = private)

        animation_robot(obj,trajectoryx, vehicle,save_video)

        animation_trailer(obj,trajectoryx, vehicle,save_video)        

        animation_articulatedVehicle(obj,trajectoryx, vehicle, save_video)
           
        animation_articulatedVehicleTractor(obj,trajectoryx, vehicle, save_video)

        animation_articulatedVehicleTractorAndCost(obj, trajectoryx, cost, vehicle,save_video)
        
        corners_rectangle = orientedRectangle(obj,center, angle, L, W)
        
        xy = orientedRoundedRectangle(obj, center, angle, L, W, r, npointsEcke)
        
    end
end

