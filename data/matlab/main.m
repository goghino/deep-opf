% Setup the paths
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% path to the Matpower library (update to reflect the location at your system)
addpath( ...
    '/Users/Juraj/Documents/DXT/matpower/lib', ...
    '/Users/Juraj/Documents/DXT/matpower/lib/t', ...
    '/Users/Juraj/Documents/DXT/matpower/data', ...
    '/Users/Juraj/Documents/DXT/matpower/most/lib', ...
    '/Users/Juraj/Documents/DXT/matpower/most/lib/t', ...
    '/Users/Juraj/Documents/DXT/matpower/mp-opt-model/lib', ...
    '/Users/Juraj/Documents/DXT/matpower/mp-opt-model/lib/t', ...
    '/Users/Juraj/Documents/DXT/matpower/mips/lib', ...
    '/Users/Juraj/Documents/DXT/matpower/mips/lib/t', ...
    '/Users/Juraj/Documents/DXT/matpower/mptest/lib', ...
    '/Users/Juraj/Documents/DXT/matpower/mptest/lib/t', ...
    '-end' );
addpath('/Users/Juraj/Libraries/mosek/9.2/toolbox/r2015a');

constants;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%% load the Matpower case and create Matpower options
mpc        = case30; %case_ACTIVSg200;

assert(all(mpc.branch(:,RATE_A) > 0)) % make sure all the line limits are defined
% to fill the missing values use e.g. mpc.branch(missing,RATE_A) = max(mpc.branch(missing,RATE_A)); 
% to run ED set mpc.branch(:,RATE_A)=0, then all LMP are equal

OPFvoltage = POLAR;           % voltage representation
OPFbalance = POWER;           % type of nodal balance equation
OPFstart   = MPC;             % initial guess
OPFsolver  = MOSEK;           % solver
OPFmodel   = DC;              % grid model

mpopt      = create_options(mpc, OPFsolver, OPFstart, OPFvoltage, OPFbalance, OPFmodel);

rand('seed',1);               % 

%% 
% Get the global scaling
scale_global = 30; % i.e. 30%

% Get the perturbations of the global scaling
nLoads = size(mpc.bus, 1);
scale_local = 1 + (2*rand(nLoads,1)-1)/10;  % returns x in 1 + Uniform(-1,1)/10

scale = 1 + (scale_global * scale_local)/100;

% Perturb each load
mpc.bus(:,PD) = scale.*mpc.bus(:,PD);

% Run the OPF
r = runopf(mpc, mpopt);

%% Inspect the results
%case_info(r);
printpf(r)

% Extract the QoI
prices = r.bus(:, LAM_P);

% (features, output)
sample = [mpc.bus(:,PD) prices];