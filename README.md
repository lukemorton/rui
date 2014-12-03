# rui

[![Code Climate](https://codeclimate.com/github/DrPheltRight/rui/badges/gpa.svg)](https://codeclimate.com/github/DrPheltRight/rui)
[![Build Status](https://travis-ci.org/DrPheltRight/rui.svg?branch=master)](https://travis-ci.org/DrPheltRight/rui)
[![Test Coverage](https://codeclimate.com/github/DrPheltRight/rui/badges/coverage.svg)](https://codeclimate.com/github/DrPheltRight/rui)

Someone told me it's okay to build UI/UX in your favourite language. I took that
to mean reinventing the wheel so that's what we'll do.

## Concept

Component based style definition. Component based structure definition. Still
separate like CSS and HTML. Intelligently coupled at point of use.
Written in Ruby.

Although we all acknowledge that CSS and HTML should be defined separately,
browsers in fact couple the two at render time. There are a number of
optimisations to be had if we couple the two just before sending them to the
browser. There are also other benefits that come from using a language to
define style. Here is a list of benefits rui could provide:

  - Only compile CSS that is used in HTML
  - Only add classes to HTML elements that have styles defined
  - No need to define classes, define components instead
  - Never worry about applying styles to the wrong elements
  - Class minification for production
  - Works with rails

## Example

Please find the example in this repo. The implementation hasn't started yet
but this example embodies the idea.

## Author

Luke Morton

## License

This idea is MIT.
