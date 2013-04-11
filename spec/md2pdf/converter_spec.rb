require 'spec_helper'
require 'md2pdf'

module Md2Pdf

  describe Converter do

    describe 'converting path' do
      let(:shell) { mock('Shell') }
      let(:template_location) { stub('template_location', :contains? => false) }
      let(:temp_filename_creator) { stub('temp_filename_creator', :create_file_name => 'temp_filename') }
      let(:template) { Template.new('my_template', template_location) }
      let(:converter) { Converter.new(shell, template, temp_filename_creator) }

      it "converts a file to pdf using pandoc" do
        shell.should_receive(:exec).with("pandoc inputfile.md -o outputfile.pdf")
        converter.convert('inputfile.md','outputfile.pdf')
      end

      context "when template tex is available" do
        before do
          template_location.stub(:contains?).with('my_template/template.tex').and_return true
          template_location.stub(:path_for).with('my_template/template.tex').and_return 'my_template_path'
        end

        it "uses a template path option" do
          shell.should_receive(:exec).with("pandoc --template=my_template_path inputfile.md -o outputfile.pdf")
          converter.convert('inputfile.md','outputfile.pdf')
        end
      end

      context "when background is available" do
        before do
          template_location.stub(:contains?).with('my_template/multibackground.pdf').and_return true
          template_location.stub(:path_for).with('my_template/multibackground.pdf').and_return 'my_background_path'
        end

        it "creates a PandocConverter wrapped in a BackGrounder when a background is available" do
          shell.should_receive(:exec).with("pandoc inputfile.md -o temp_filename").ordered
          shell.should_receive(:exec).with("pdftk temp_filename multibackground my_background_path output outputfile.pdf").ordered
          converter.convert('inputfile.md','outputfile.pdf')
        end
      end
    end

  end

  describe Shell do
    describe "exec" do
      let(:shell) { Shell.new }
      it "executes a command" do
        shell.exec('echo hello world').strip.should == 'hello world'
      end
    end
  end

  describe TempFileCreator do
    describe "create_file_name" do
      it "creates a temporary pdf file" do
        TempFileCreator.new.create_file_name.should match %r{\/tmp\/.*\.pdf$}
      end
    end
  end

end

