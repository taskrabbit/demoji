require "demoji/version"
require 'active_support/concern'
require 'active_support/core_ext/module/aliasing'

module Demoji

  extend ActiveSupport::Concern

  included do
    alias_method_chain :create_or_update, :utf8_rescue
  end

  private

    def create_or_update_with_utf8_rescue
      _rescued_counter ||= 0

      create_or_update_without_utf8_rescue
    rescue ActiveRecord::StatementInvalid => ex
      raise ex unless ex.message.match /Mysql2::Error: Incorrect string value:/

      _rescued_counter += 1

      raise ex if _rescued_counter > 1

      _fix_utf8_attributes
      retry
    end

    def _fix_utf8_attributes
      self.attributes.each do |k, v|
        next if v.blank? || !v.is_a?(String)
        self.send "#{k}=", _fix_chars(v)
      end
    end

    def _fix_chars(str)
      "".tap do |out_str|

        # for instead of split and joins for perf
        for i in (0...str.length)
          char = str[i]
          char = 32.chr if char.ord >= 10000
          out_str << char
        end

      end
    end

  # /private

end
