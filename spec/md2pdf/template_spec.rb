require 'spec_helper'
require 'md2pdf'
require 'test_file'

module Md2Pdf

  describe Template do
    let(:template_location) { TemplateLocation.new 'my_templates' }

    include TestFile
    include FileUtils

    after { rm_r 'my_templates' if File.exists?('my_templates') }
    describe "create template" do
      let(:new_template) { Template.new "my_new_template", template_location }
      it "creates a tex template" do
        new_template.create(Shell.new)
        new_template.should exist 
      end
      context "when template exists" do
        before { Template.new("my_new_template", template_location).create(Shell.new) }
        it "refuses to create the template" do
          expect { new_template.create(Shell.new) }.to raise_exception(TemplateExistsError)
        end
      end
    end
  end

  describe TemplateLocation do
    include FileUtils
    let(:template_location) { TemplateLocation.new 'my_templates' }
    after { rm_r 'my_templates' if File.exists?('my_templates') }
    describe "path_for" do
      it "constructs the path in the template location" do
        template_location.path_for('some/path.txt').should == "my_templates/some/path.txt"
      end
    end

    describe "contains?" do
      include TestFile
      describe "when path does not exist" do
        it "returns false" do
          template_location.contains?('some/path.txt').should be_false
        end
      end
      context "when path exists" do
        before do 
          mkdir_p 'my_templates/some'
          a_file('my_templates/some/path.txt').with_content "blah"
        end

        it "returns true" do
          template_location.contains?('some/path.txt').should be_true
        end
      end
    end
    describe "list" do
      let(:shell) { Shell.new }
      it "is emppty initially" do
        template_location.list.should == []
      end
      it "lists the template names" do
        Template.new("template1", template_location).create(shell)
        Template.new("template2", template_location).create(shell)
        template_location.list.should == ["template1", "template2"]
      end
    end
  end

end
