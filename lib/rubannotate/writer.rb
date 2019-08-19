# frozen_string_literal: true

module Rubannotate
  class Writer
    def initialize(filepath)
      @filepath = filepath
    end

    def write(str)
      old_filedata = File.read(@filepath)

      file_data = filedata_without_annotation(old_filedata)
      new_filedata = file_data[0] + str + "\n" + file_data[1]
      return if new_filedata == old_filedata

      File.open(@filepath, 'w') do |f|
        f.write(new_filedata)
      end
    end

    def cleanup
      old_filedata = File.read(@filepath)

      file_data = filedata_without_annotation(old_filedata)
      new_filedata = file_data[0] + file_data[1]
      return if new_filedata == old_filedata

      File.open(@filepath, 'w') do |f|
        f.write(new_filedata)
      end
    end

    private

    def filedata_without_annotation(filedata)
      lines = filedata.split("\n")
      lineno = 0

      r_magic_comment = []
      r = []

      while (line = lines[lineno])
        if magic_comment_line?(line)
          r_magic_comment << line
          lineno += 1
          next
        end

        if schema_dumper_header_line?(line)
          loop do
            lineno += 1
            line = lines[lineno]
            break if line.nil?
            break if line.strip.empty?
          end
        end

        r << line
        lineno += 1
      end

      [
        r_magic_comment.empty? ? '' : r_magic_comment.join("\n").strip + "\n\n",
        r.empty? ? '' : r.join("\n").strip + "\n"
      ]
    end

    def magic_comment_line?(line)
      return true if /\A\s*#\s*frozen[_-]string[_-]literal:\s*[[:alnum:]\-_]+/i =~ line

      false
    end

    def schema_dumper_header_line?(line)
      line.start_with?(SchemaDumper::HEADER)
    end
  end
end
