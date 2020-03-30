gen_asic:
	#Move files needed over to server
	scp -r src/ EDA4:./async/


	ssh -C EDA4 "cd async && tcsh -c \"source /apps/misc/02205/scripts/setup_synopsys_dv.csh && dc_shell -f scripts/compile.tcl\" " > EDA4_log.txt
	#TO BE DONE: ssh -C EDA4 "cd master && tcsh -c \"source /apps/misc/02205/scripts/setup_icc.csh && icc_shell -shared_license 
