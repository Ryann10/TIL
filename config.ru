#!/usr/bin/env ruby
require 'rubygems'
require 'gollum/app'

Precious::App.set(:gollum_path, File.dirname(__FILE__))
Precious::App.set(:default_markup, :markdown) # set your favorite markup language
Precious::App.set(:wiki_options, {
  :universal_toc => true,
  :mathjax => true,
  :live_preview => false,
  :css => true,
  :js => true
  })
run Precious::App
