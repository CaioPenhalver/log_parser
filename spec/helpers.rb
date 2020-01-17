# frozen_string_literal: true

file = 'spec/fixtures/webserver.log'

def create_log_file(hash = {})
  File.open(file, 'w') do |f|
    hash.each { |o| f.write "#{o[:path]} #{o[:ip]}\n" }
  end
end

def delete_file
  return unless File.exist?(file)

  File.delete(file)
end
