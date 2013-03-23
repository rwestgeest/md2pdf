require 'pdf-reader'

module TestFile
  def self.included(base)
    base.after { remove_test_files } if base.respond_to?(:after)
  end

  def a_file(name)
    test_files << Builder.new(name)
    test_files.last
  end

  def test_files
    @test_files ||= [] 
  end


  def remove_test_files
    test_files.each {|file| file.delete}
  end

  class Builder < Struct.new(:name)
    def with_content(content)
      writer.write(content)
      writer.flush
      self
    end

    def as_pdf
      PDFBuilder.new(self)
    end

    def writer
      @writer ||= File.new(path, 'w+')
    end

    def reader
      @reader ||= File.new(path, 'r')
    end

    def delete
      File.delete(path) if exist?
    end

    def exist?
      File.exists?(path)
    end

    def include?(content)
      reader.read.include?(content)
    end

    def path
      name
    end

    def to_s
      "TestFile #{path}"
    end
    alias_method :inspect, :to_s
  end

  class PDFBuilder < Struct.new(:builder)
    def delete
      builder.delete
    end
    def exists?
      builder.exists?
    end
    def reader
      PDF::Reader.new(builder.reader)
    end
    def include?(content)
      reader.pages.map { |page| page.text }.join.include? content
    end
  end
end

