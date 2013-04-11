# Md2Pdf

This gem lets you create a nicely formatted document from a markdown
source.

Primarily we created this gem to enable us to quickly write markdown
documents for offers for clients without worrying about layout and
formatting and while being able to use a light weight text editor like
vim, emacs, gedit, notepad whatever.

We have worked with markdown in combination with pandoc with a latex
template for pdf creation and pdftk for adding a background for each
page (like a kind of printed template page with a logo and address
footer.

We found ourselves copying and pasting a simple rakefile, templates and logos
everywhere we needed to create an offer or similar document.

```ruby
desc "preview offerte"
task :view => :offerte do
  sh "evince VoorstelPairProgrammingWorkshop#{today}.pdf"
end

desc "create offerte"
task :offerte do
  sh "pandoc offerte.md --number-sections --template=template.tex -o offerte_temp.pdf"
  sh "pdftk offerte_temp.pdf multibackground QwanFront.pdf output VoorstelPairProgrammingWorkshop#{today}.pdf"
  rm 'offerte_temp.pdf'
end


def today
  Date.today.strftime("%F")
end
```

This gem more or less encapsulates this in an executable script (which
is in your path after installation) and enables you to manage several
templates.

## Installation

Add this line to your application's Gemfile:

```bash
    $ gem install md2doc
```

## Usage

Use md2doc --help to show help for options - should be self documenting

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
