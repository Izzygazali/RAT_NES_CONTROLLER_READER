# 
# Synthesis run script generated by Vivado
# 

set_param xicom.use_bs_reader 1
set_msg_config -id {HDL 9-1061} -limit 100000
set_msg_config -id {HDL 9-1654} -limit 100000
set_msg_config  -ruleid {1}  -id {Project 1-19}  -suppress 
create_project -in_memory -part xc7a35tcpg236-1

set_param project.singleFileAddWarning.threshold 0
set_param project.compositeFile.enableAutoGeneration 0
set_param synth.vivado.isSynthRun true
set_property webtalk.parent_dir C:/Users/Starr/Desktop/FINAL_PROJECT_CPE_233_WINTER_2017_STARR_GAZALI/RATPUTER/RATPUTER.cache/wt [current_project]
set_property parent.project_path C:/Users/Starr/Desktop/FINAL_PROJECT_CPE_233_WINTER_2017_STARR_GAZALI/RATPUTER/RATPUTER.xpr [current_project]
set_property default_lib xil_defaultlib [current_project]
set_property target_language VHDL [current_project]
read_vhdl -library xil_defaultlib {
  C:/Users/Starr/Desktop/FINAL_PROJECT_CPE_233_WINTER_2017_STARR_GAZALI/RATPUTER/RATPUTER.srcs/sources_1/imports/new/VGAdrive.vhd
  C:/Users/Starr/Desktop/FINAL_PROJECT_CPE_233_WINTER_2017_STARR_GAZALI/RATPUTER/RATPUTER.srcs/sources_1/imports/new/ram2k_8.vhd
  C:/Users/Starr/Desktop/FINAL_PROJECT_CPE_233_WINTER_2017_STARR_GAZALI/RATPUTER/RATPUTER.srcs/sources_1/imports/new/vga_clk_div.vhd
  C:/Users/Starr/Desktop/FINAL_PROJECT_CPE_233_WINTER_2017_STARR_GAZALI/RATPUTER/RATPUTER.srcs/sources_1/new/BIN_TO_BCD.vhd
  C:/Users/Starr/Desktop/FINAL_PROJECT_CPE_233_WINTER_2017_STARR_GAZALI/RATPUTER/RATPUTER.srcs/sources_1/new/SCR_DATA_MUX.vhd
  C:/Users/Starr/Desktop/FINAL_PROJECT_CPE_233_WINTER_2017_STARR_GAZALI/RATPUTER/RATPUTER.srcs/sources_1/new/SCR_ADDR_MUX.vhd
  C:/Users/Starr/Desktop/FINAL_PROJECT_CPE_233_WINTER_2017_STARR_GAZALI/RATPUTER/RATPUTER.srcs/sources_1/new/RF_MUX.vhd
  C:/Users/Starr/Desktop/FINAL_PROJECT_CPE_233_WINTER_2017_STARR_GAZALI/RATPUTER/RATPUTER.srcs/sources_1/new/I.vhd
  C:/Users/Starr/Desktop/FINAL_PROJECT_CPE_233_WINTER_2017_STARR_GAZALI/RATPUTER/RATPUTER.srcs/sources_1/new/ALU_MUX.vhd
  C:/Users/Starr/Desktop/FINAL_PROJECT_CPE_233_WINTER_2017_STARR_GAZALI/RATPUTER/RATPUTER.srcs/sources_1/imports/new/clock_div2.vhd
  C:/Users/Starr/Desktop/FINAL_PROJECT_CPE_233_WINTER_2017_STARR_GAZALI/RATPUTER/RATPUTER.srcs/sources_1/imports/new/vgaDriverBuffer.vhd
  C:/Users/Starr/Desktop/FINAL_PROJECT_CPE_233_WINTER_2017_STARR_GAZALI/RATPUTER/RATPUTER.srcs/sources_1/imports/new/PC_MUX.vhd
  C:/Users/Starr/Desktop/FINAL_PROJECT_CPE_233_WINTER_2017_STARR_GAZALI/RATPUTER/RATPUTER.srcs/sources_1/imports/new/SP.vhd
  C:/Users/Starr/Desktop/FINAL_PROJECT_CPE_233_WINTER_2017_STARR_GAZALI/RATPUTER/RATPUTER.srcs/sources_1/imports/new/FLAGS.vhd
  C:/Users/Starr/Desktop/FINAL_PROJECT_CPE_233_WINTER_2017_STARR_GAZALI/RATPUTER/RATPUTER.srcs/sources_1/imports/new/SCR.vhd
  C:/Users/Starr/Desktop/FINAL_PROJECT_CPE_233_WINTER_2017_STARR_GAZALI/RATPUTER/RATPUTER.srcs/sources_1/imports/new/ALU.vhd
  C:/Users/Starr/Desktop/FINAL_PROJECT_CPE_233_WINTER_2017_STARR_GAZALI/RATPUTER/RATPUTER.srcs/sources_1/imports/new/CONTROL_UNIT.vhd
  C:/Users/Starr/Desktop/FINAL_PROJECT_CPE_233_WINTER_2017_STARR_GAZALI/RATPUTER/RATPUTER.srcs/sources_1/imports/new/PC.vhd
  C:/Users/Starr/Desktop/FINAL_PROJECT_CPE_233_WINTER_2017_STARR_GAZALI/RATPUTER/RATPUTER.srcs/sources_1/imports/new/REG_FILE.vhd
  C:/Users/Starr/Desktop/FINAL_PROJECT_CPE_233_WINTER_2017_STARR_GAZALI/Assembly/prog_rom/prog_rom.vhd
  C:/Users/Starr/Desktop/FINAL_PROJECT_CPE_233_WINTER_2017_STARR_GAZALI/RATPUTER/RATPUTER.srcs/sources_1/new/RAND_NUMBER.vhd
  C:/Users/Starr/Desktop/FINAL_PROJECT_CPE_233_WINTER_2017_STARR_GAZALI/RATPUTER/RATPUTER.srcs/sources_1/new/TIMER.vhd
  C:/Users/Starr/Desktop/FINAL_PROJECT_CPE_233_WINTER_2017_STARR_GAZALI/RATPUTER/RATPUTER.srcs/sources_1/new/RAT_MCU.vhd
  C:/Users/Starr/Desktop/FINAL_PROJECT_CPE_233_WINTER_2017_STARR_GAZALI/RATPUTER/RATPUTER.srcs/sources_1/imports/new/SEVEN_SEG_DRIVER.vhd
  C:/Users/Starr/Desktop/FINAL_PROJECT_CPE_233_WINTER_2017_STARR_GAZALI/RATPUTER/RATPUTER.srcs/sources_1/imports/new/NES_CONTROLLER_READER.vhd
  C:/Users/Starr/Desktop/FINAL_PROJECT_CPE_233_WINTER_2017_STARR_GAZALI/RATPUTER/RATPUTER.srcs/sources_1/imports/new/UART_TX_CTRL.vhd
  C:/Users/Starr/Desktop/FINAL_PROJECT_CPE_233_WINTER_2017_STARR_GAZALI/RATPUTER/RATPUTER.srcs/sources_1/imports/new/INT_HANDLER.vhd
  C:/Users/Starr/Desktop/FINAL_PROJECT_CPE_233_WINTER_2017_STARR_GAZALI/RATPUTER/RATPUTER.srcs/sources_1/imports/new/static_VGA_wrapper.vhd
  C:/Users/Starr/Desktop/FINAL_PROJECT_CPE_233_WINTER_2017_STARR_GAZALI/RATPUTER/RATPUTER.srcs/sources_1/new/RAT_WRAPPER.vhd
}
foreach dcp [get_files -quiet -all *.dcp] {
  set_property used_in_implementation false $dcp
}
read_xdc C:/Users/Starr/Desktop/FINAL_PROJECT_CPE_233_WINTER_2017_STARR_GAZALI/RATPUTER/RATPUTER.srcs/constrs_1/new/constraint.xdc
set_property used_in_implementation false [get_files C:/Users/Starr/Desktop/FINAL_PROJECT_CPE_233_WINTER_2017_STARR_GAZALI/RATPUTER/RATPUTER.srcs/constrs_1/new/constraint.xdc]


synth_design -top RAT_wrapper -part xc7a35tcpg236-1


write_checkpoint -force -noxdef RAT_wrapper.dcp

catch { report_utilization -file RAT_wrapper_utilization_synth.rpt -pb RAT_wrapper_utilization_synth.pb }