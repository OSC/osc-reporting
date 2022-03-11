class Job < ApplicationRecord

  SACCT_TO_FIELDS = {
    'Account' => :account,
    'JobId' => :id,
    'Elapsed' => :elapsed,
    'JobName' => :name,
    'Cluster' => :cluster,
    'AllocTRES' => :tres
  }.freeze

  class << self
    def sacct_fields
      SACCT_TO_FIELDS.map { |k, _v| k.to_s }
    end

    def to_h_from_sacct(line)
      headers = SACCT_TO_FIELDS.map { |_k, v| v }
      Hash[headers.zip(line.chomp.split('|'))]
    end
  end
end
