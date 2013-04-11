module Md2Doc

  class Converter < Struct.new(:shell, :templater, :temp_filename_creator)
    def convert(input_filename, output_filename)
      templater.create_pdf_converter(shell, temp_filename_creator).convert(input_filename, output_filename)
    end
  end


  class PandocConverter < Struct.new(:shell, :template_path)
    def convert(input_filename, output_filename)
      shell.exec("pandoc#{options} #{input_filename} -o #{output_filename}")
    end
    private
    def options
      template_path.empty? && "" || " --template=#{template_path}"
    end
  end

  class BackGrounder < Struct.new(:wrapped_converter, :shell, :temp_filename_creator, :background_path)
    def convert(input_filename, output_filename)
      wrapped_converter.convert(input_filename, temp_filename)
      shell.exec("pdftk #{temp_filename} multibackground #{background_path} output #{output_filename}")
    end
    def temp_filename
      @temp_filename ||= temp_filename_creator.create_file_name
    end
  end

  class TempFileCreator
    def create_file_name
      Tempfile.new('temp.pdf').path + '.pdf'
    end
  end

  class Shell
    def exec(command_line)
      require 'open3'
      stdin, stdout, stderr = Open3.popen3(command_line)
      return stdout.read
    end
  end

end
