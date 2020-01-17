# frozen_string_literal: true

# Strategy to print metrics for the file webserver.log
module LogParser
  module Strategies
    class WebserverLog
      attr_accessor :lines

      LINE_MATCHER = { path: /^\S*/, ip: /\S*$/ }.freeze

      def initialize(lines = nil)
        @lines = lines
      end

      def print_metrics
        puts 'List of webpages with most page views'
        print_format most_page_views(lines)
        puts '-------------------------------------------'
        puts 'List of webpages with most unique page views'
        print_format unique_most_page_views(lines)
      end

      def most_page_views(lines)
        lines_grouped = group_by_path(lines)
        page_count = page_count_views(lines_grouped)
        sort_by_views_desc(page_count)
      end

      def unique_most_page_views(lines)
        unique_views = unique_views(lines)
        most_page_views(unique_views)
      end

      private

      def group_by_path(log_lines)
        log_lines.group_by { |hash| hash[:path] }
      end

      def page_count_views(views_line)
        views_line.each_with_object([]) do |(page, views), metrics|
          metrics << { number: views.count, page: page }
        end
      end

      def sort_by_views_desc(page_views)
        page_views.sort { |pv1, pv2| pv2[:number] <=> pv1[:number] }
      end

      def unique_views(log_lines)
        log_lines.uniq { |line| line[:ip] }
      end

      def print_format(lines)
        lines.each { |line| puts "#{line[:page]}: #{line[:number]}" }
        nil
      end
    end
  end
end
