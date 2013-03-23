require 'thor'

module Md2Doc
  class CLI < Thor
    include Thor::Actions
    desc "pdf", "Creates a pdf"
    def pdf(input_file)
      run "pandoc #{input_file} -o #{output_file(input_file)}"
    end

    private
    def output_file(input_file)
      File.basename(input_file, File.extname(input_file)) + '.pdf'
    end
  end
end
