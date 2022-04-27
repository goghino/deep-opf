% Setup the paths
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% % path to the Matpower library (update to reflect the location at your system)
% addpath( ...
%     '/Users/Juraj/Documents/DXT/matpower/lib', ...
%     '/Users/Juraj/Documents/DXT/matpower/lib/t', ...
%     '/Users/Juraj/Documents/DXT/matpower/data', ...
%     '/Users/Juraj/Documents/DXT/matpower/most/lib', ...
%     '/Users/Juraj/Documents/DXT/matpower/most/lib/t', ...
%     '/Users/Juraj/Documents/DXT/matpower/mp-opt-model/lib', ...
%     '/Users/Juraj/Documents/DXT/matpower/mp-opt-model/lib/t', ...
%     '/Users/Juraj/Documents/DXT/matpower/mips/lib', ...
%     '/Users/Juraj/Documents/DXT/matpower/mips/lib/t', ...
%     '/Users/Juraj/Documents/DXT/matpower/mptest/lib', ...
%     '/Users/Juraj/Documents/DXT/matpower/mptest/lib/t', ...
%     '-end' );
% addpath('/Users/Juraj/Libraries/mosek/9.2/toolbox/r2015a');

addpath( ...
    '/Users/julianprokofiev/Documents/USI/Semester8/matpower7.1/lib', ...
    '/Users/julianprokofiev/Documents/USI/Semester8/matpower7.1/lib/t', ...
    '/Users/julianprokofiev/Documents/USI/Semester8/matpower7.1/data', ...
    '/Users/julianprokofiev/Documents/USI/Semester8/matpower7.1/most/lib', ...
    '/Users/julianprokofiev/Documents/USI/Semester8/matpower7.1/most/lib/t', ...
    '/Users/julianprokofiev/Documents/USI/Semester8/matpower7.1/mp-opt-model/lib', ...
    '/Users/julianprokofiev/Documents/USI/Semester8/matpower7.1/mp-opt-model/lib/t', ...
    '/Users/julianprokofiev/Documents/USI/Semester8/matpower7.1/mips/lib', ...
    '/Users/julianprokofiev/Documents/USI/Semester8/matpower7.1/mips/lib/t', ...
    '/Users/julianprokofiev/Documents/USI/Semester8/matpower7.1/mptest/lib', ...
    '/Users/julianprokofiev/Documents/USI/Semester8/matpower7.1/mptest/lib/t', ...
    '-end' );
addpath('/Users/julianprokofiev/Documents/USI/Semester8/mosek/9.3/toolbox/r2015a');


constants;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%% load the Matpower case and create Matpower options
mpc        = case30;

OPFvoltage = POLAR;           % voltage representation
OPFbalance = POWER;           % type of nodal balance equation
OPFstart   = MPC;             % initial guess
OPFsolver  = MOSEK;           % solver
OPFmodel   = DC;              % grid model

mpopt      = create_options(mpc, OPFsolver, OPFstart, OPFvoltage, OPFbalance, OPFmodel);

rand('seed',1);               % for same random #'s each time

%% Running OPF

% upper/lower bounds, etc
global_low = -30;
global_high = 30;
global_incr = 3;

local_low = -25;
local_high = 25;
local_incr = 10;

% iterations per global*local combo
itr = 2;

for i = global_low:global_incr:global_high                % in %... 61 points
    % Get the global scaling
    scale_global = i;                                     

    % Get the perturbations of the global scaling
    nLoads = size(mpc.bus, 1);

    for j = local_low:local_incr:local_high               % in %... 51 points
        
         for k = 1:itr                                    % 5 iterations per                                
                                                          
            % Corresponds to +/- j% of original values
            % returns x in 1 + Uniform(-1,1)
            if j == 0
                scale_local = 1 + (2*rand(nLoads,1)-1);
                
            else 
                scale_local = 1 + (j/100)*(2*rand(nLoads,1)-1);
            end

            % Combining global scaling + variability
            if i == 0
                scale = 1 + (scale_local)/100;      
            else
                scale = 1 + (scale_global * scale_local)/100;
            end

            % Perturb each load
            mpc.bus(:,PD) = scale.*mpc.bus(:,PD);

            % Run the OPF
            r = runopf(mpc, mpopt);


            % Extract the QoI
            prices = r.bus(:, LAM_P);
            genpower = r.gen(:, PG);

            prices = prices';               % make each vector row
            genpower = genpower';

            % total of 15555 data points
            writematrix(prices,'Thesis/github/Untitled/data/csv/case30prices.csv','WriteMode','append');
            writematrix(prices,'Thesis/github/Untitled/data/csv/case30genpowers.csv','WriteMode','append');
        end
    end
end


%% OLD testing
% % Perturb the load
% mpc.bus(:,PD) = 1.01*mpc.bus(:,PD);
% 
% % Run the OPF
% r = runopf(mpc, mpopt);
% 
% % Extract the QoI
% prices = r.bus(:, LAM_P);
% genpower = r.gen(:, PG);