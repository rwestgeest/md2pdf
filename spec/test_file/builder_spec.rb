require 'spec_helper'
require 'test_file'

describe TestFile::Builder do
  include TestFile
  describe 'creating a file with text' do
    it "creates a file" do
      a_file('test_file.txt').with_content('text').should exist
    end

    it "contains the content" do
      a_file('test_file.txt').with_content('text').should include("text")
    end

    describe "and after that" do
      it "removes the file" do
        a_file('test_file.txt').with_content('text')
        remove_test_files
        a_file('test_file.txt').should_not exist
      end
    end
  end

  describe "including it in a non rspec module" do
    class SomeModule
      include TestFile
    end
    it "makes it respond to a_file" do
      SomeModule.new.should respond_to(:a_file)
    end
  end
end
