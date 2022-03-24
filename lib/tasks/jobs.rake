# frozen_string_literal: true

require 'open3'

#Hi
namespace :jobs do
  

  task one: :environment do
    puts ActiveJobs.all.first.inspect
  end

end

# Account             AdminComment        AllocCPUS           AllocNodes         
# AllocTRES           AssocID             AveCPU              AveCPUFreq         
# AveDiskRead         AveDiskWrite        AvePages            AveRSS             
# AveVMSize           BlockID             Cluster             Comment            
# Constraints         Container           ConsumedEnergy      ConsumedEnergyRaw  
# CPUTime             CPUTimeRAW          DBIndex             DerivedExitCode    
# Elapsed             ElapsedRaw          Eligible            End                
# ExitCode            Flags               GID                 Group              
# JobID               JobIDRaw            JobName             Layout             
# MaxDiskRead         MaxDiskReadNode     MaxDiskReadTask     MaxDiskWrite       
# MaxDiskWriteNode    MaxDiskWriteTask    MaxPages            MaxPagesNode       
# MaxPagesTask        MaxRSS              MaxRSSNode          MaxRSSTask         
# MaxVMSize           MaxVMSizeNode       MaxVMSizeTask       McsLabel           
# MinCPU              MinCPUNode          MinCPUTask          NCPUS              
# NNodes              NodeList            NTasks              Priority           
# Partition           QOS                 QOSRAW              Reason             
# ReqCPUFreq          ReqCPUFreqMin       ReqCPUFreqMax       ReqCPUFreqGov      
# ReqCPUS             ReqMem              ReqNodes            ReqTRES            
# Reservation         ReservationId       Reserved            ResvCPU            
# ResvCPURAW          Start               State               Submit             
# SubmitLine          Suspended           SystemCPU           SystemComment      
# Timelimit           TimelimitRaw        TotalCPU            TRESUsageInAve     
# TRESUsageInMax      TRESUsageInMaxNode  TRESUsageInMaxTask  TRESUsageInMin     
# TRESUsageInMinNode  TRESUsageInMinTask  TRESUsageInTot      TRESUsageOutAve    
# TRESUsageOutMax     TRESUsageOutMaxNode TRESUsageOutMaxTask TRESUsageOutMin    
# TRESUsageOutMinNode TRESUsageOutMinTask TRESUsageOutTot     UID                
# User                UserCPU             WCKey               WCKeyID            
# WorkDir            