require 'fileutils'

module Md2Pdf

  class TemplateExistsError < Exception; end

  class Template < Struct.new(:name, :template_location)
    def create_pdf_converter(shell, temp_filename_creator = TempFileCreator)
      wrap_in_backgrounder PandocConverter.new(shell, pandoc_tex_template), shell, temp_filename_creator
    end

    def create(shell)
      raise TemplateExistsError.new("template #{name} already exists") if exists?
      FileUtils.mkdir_p(template_location.path_for(name))
      shell.exec("pandoc -D latex > #{template_location.path_for(tex_template_path)}")
    end

    def exists?
      template_location.contains?(tex_template_path)
    end

    private
    def wrap_in_backgrounder(converter, shell, temp_filename_creator)
      template_location.contains?(multibackground_path) && BackGrounder.new(converter, shell, temp_filename_creator, template_location.path_for(multibackground_path)) || converter
    end

    def pandoc_tex_template
      template_location.contains?(tex_template_path) && template_location.path_for(tex_template_path) || ""
    end

    def multibackground_path
      "#{name}/multibackground.pdf"
    end

    def tex_template_path
      "#{name}/template.tex"
    end
  end

  class TemplateLocation < Struct.new(:location)
    def path_for(path)
      File.join(location, path)
    end
    def contains?(path)
      File.exists?(path_for(path))
    end
    def list
      Dir[File.join(location,"*")].map {|f| File.basename(f)}
    end
  end
end



