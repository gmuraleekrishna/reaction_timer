# 
# Synthesis run script generated by Vivado
# 

proc create_report { reportName command } {
  set status "."
  append status $reportName ".fail"
  if { [file exists $status] } {
    eval file delete [glob $status]
  }
  send_msg_id runtcl-4 info "Executing : $command"
  set retval [eval catch { $command } msg]
  if { $retval != 0 } {
    set fp [open $status w]
    close $fp
    send_msg_id runtcl-5 warning "$msg"
  }
}
set_param xicom.use_bs_reader 1
create_project -in_memory -part xc7a35tcpg236-1

set_param project.singleFileAddWarning.threshold 0
set_param project.compositeFile.enableAutoGeneration 0
set_param synth.vivado.isSynthRun true
set_property webtalk.parent_dir {E:/MEngg Materials/Sem 1/Digital Systems and Microprocessors ENGN 6213/Assignment_Reaction_Timer/ReactionTimer/ReactionTimer.cache/wt} [current_project]
set_property parent.project_path {E:/MEngg Materials/Sem 1/Digital Systems and Microprocessors ENGN 6213/Assignment_Reaction_Timer/ReactionTimer/ReactionTimer.xpr} [current_project]
set_property default_lib xil_defaultlib [current_project]
set_property target_language Verilog [current_project]
set_property ip_output_repo {e:/MEngg Materials/Sem 1/Digital Systems and Microprocessors ENGN 6213/Assignment_Reaction_Timer/ReactionTimer/ReactionTimer.cache/ip} [current_project]
set_property ip_cache_permissions {read write} [current_project]
read_verilog -library xil_defaultlib {
  {E:/MEngg Materials/Sem 1/Digital Systems and Microprocessors ENGN 6213/Assignment_Reaction_Timer/ReactionTimer/ReactionTimer.srcs/sources_1/new/clock_divider.v}
  {E:/MEngg Materials/Sem 1/Digital Systems and Microprocessors ENGN 6213/Assignment_Reaction_Timer/ReactionTimer/ReactionTimer.srcs/sources_1/new/counter.v}
  {E:/MEngg Materials/Sem 1/Digital Systems and Microprocessors ENGN 6213/Assignment_Reaction_Timer/ReactionTimer/ReactionTimer.srcs/sources_1/new/debouncer.v}
  {E:/MEngg Materials/Sem 1/Digital Systems and Microprocessors ENGN 6213/Assignment_Reaction_Timer/ReactionTimer/ReactionTimer.srcs/sources_1/new/display.v}
  {E:/MEngg Materials/Sem 1/Digital Systems and Microprocessors ENGN 6213/Assignment_Reaction_Timer/ReactionTimer/ReactionTimer.srcs/sources_1/new/edge_detector.v}
  {E:/MEngg Materials/Sem 1/Digital Systems and Microprocessors ENGN 6213/Assignment_Reaction_Timer/ReactionTimer/ReactionTimer.srcs/sources_1/new/multiple_seven_segment_display.v}
  {E:/MEngg Materials/Sem 1/Digital Systems and Microprocessors ENGN 6213/Assignment_Reaction_Timer/ReactionTimer/ReactionTimer.srcs/sources_1/new/seven_segment_decoder.v}
  {E:/MEngg Materials/Sem 1/Digital Systems and Microprocessors ENGN 6213/Assignment_Reaction_Timer/ReactionTimer/ReactionTimer.srcs/sources_1/new/reaction_timer_top.v}
}
# Mark all dcp files as not used in implementation to prevent them from being
# stitched into the results of this synthesis run. Any black boxes in the
# design are intentionally left as such for best results. Dcp files will be
# stitched into the design at a later time, either when this synthesis run is
# opened, or when it is stitched into a dependent implementation run.
foreach dcp [get_files -quiet -all -filter file_type=="Design\ Checkpoint"] {
  set_property used_in_implementation false $dcp
}
read_xdc {{E:/MEngg Materials/Sem 1/Digital Systems and Microprocessors ENGN 6213/Assignment_Reaction_Timer/ReactionTimer/ReactionTimer.srcs/constrs_1/new/reaction_timer_constraints.xdc}}
set_property used_in_implementation false [get_files {{E:/MEngg Materials/Sem 1/Digital Systems and Microprocessors ENGN 6213/Assignment_Reaction_Timer/ReactionTimer/ReactionTimer.srcs/constrs_1/new/reaction_timer_constraints.xdc}}]


synth_design -top reaction_timer_top -part xc7a35tcpg236-1


# disable binary constraint mode for synth run checkpoints
set_param constraints.enableBinaryConstraints false
write_checkpoint -force -noxdef reaction_timer_top.dcp
create_report "synth_1_synth_report_utilization_0" "report_utilization -file reaction_timer_top_utilization_synth.rpt -pb reaction_timer_top_utilization_synth.pb"
