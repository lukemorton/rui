# rui

[![Code Climate](https://codeclimate.com/github/DrPheltRight/rui/badges/gpa.svg)](https://codeclimate.com/github/DrPheltRight/rui)
[![Build Status](https://travis-ci.org/DrPheltRight/rui.svg?branch=master)](https://travis-ci.org/DrPheltRight/rui)
[![Test Coverage](https://codeclimate.com/github/DrPheltRight/rui/badges/coverage.svg)](https://codeclimate.com/github/DrPheltRight/rui)

A ruby user interface library for building your web app using a component based
approach. rui provides a DSL atop of HTML and CSS. Yes that means you'll be
writing your HTML and CSS in pure ruby.

## Concept

Frontend development has been trending towards component based architecture
for quite a while. Think SMACSS, BEM, OOCSS, ACSS. Think semantic web.

The tooling for frontend development has come along way too. We now have
abstractions on top of CSS such as SCSS and LESS, amongst many others.

Both of these advancements in frontend development aim to abstract the developer
a level above what HTML and CSS provide. However they still keep the developers
headspace much in the realm of HTML and CSS.

Eventually this will have to give. CSS preprocessors are effectively
implementing their own programming languages to give stylesheets the programming
power they now require. Complex programs require abstractions. The style of your
application is no different as the rise of frontend architectures and
preprocessors confirms.

rui is an experiment of sorts to take the developers headspace a level higher.
By giving a developer the power of ruby whilst defining the styles of their
application is to give frontend design the power it now requires. Using rui
is to admit that there are more benefits to be had using an existing language
rather than implementing a new one like SCSS. Using ruby to describe the
style of your application provides your style definitions the same
abstractions your backend logic already takes advantage of. Abstractions such
as inheritance, mixins, variables are all available in modern languages so why
reinvent them for CSS? Why not have this power today?

Well that's the theory anyway. Here's a short wishlist that could be achieved
with something like rui:

  - No longer worry about naming conventions for classes. Using rui will allow
    you to describe things, not HTML elements and class references to them.
    Your components will be mapped to HTML and CSS, you styles will only ever
    apply to the components you assign them to.
  - Compile only the styles used in your components. Dead weight will
    automatically be detected and removed. Same goes for redundant classes,
    elements will only be given classes if they require them.
  - No longer worry about the cascading nature of CSS, rui will handle this.
  - HTML minification is a breeze if your CSS and HTML is handled by the same
    compiler. We can create minified versions of CSS and HTML for production.
    That's not just whitespace removal in your CSS but minification of class
    names that link your CSS and HTML together!

## The plan

rui is a nascent library. So far it provides very basic compilation of ruby
style sheets into CSS. In bullet point form I will now describe the short term
aims for rui.

 - Media query support
 - Pseudo selector support
 - Rails asset pipeline railtie
 - Component templating DSL
 - Rails templating railtie for component DSL

## Examples

The most up to date examples will be the specs. The style sheet compiler spec
gives you an end-to-end look at what ruby style sheets look like and what
they compile into.

You can also find my random ideas in the `example/` directory of this
repository. This is where I first document my ideas before implementing them
TDD style.

## Contributing

rui is a crazy experiment. If you have the time to help out I would very much
appreciate anything you can do. Whether it's giving feedback or submitting
pull requests, all help is welcome. Just create an issue and start a
conversation.

## Author

Luke Morton

## License

This idea is MIT.
