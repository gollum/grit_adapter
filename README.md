[![Gem Version](https://badge.fury.io/rb/gollum-grit_adapter.svg)](http://badge.fury.io/rb/gollum-grit_adapter)
[![Build Status](https://travis-ci.org/gollum/grit_adapter.svg?branch=master)](https://travis-ci.org/gollum/grit_adapter)

## DESCRIPTION

Adapter for Gollum to use Grit at the backend.

## CONTRIBUTING

Make sure the [git adapter specs](https://github.com/gollum/adapter_specs) pass by running `rake`, but also make sure that the [gollum-lib](https://github.com/gollum/gollum-lib) specs pass when using your branch of this adapter as a backend:
1. Clone the latest version of gollum-lib.
2. Change gollum-lib's Gemfile so as to use your local version of this adapter, i.e.:
```diff
-gem 'gollum-grit_adapter'
+gem 'gollum-grit_adapter', :path => "/path/to/your/gollum-lib_grit_adapter"
```
3. Run the gollum-lib specs and see if they pass.
