<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8">
  {{ get_title() }}
  {{ stylesheet_link('bootstrap/css/bootstrap.css') }}
  {{ stylesheet_link('js/jquery-ui-1.11.0/jquery-ui.min.css') }}
  {{ stylesheet_link('js/DataTables-1.10.2/media/css/jquery.dataTables.css') }}
  {{ stylesheet_link('css/jquery.handsontable.full.css') }}
  {{ stylesheet_link('css/jquery.handsontable.bootstrap.css') }}
  {{ stylesheet_link('css/font-awesome.css') }}
  {{ stylesheet_link('css/bootstrap-multiselect.css') }}
  {{ stylesheet_link('css/style.css') }}
  {{ javascript_include('js/jquery/jquery-2.1.1.min.js') }}
  {{ javascript_include('js/jquery-ui-1.11.0/jquery-ui.min.js') }}
  {{ javascript_include('bootstrap/js/bootstrap.js') }}
  {{ javascript_include('js/DataTables-1.10.2/media/js/jquery.dataTables.js') }}
  {{ javascript_include('js/handsontable/jquery.handsontable.full.js') }}
  {{ javascript_include('js/bootstrap-multiselect/bootstrap-multiselect.js') }}
  {{ javascript_include('js/utils.js') }}
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <meta name="description" content="Laboratory Information Management System for NGS Laboratory">
  <meta name="author" content="Shiro Fukuda">
</head>
<body>
{{ content() }}
</body>
</html>