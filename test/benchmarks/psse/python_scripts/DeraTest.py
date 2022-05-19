import PSSEInterface
#reload(PSSEInterface)

powerflow_file='ThreeBusRenewable.raw'         
dynamic_data_file='WECC240_dynamics_UPV_v04_psid.dyr'         
print('\nInput Files ...')
print(powerflow_file)    
print(dynamic_data_file)

PSSEInterface.initialize_system(powerflow_file)
