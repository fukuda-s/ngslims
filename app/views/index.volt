<!DOCTYPE html>
<!--
  ~ (The MIT License)
  ~
  ~ Copyright (c) 2014-2018 Genome Science Division, RCAST, Univ.Tokyo. <fukuda-s@genome.rcast.u-tokyo.ac.jp>
  ~
  ~ Permission is hereby granted, free of charge, to any person obtaining
  ~ a copy of this software and associated documentation files (the
  ~ 'Software'), to deal in the Software without restriction, including
  ~ without limitation the rights to use, copy, modify, merge, publish,
  ~ distribute, sublicense, and/or sell copies of the Software, and to
  ~ permit persons to whom the Software is furnished to do so, subject to
  ~ the following conditions:
  ~
  ~ The above copyright notice and this permission notice shall be
  ~ included in all copies or substantial portions of the Software.
  ~
  ~ THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
  ~ EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
  ~ MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
  ~ IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
  ~ CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
  ~ TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
  ~ SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
  -->

<html>
<head>
  <meta charset="utf-8">
  {{ get_title() }}
  {{ stylesheet_link('bootstrap/css/bootstrap.css') }}
  {{ stylesheet_link('js/jquery-ui-dist/jquery-ui.min.css') }}
  {{ stylesheet_link('css/font-awesome.css') }}
  {{ stylesheet_link('css/style.css') }}
  {{ assets.outputCss() }}
  {{ javascript_include('js/jquery/jquery-2.2.0.min.js') }}
  {{ javascript_include('js/jquery-ui-dist/jquery-ui.min.js') }}
  {{ javascript_include('bootstrap/js/bootstrap.js') }}
  {{ assets.outputJs() }}
  {{ javascript_include('js/utils.js') }}
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <meta name="description" content="Laboratory Information Management System for NGS Laboratory">
  <meta name="author" content="Shiro Fukuda">
</head>
<body>
{{ content() }}
</body>
</html>