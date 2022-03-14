# frozen_string_literal: true

class ActiveJobs
  class << self
    def clusters
      Rails.cache.fetch('clusters', expires_in: 12.hours) do
        OodCore::Clusters.load_file('/etc/ood/config/clusters.d/').reject do |c|
          !c.errors.empty? || !c.allow? || c.kubernetes? || c.linux_host?
        end
      end
    end

    def all
      Rails.cache.fetch('clusters', expires_in: 30.minutes) do
        clusters.map do |c|
          {
            'cluster' => c.id,
            'jobs'    => c.job_adapter.info_all
          }
        end
      end
    end
  end
end
