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
mpc        = case118;

OPFvoltage = POLAR;           % voltage representation
OPFbalance = POWER;           % type of nodal balance equation
OPFstart   = MPC;             % initial guess
OPFsolver  = MOSEK;           % solver
OPFmodel   = DC;              % grid model

mpopt      = create_options(mpc, OPFsolver, OPFstart, OPFvoltage, OPFbalance, OPFmodel);

% Perturb the load
mpc.bus(:,PD) = 1.01*mpc.bus(:,PD);

% Run the OPF
r = runopf(mpc, mpopt);

% Extract the QoI
prices = r.bus(:, LAM_P);
genpower = r.gen(:, PG);