<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8">
  {{ get_title() }}
  {{ stylesheet_link('bootstrap/css/bootstrap.css') }}
  {{ stylesheet_link('js/jquery-ui-1.12.1/jquery-ui.min.css') }}
  {{ stylesheet_link('css/font-awesome.css') }}
  {{ stylesheet_link('css/style.css') }}
  {{ assets.outputCss() }}
  {{ javascript_include('js/jquery/jquery-2.2.0.min.js') }}
  {{ javascript_include('js/jquery-ui-1.12.1/jquery-ui.min.js') }}
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