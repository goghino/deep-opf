import pandapower as pp
import pandapower.networks as pn
import numpy as np

# https://pandapower.readthedocs.io/en/v2.9.0/networks/power_system_test_cases.html
#net = pn.case1354pegase()
net = pn.case89pegase()

# https://github.com/e2nIEE/pandapower/blob/develop/tutorials/opf_basic.ipynb 
# pandapower/pandapower/run.py runopp or rundcopp
# pandapower/pandapower/optimal_powerflow.py 
#pp.runopp(net, verbose=True, delta=1e-10)
pp.rundcopp(net, verbose=True, delta=1e-10)

print(f'{net.res_cost = }')
print(f'{net.res_bus = }')
print(f'{net.res_gen = }')
