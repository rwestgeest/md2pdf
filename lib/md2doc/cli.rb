require 'thor'

module Md2Doc
  class CLI < Thor
    include Thor::Actions

    desc "pdf input_file, template", "Creates a pdf from input file with template"
    def pdf(input_file, template='default')
      Converter.new(
        Shell.new, 
        Template.new(template, 
                     TemplateLocation.new(File.expand_path('~/.md2doc'))), 
        TempFileCreator.new).convert(input_file, output_file(input_file))
    end

    desc "create_template template name", "Creates a template dir with an initial tex template"
    def create_template(template)
        Template.new(template, 
                     TemplateLocation.new(File.expand_path('~/.md2doc'))).create(Shell.new) 
    end

    desc "list_templates", "List teplates"
    def list_templates
        puts TemplateLocation.new(File.expand_path('~/.md2doc')).list.join($/)
    end

    private
    def output_file(input_file)
      File.join(File.dirname(input_file), File.basename(input_file, File.extname(input_file)) + '.pdf')
    end
  end

end
