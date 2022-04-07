import pypower as pp

from pypower.api import \
    ppver, ppoption, runpf, runopf, runuopf, runopf_w_res

from pypower.api import \
    case4gs, case6ww, case9, case9Q, case14, case24_ieee_rts, case30, \
    case30Q, case30pwl, case39, case57, case118, case300, t_case30_userfcns    

# PYPOWER/pypower/dcopf.py 
# PYPOWER/pypower/dcopf_solver.py 


ppopt = ppoption(VERBOSE=True, PF_DC=True)

net = case118()

result = runopf(net, ppopt)

result
