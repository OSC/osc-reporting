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

    def app_cpus(bin_count = 5, job_name = 'ondemand/sys/dashboard/sys/bc_osc_jupyter')
      cpus_hash = Hash.new(0)
      Job.all.each do |job|
        next unless job.name == job_name && job.tres

        cpus_hash[job.tres.match(/cpu=(\d*)/).captures[0].to_i] += 1
      end
      bin_size = (cpus_hash.keys.max / bin_count).ceil
      graph_data = Array.new(bin_count, 0)
      cpus_hash.each do |cpus, freq|
        graph_data[((cpus - 1) / bin_size).floor] += freq
      end
      {
        'bin_size'   => bin_size,
        'graph_data' => graph_data
      }
    end

    def all_names
      Job.all.map(&:name).uniq
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
