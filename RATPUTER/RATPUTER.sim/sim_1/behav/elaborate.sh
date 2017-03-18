#!/bin/bash -f
xv_path="/opt/Xilinx/Vivado/2016.2"
ExecStep()
{
"$@"
RETVAL=$?
if [ $RETVAL -ne 0 ]
then
exit $RETVAL
fi
}
ExecStep $xv_path/bin/xelab -wto c3106da8b345465d901653c82ccfedb0 -m64 --debug typical --relax --mt 8 -L xil_defaultlib -L secureip --snapshot sim_behav xil_defaultlib.sim -log elaborate.log
