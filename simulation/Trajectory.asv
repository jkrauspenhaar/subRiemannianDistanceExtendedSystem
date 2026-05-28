classdef Trajectory
    properties (SetAccess = protected)
        dT
        t0
        data
        names
        title
    end

    methods
        function obj = Trajectory(dT, data, names, title, t0)
            if nargin < 5
                t0 = 0;
            end

            obj.dT = dT;
            obj.data = data;
            obj.names = names;
            obj.title = title;
            obj.t0 = t0;
        end


        function t = getTime(obj, k)
            t = obj.t0 + (k-1)*obj.dT;
        end

        function T = timeGrid(obj)
            T = obj.t0 + (0:obj.length()-1)'*obj.dT;
        end

        function N = length(obj)
            N = size(obj.data,1);
        end

        function n = dimension(obj)
            n = size(obj.data,2);
        end

        function saveTable(obj,skip, store_git_info)
            saveData.time = obj.timeGrid();
            for j = 1:length(obj.names)
                saveData.(obj.names(j)) = obj.data(:,j);
            end

            if store_git_info == false
                warning('no git info stored')
                data2pgftable(strcat('results/Trajectory','_',join(obj.title,"_"),'.txt'), saveData,'skip',skip);
            else
                [~, git_hash] = system('git rev-parse --short HEAD');
                git_hash = strtrim(git_hash);
                data2pgftable(strcat('results/Trajectory','_',join(obj.title,"_"),'.txt'), saveData, 'git_hash',git_hash,'skip',skip);
            end
        end
    end
end