# frozen_string_literal: true

module Parser
  class Engine
    class ParsedFile
      attr_accessor :tasks,
        :annotations,
        :meeting_annotations,
        :meetings,
        :interruptions,
        :difficulties,
        :pomodoros,
        :point
    end

    def initialize()
      @parsed_files = []
      @frozen = false
    end

    def add_file(file)
      raise "Parser::Engine is frozen" if @frozen

      file_data = File.read(file)

      if file_data.start_with?("# ")
        @parsed_files.push(parse_file_data(file_data))
      end
    rescue Errno::ENOENT
    end

    def done_tasks
      raise "Parser::Engine is not frozen" unless @frozen

      @done_tasks ||=
        tasks.filter { |t| t.start_with?("[x]") || t.start_with?("[X]") }
    end

    def tasks
      raise "Parser::Engine is not frozen" unless @frozen
      @tasks ||= @parsed_files.map { |f| f.tasks }.flatten
    end

    def annotations
      raise "Parser::Engine is not frozen" unless @frozen
      @annotations ||= @parsed_files.map { |f| f.annotations }.flatten
    end

    def meeting_annotations
      raise "Parser::Engine is not frozen" unless @frozen
      @meeting_annotations ||= @parsed_files.map { |f| f.meeting_annotations }.flatten
    end

    def meetings
      raise "Parser::Engine is not frozen" unless @frozen
      @meetings ||= @parsed_files.map { |f| f.meetings }.flatten
    end

    def interruptions
      raise "Parser::Engine is not frozen" unless @frozen
      @interruptions ||= @parsed_files.map { |f| f.interruptions }.flatten
    end

    def difficulties
      raise "Parser::Engine is not frozen" unless @frozen
      @difficulties ||= @parsed_files.map { |f| f.difficulties }.flatten
    end

    def pomodoros
      raise "Parser::Engine is not frozen" unless @frozen

      @pomodoros ||=
        @parsed_files.reduce(0) { |sum, f| sum + f.pomodoros }
    end

    def point
      raise "Parser::Engine is not frozen" unless @frozen
      @point ||= @parsed_files.map { |f| f.point }.flatten
    end

    def freeze
      @frozen = true
    end

    private

    def parse_file_data(content)
      parsed_file = ParsedFile.new

      splitted_content = content.split("### ")

      parsed_file.tasks =
        clear_list(splitted_content[1].split(":\n\n")[1].split("- "))
      parsed_file.meetings =
        clear_list(splitted_content[2].split(":\n\n")[1].split("- "))
      parsed_file.annotations =
        clear_list(splitted_content[3].split(":\n\n")[1])
      parsed_file.meeting_annotations =
        clear_list(splitted_content[4].split(":\n\n")[1].split("- "))
      parsed_file.interruptions =
        clear_list(splitted_content[5].split(":\n\n")[1].split("- "))
      parsed_file.difficulties =
        clear_list(splitted_content[6].split(":\n\n")[1].split("- "))
      parsed_file.pomodoros =
        splitted_content[7].split(":\n\n")[1].scan(/\d+/).first.to_i
      parsed_file.point =
        clear_list(splitted_content[8].split(":\n\n")[1].split("- "))

      parsed_file
    end

    def clear_list(list)
      if list.kind_of?(Array)
        list
          .map {|s| s.gsub("---", "") }
          .filter {|s| (s != "") && (s != "\n\n")}
          .map(&:strip)
      else
        list
      end
    end
  end
end
