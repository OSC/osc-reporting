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
