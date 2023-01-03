# frozen_string_literal: true

class Job < ApplicationRecord
  SACCT_TO_FIELDS = {
    'Account'   => :account,
    'JobId'     => :id,
    'Elapsed'   => :elapsed,
    'JobName'   => :name,
    'Cluster'   => :cluster,
    'AllocTRES' => :tres
  }.freeze

  NAME_REX = %r{ondemand/(usr|dev|sys)/(?<app>\w+)/(?<type>usr|dev|sys)*/*(?<name>[\w_/]+)}.freeze

  validates :name, format: { with: NAME_REX }
  validates :id, format: { with: /\d+/ }

  class << self
    def sacct_fields
      SACCT_TO_FIELDS.map { |k, _v| k.to_s }
    end

    def sacct_to_hash(line)
      headers = SACCT_TO_FIELDS.map { |_k, v| v }
      Hash[headers.zip(line.chomp.split('|'))]
    end

    def all_by_usage
      @all_by_usage ||= Hash.new do |hash, key|
        hash[key] = 0
      end.tap do |hash|
        Job.all.each do |job|
          hash[job.simple_name] = hash[job.simple_name] + 1
        end
      end.sort_by do |_k, v|
        -v
      end
    end

    def usage_w_percentage(jobs)
      total = jobs.first[1].to_f
      Rails.logger.info("total is  #{total}")

      jobs.map do |name, count|
        # Rails.logger.info("formatting #{count} for #{name}")
        num = pct_format(count / total)
        { name: name, count: count, pct: num }
      end
    end

    def pct_format(number)
      # Rails.logger.info("formatting #{number} to #{(number * 100).to_i}")
      (number * 100).to_i
    end

    def app_inspect(bin_count = 5, job_name = 'ondemand/sys/dashboard/sys/bc_osc_jupyter', cluster = '_all', property = 'CPUs')
      property_hash = Hash.new(0)
      match_str = property == 'GPUs' ? /gpu:[^,]*(\d+)/ : /cpu=(\d*)/
      Job.all.each do |job|
        next unless job.name == job_name && job.tres && (cluster == '_all' || job.cluster == cluster)

        property_hash[job.tres.scan(match_str).flatten.map(&:to_i).sum] += 1
      end
      max_property = property_hash.keys.max + 1
      # When slider is all the way to the right, use a bin_size of 1 and set bin_count to max
      if bin_count == 21
        bin_size = 1
        bin_count = property_hash.keys.max + 1
      else
        bin_size = (max_property.to_f / bin_count).ceil
      end
      graph_data = Array.new(bin_count, 0)
      property_hash.each do |val, freq|
        graph_data[(val / bin_size).floor] += freq
      end
      {
        'bin_size'   => bin_size,
        'graph_data' => graph_data
      }
    end

    def all_app_names
      Job.all.map(&:name).uniq
    end

    def all_cluster_names
      Job.all.map(&:cluster).uniq
    end
  end

  def simple_name
    %r{ondemand/(usr|dev|sys)/(?<app>\w+)/(?<type>usr|dev|sys)*/*(?<name>[\w_/]+)}.match(name) do |m|
      if m[:type]
        "#{m[:type]}/#{m[:name]}"
      else
        # name is like: ondemand/sys/myjobs/basic_python_serial
        # app is then - myjobs
        m[:app]
      end
    end
  end
end
