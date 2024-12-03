require "debug"
require_relative "../helpers"

module Day3
  class Matcher
    attr_reader :match

    def initialize(string, type, regex)
      @search = string.dup
      @regex = regex
      @type = type
      @offset = 0

      next_match
    end

    def next_match
      return if @search.nil?

      @match = @search.match(regex, @offset)

      @offset = @match.nil? ? nil : @match.offset(0)[1]
    end

    def position
      @match&.begin(0)
    end

    def complete?
      @match.nil?
    end

    def do?
      type == :do
    end

    def dont?
      type == :dont
    end

    private

    attr_reader :regex, :type
  end

  class Solver
    def initialize(file)
      @lines = File.readlines(file, chomp: true).join
      @mul_search = Matcher.new(@lines, :mul, /mul\((\d{1,3}),(\d{1,3})\)/)
      @do_search = Matcher.new(@lines, :do, /do\(\)/)
      @dont_search = Matcher.new(@lines, :dont, /don't\(\)/)
      @enabled = true
    end

    def solve
      matches = find_matches
      matches.sum { |m| m[1].to_i * m[2].to_i }
    end

    def find_matches
      matches = []

      loop do
        matcher = next_matcher
        break if matcher.nil?

        if matcher.do?
          puts "ENABLED #{matcher.match} @ #{matcher.position}"
          @enabled = true
        elsif matcher.dont?
          puts "DISABLED #{matcher.match} @ #{matcher.position}"
          @enabled = false
        elsif @enabled
          puts "ADDED #{matcher.match} @ #{matcher.position}"
          matches << matcher.match
        else
          puts "IGNORED #{matcher.match} @ #{matcher.position}"
        end

        matcher.next_match
      end

      matches
    end

    def next_matcher
      matchers = []
      matchers << @mul_search unless @mul_search.complete?
      matchers << @do_search unless @do_search.complete?
      matchers << @dont_search unless @dont_search.complete?

      matchers.sort { |a, b| a.position <=> b.position }.first if matchers.any?
    end
  end
end
