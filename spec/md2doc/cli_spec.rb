require 'spec_helper'
require 'md2doc'
require 'test_file'

module Md2Doc

  class MarkDownConverter 
    def initialize(shell)
      @shell = shell
    end
    def convert(input_filename, output_filename)
      @shell.exec("pandoc #{input_filename} -o #{output_filename}")
    end
  end

  describe MarkDownConverter, :focus do
    describe "creating a pdf" do
      let(:shell) { mock('shell') }
      let(:markdown_converter) { MarkDownConverter.new(shell) }

      it "creates a pdf using the pdf creator" do
        shell.should_receive(:exec).with('pandoc filename.md -o filename.pdf')
        markdown_converter.convert('filename.md', 'filename.pdf')
      end

    end

    describe "integration" do
      include TestFile
      let(:cli) { CLI.new }
      let!(:markdown_file)  { a_file('input.md').with_content("#my heading") }

      it "creates a pdf with the same name" do
        capture(:stdout) { cli.pdf(markdown_file.path) }
        a_file('input.pdf').should exist
      end

      it "the pdf contains the text" do
        capture(:stdout) { cli.pdf(markdown_file.path) }
        a_file('input.pdf').as_pdf.should include("my heading")
      end

      context "when it contains a title" do
        let!(:markdown_file)  { a_file('input.md').with_content("%my title\n%my author\n%\n#my heading") }
        before { capture(:stdout) { cli.pdf(markdown_file.path) } }
        subject { a_file('input.pdf').as_pdf }
        it { should include("my title") }
        it { should_not include("%") }
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
end
