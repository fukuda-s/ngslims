{{ flashSession.output() }}
<div class="row">
  <div class="col-md-12">
    {# {{ dump(sample_property_types) }} #}
    <div class="panel panel-info">
      <div class="panel-heading" data-toggle="collapse" href="#sample_result_panel_body">
        <div class="panel-title">Sample Search Results</div>
      </div>
      <div id="sample_result_panel_body" class="panel-body collapse in">
        <div id="handsontable-showSamples-body" style="overflow: scroll"></div>
      </div>
    </div>
  </div>
</div>
<script>
/*
 * Construct Handsontable
 */
// Make handsontable renderer and dropdown lists
var projectAr = [];
var projectPiAr = [];
var projectTypeAr = [];
var sampleTypeAr = [];
var organismAr = [];
var sampleLocationAr = [];
//var sampleLocationDrop = [];

$(document).ready(function () {

  function getProjectAr(data) {
    //console.log("stringified:"+JSON.stringify(data));
    var parseAr = JSON.parse(JSON.stringify(data));
    //alert(parseAr);
    $.each(parseAr, function (key, value) {
      //alert(value["id"]+" : "+value["name"]);
      var project_id = value["id"];
      var project_name = value["name"];
      var project_pi_user_id = value["pi_user_id"];
      var project_pi_name = value["pi_name"];
      var project_type_name = value["project_type_name"];
      projectAr[project_id] = "<a href=\"{{ url("trackerdetails/showTableSamples/") }}" + project_id + "?pre_action=projectName\">" + project_name + "</a>";
      projectPiAr[project_id] = "<a href=\"{{ url("summary/projectPi/") ~ '#pi_user_id_' }}" + project_pi_user_id + "\">" + project_pi_name + "</a>";
      projectTypeAr[project_id] = project_type_name;
    });
  }

  $.getJSON(
      '{{ url("projects/loadjson") }}',
      {},
      function (data, status, xhr) {
        getProjectAr(data);
      }
  );

  function getSampleTypeAr(data) {
    //console.log("stringified:"+JSON.stringify(data));
    var parseAr = JSON.parse(JSON.stringify(data));
    //alert(parseAr);
    $.each(parseAr, function (key, value) {
      //alert(value["id"]+" : "+value["name"]);
      var sample_type_id = value["id"];
      var sample_type_name = value["name"];
      sampleTypeAr[sample_type_id] = sample_type_name;
    });
  }

  $.getJSON(
      '{{ url("sampletypes/loadjson") }}',
      {},
      function (data, status, xhr) {
        getSampleTypeAr(data);
      }
  );

  function getOrganismAr(data) {
    //console.log("stringified:"+JSON.stringify(data));
    var parseAr = JSON.parse(JSON.stringify(data));
    //alert(parseAr);
    $.each(parseAr, function (key, value) {
      //alert(value["id"]+" : "+value["name"]);
      var organism_id = value["id"];
      var organism_name = value["name"];
      organismAr[organism_id] = organism_name;
    });
  }

  $.getJSON(
      '{{ url("organisms/loadjson") }}',
      {},
      function (data, status, xhr) {
        getOrganismAr(data);
      }
  );

  function getSampleLocationAr(data) {
    //console.log("stringified:"+JSON.stringify(data));
    var parseAr = JSON.parse(JSON.stringify(data));
    //alert(parseAr);
    $.each(parseAr, function (key, value) {
      //alert(value["id"]+" : "+value["name"]);
      var sample_location_id = value["id"];
      var sample_location_name = value["name"];
      sampleLocationAr[sample_location_id] = sample_location_name;
      //sampleLocationDrop.push(value["name"]);
    });
  }

  $.getJSON(
      '{{ url("samplelocations/loadjson") }}',
      {},
      function (data, status, xhr) {
        getSampleLocationAr(data);
      }
  );

  function strip_tags(input, allowed) {
    // +   original by: Kevin van Zonneveld (http://kevin.vanzonneveld.net)
    allowed = (((allowed || "") + "").toLowerCase().match(/<[a-z][a-z0-9]*>/g) || []).join(''); // making sure the allowed arg is a string containing only tags in lowercase (<a><b><c>)
    var tags = '/<\/?([a-z][a-z0-9]*)\b[^>]*>/gi';
    var commentsAndPhpTags = '/<!--[\s\S]*?-->|<\?(?:php)?[\s\S]*?\?>/gi';
    return input.replace(commentsAndPhpTags, '').replace(tags, function ($0, $1) {
      return allowed.indexOf('<' + $1.toLowerCase() + '>') > -1 ? $0 : '';
    });
  }

  var projectRenderer = function (instance, td, row, col, prop, value, cellProperties) {
    var escaped = Handsontable.helper.stringify(value);
    escaped = strip_tags(escaped, '<em><b><strong><a><big>'); //be sure you only allow certain HTML tags to avoid XSS threats (you should also remove unwanted HTML attributes)
    td.innerHTML = projectAr[escaped];
    return td;
  };

  var projectPiRenderer = function (instance, td, row, col, prop, value, cellProperties) {
    var escaped = Handsontable.helper.stringify(value);
    escaped = strip_tags(escaped, '<em><b><strong><a><big>'); //be sure you only allow certain HTML tags to avoid XSS threats (you should also remove unwanted HTML attributes)
    td.innerHTML = projectPiAr[escaped];
    return td;
  };

  var projectTypeRenderer = function (instance, td, row, col, prop, value, cellProperties) {
    Handsontable.TextCell.renderer.apply(this, arguments);
    //alert("renderer: "+projectTypeAr[value]);
    $(td).text(projectTypeAr[value]);
  };

  var sampleTypeRenderer = function (instance, td, row, col, prop, value, cellProperties) {
    Handsontable.TextCell.renderer.apply(this, arguments);
    //alert("renderer: "+sampleTypeAr[value]);
    $(td).text(sampleTypeAr[value]);
  };

  var organismRenderer = function (instance, td, row, col, prop, value, cellProperties) {
    Handsontable.TextCell.renderer.apply(this, arguments);
    //alert("renderer: "+sampleTypeAr[value]);
    $(td).text(organismAr[value]);
  };

  var sampleLocationRenderer = function (instance, td, row, col, prop, value, cellProperties) {
    Handsontable.TextCell.renderer.apply(this, arguments);
    //alert("renderer: "+sampleTypeAr[value]);
    $(td).text(sampleLocationAr[value]);
  };

  // Construct handsontable
  var $container = $("#handsontable-showSamples-body");
  //var $defaultColWidths = [120, 80, 100, 120, 80, 80, 80, 80, 80, 80, 80, 80, 80, 80, 150, 80, 110
  var $defaultColWidths = ['', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', ''
    {% for sample_property_type in sample_property_types %}
    {% if sample_property_type.sample_count > 0 %}, ''
    {% else %}, 0.1
    {% endif %}
    {% endfor %}
  ];
  var $samplePropertyTypesColumnsStartIdx = 17; //@TODO First index number(begin by 0) of sample_property_types
  $container.handsontable({
    stretchH: 'all',
    height: 400,
    rowHeaders: false,
    minSpareCols: 0,
    minSpareRows: 0,
    contextMenu: false,
    columnSorting: true,
    manualColumnResize: true,
    manualRowResize: true,
    fixedColumnsLeft: 4,
    currentRowClassName: 'currentRow',
    autoWrapRow: true,
    //colWidths: $defaultColWidths,
    autoColumnSize: true,
    columns: [
      {data: "s.name", title: "Sample Name", readOnly: true},
      {data: "s.project_id", title: "Project Name", readOnly: true, renderer: projectRenderer},
      {data: "s.project_id", title: "PI Name", readOnly: true, renderer: projectPiRenderer},
      {data: "s.project_id", title: "Project Type", readOnly: true, renderer: projectTypeRenderer},
      {data: "s.sample_type_id", title: "Sample Type", readOnly: true, renderer: sampleTypeRenderer},
      {data: "s.organism_id", title: "Organism", readOnly: true, renderer: organismRenderer, source: organismRenderer},
      {data: "s.qual_concentration", title: "Conc. (ng/uL)", readOnly: true, type: 'numeric', format: '0.000'},
      {data: "s.qual_od260280", title: "A260/A280", readOnly: true, type: 'numeric', format: '0.00'},
      {data: "s.qual_od260230", title: "A260/A230", readOnly: true, type: 'numeric', format: '0.00'},
      {data: "s.qual_RIN", title: "RIN", readOnly: true, type: 'numeric', format: '0.00'},
      {data: "s.qual_fragmentsize", title: "Fragment Size", readOnly: true, type: 'numeric'},
      {
        data: "s.qual_nanodrop_conc",
        title: "Conc. (ng/uL) (NanoDrop)",
        readOnly: true,
        type: 'numeric',
        format: '0.000'
      },
      {data: "s.qual_volume", title: "Volume (uL)", readOnly: true, type: 'numeric', format: '0.00'},
      {data: "s.qual_amount", data: 0, title: "Total (ng)", readOnly: true, type: 'numeric', format: '0.00'},
      {data: "s.qual_date", title: "QC Date", readOnly: true, type: 'date', dateFormat: 'yy-mm-dd'},
      {data: "s.barcode_number", title: "2D barcode", readOnly: true},
      {
        data: "s.sample_location_id",
        title: "Sample Repos.",
        readOnly: true, /* type: "dropdown", source: sampleLocationDrop, */
        renderer: sampleLocationRenderer
      },
      {% for sample_property_type in sample_property_types %}
      {
        data: 'sample_property_types.{{ sample_property_type.id }}',
        title: '{{ sample_property_type.name }}',
        readOnly: true,
        type: 'text'
      },
      {% endfor %}
    ]

  });
  var $handsontable = $container.data('handsontable');

  function loadData() {
    $.ajax({
      url: '{{ url("samples/loadjson") }}',
      dataType: 'json',
      type: 'POST',
      data: {
        query: '{{ query }}'
      }
    })
        .done(function (data) {
          //alert(data);
          //alert(location.href);

          var changedColWidths = $defaultColWidths;
          //Set column width of SamplePropertyTypes to 0.1 (not shown) or '' (auto column width) if sample has SampleProperty.
          $('#sample_property_types')
              .children('option')
              .each(function (index, domEle) {
                var actualColWidthIdx = index + $samplePropertyTypesColumnsStartIdx;
                if ($(domEle).attr('selected')) {
                  changedColWidths[actualColWidthIdx] = '';
                } else {
                  changedColWidths[actualColWidthIdx] = 0.1;
                }
              });
          //Change column width (Show checked sample_property_types column) on handsontable.
          $handsontable.updateSettings({'colWidths': changedColWidths});

          $handsontable.loadData(data);
        });
  }

  loadData(); // loading data at first.

});
</script>