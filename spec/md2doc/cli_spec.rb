require 'spec_helper'
require 'md2doc'
require 'test_file'

module Md2Doc

  describe CLI do
    include TestFile
    let(:cli) { CLI.new }
    let!(:markdown_file)  { a_file('input.md').with_content("#my heading") }

    it "the pdf contains the text" do
      capture(:stdout) { cli.pdf(markdown_file.path) }
      a_file('input.pdf').as_pdf.should include("my heading")
    end

    context "when it contains a title" do
      let!(:markdown_file)  { a_file('input.md').with_content("%my title\n%my author\n%\n#my heading") }

      it "should put the title in the output" do
        capture(:stdout) { cli.pdf(markdown_file.path) }
        output  = a_file('input.pdf').as_pdf
        output.should include("my title") 
        output.should_not include("%")
      end
    end

    def capture(*streams)
      streams.map! { |stream| stream.to_s }
      begin
        result = StringIO.new
        streams.each { |stream| eval "$#{stream} = result" }
        yield
      ensure
        streams.each { |stream| eval("$#{stream} = #{stream.upcase}") }
      end
      result.string
    end
  end
end
