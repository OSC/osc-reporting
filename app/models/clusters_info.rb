# frozen_string_literal: true

class ClustersInfo
    ALL_LOCK = Mutex.new
  
    class << self
      def clusters
        Rails.cache.fetch('clusters', expires_in: 12.hours) do
          OodCore::Clusters.new(
            OodCore::Clusters.load_file(Configuration.clusters_config_dir).reject do |c|
              !c.errors.empty? || !c.allow? || c.kubernetes? || c.linux_host?
            end
          )
        end
      rescue OodCore::ConfigurationNotFound
        OodCore::Clusters.new([])
      end
  
      def all
        Rails.logger.debug("ActiveJobs.all being called at at #{Time.now}")
        ALL_LOCK.synchronize do
          Rails.cache.fetch('all_jobs', expires_in: 50.seconds) do
            Rails.logger.debug("ActiveJobs fetching new jobs at #{Time.now}")
  
            clusters.map do |c|
              {
                'cluster_name' => c.id,
                'info'         => c.job_adapter.cluster_info.to_h
              }
            end
          end
        end
      end
  
      def cluster_info(cluster_id)
        OodCore::Cluster.new({ id: cluster_id, job: { adapter: 'slurm' } }).job_adapter.cluster_info.to_h
        # ActiveJobs.all.select { |info| info['cluster_name'] == cluster_id }.first
      end
    end
  end
  