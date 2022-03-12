# frozen_string_literal: true

require 'open3'

namespace :db do
  desc 'Ingest data from sacct'
  task ingest: :environment do
    fmt = Job.sacct_fields.join(',')
    since = "#{(DateTime.now - 5).strftime('%Y-%m-%d')}T00:00:00"
    args = ['-o', fmt, '-a', '-P', '-n', '-L', '-s', 'CD,F,TO,DL,NF']
    args.concat ['--starttime', since, '--endtime', 'now']
    o, e, s = Open3.capture3('sacct', *args)

    unless s.success?
      warn e
      raise StandardError, "sacct exited with #{s.exitstatus}"
    end

    puts "sacct command completed with length #{o.length}"

    jobs = o.split($/).map do |line|
      h = Job.sacct_to_hash(line)
      Job.new(h).valid? ? h : nil
    end.compact

    Job.upsert_all(jobs)
  end

  task one: :environment do
    puts Job.first.inspect
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