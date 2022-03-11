require "date"

module Parsel
  class Parsel
    SUPPORTED_TOKEN_TYPES = %i[WORD CHANNEL INTEGER TEXT DATETIME]

    # Tokenizer methods
    # Split the first whitespace-separated chunk from a string
    # @param argument_string
    # @return [token, remainderOfString]
    def self.parse_word(argument_string)
      argument_string.split(/\s+/, 2)
    end

    # Parse a channel name from the beginning of a string
    # @param argument_string A string beginning with a #channel identifier and whitespace
    # @return [#channelIdentifier, remainderOfString]
    # @raise When a valid channel identifier is not found
    def self.parse_channel(argument_string)
      channel, argument_string = parse_word(argument_string)
      raise "Invalid channel '#{channel}'" unless (match = channel.match((/^#([^\s]+)/)))

      [match[1], argument_string]
    end

    # Parse an integer from the beginning of a string
    # @param argument_string A string beginning with an integer
    # @return [parsedInteger, remainderOfString]
    # @raise ArgumentError When integer parsing fails
    def self.parse_integer(argument_string)
      integer_string, argument_string = parse_word(argument_string)
      [Integer(integer_string), argument_string]
    end

    # Parse all remaining text from a string
    # @param argument_string
    # @return [argumentString, nil]
    def self.parse_text(argument_string)
      raise "End of input reached" unless argument_string && !argument_string.empty?

      [argument_string, nil]
    end

    # Parse a datetime from the beginning of a string
    # @param argument_string A string beginning with an RFC-3339 datetime parseable by DateTime.parse
    # @return [parsedDateTime, remainderOfString]
    # @raise ArgumentError When DateTime parsing fails
    def self.parse_datetime(argument_string)
      datetime_string, argument_string = parse_word(argument_string)
      [DateTime.parse(datetime_string), argument_string]
    end

    # Get the appropriate method for parsing a parameter type
    # @param type_symbol A type symbol, e.g. INTEGER
    # @return The parser method for the type symbol, e.g. parse_integer
    def self.get_parser_method_for(type_symbol)
      method("parse_#{type_symbol.to_s.downcase}".to_sym)
    end

    # Parse typed arguments from a string
    # @param parameter_list A list of argument type parameters (i.e. COMMANDS)
    # @param argument_string The string to parse
    # @return Parsed token list or nil
    def self.parse_arguments(parameter_list, argument_string)
      return nil unless parameter_list

      tokens = parameter_list.inject([]) do |tokens, parameter|
        token, argument_string = get_parser_method_for(parameter).call(argument_string)
        return nil unless token
        tokens << token
      end
      argument_string && !argument_string.strip.empty? ? nil : tokens
    rescue
      nil
    end
  end
end
