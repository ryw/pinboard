module Pinboard
  module Util
    extend self

    def symbolize_keys(hash)
      hash.each_with_object({}) do |(key, value), options|
        options[(key.to_sym rescue key) || key] = value
      end
    end

    def parse_time(time)
      return time if time.is_a?(Time)
      return time.to_time if time.is_a?(Date)

      Time.parse(time)
    end
  end
end
