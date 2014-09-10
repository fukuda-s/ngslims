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
      projectAr[project_id] = "<a href=\"{{ url("trackerdetails/showTableSamples/") }}" + project_id + "?pre=projectName\">" + project_name + "</a>";
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

  // Cleaved edited row from whole data of handsontable.
  /*
   function cleaveData(changes) {
   var data = $handsontable.getData();
   var cleavedData = Object();
   //for (var i = 0; i < changes.length; i++) {
   $.each(changes, function (rowIndex, rowValues) {
   $.each(rowValues, function (colIndex, value) {
   if (value) {
   console.log('changes[' + colIndex + '] = ' + value);
   var rowNumToChange = value[0];
   if (!cleavedData[rowNumToChange]) {
   cleavedData[rowNumToChange] = data[rowNumToChange];
   }
   }
   });
   });
   return cleavedData;
   }
   */

  // Integrate 'changes' on handsontable, because editor can change same cell at several times.
  /*
   var isDirtyAr = Object();

   function integrateIsDirtyAr(changes) {
   //for (var i = 0; i < changes.length; i++) {
   $.each(changes, function (key, value) {
   if (value) {
   var rowNumToChange = value[0];
   var columnToChange = value[1];
   if (!isDirtyAr[rowNumToChange]) {
   isDirtyAr[rowNumToChange] = Object();
   }
   isDirtyAr[rowNumToChange][columnToChange] = value; //Over write isDirtyAr with current changes.
   }
   });
   console.log(isDirtyAr);
   }
   */

  // Construct handsontable
  var $container = $("#handsontable-showSamples-body");
  //var $console = $("#handsontable-console");
  //var $toolbar = $("#handsontable-toolbar");
  //var autosaveNotification = String();
  //var $samplePropertyTypesColumns = [
  {# {% for sample_property_type in sample_property_types %}
  "sample_property_type_id_{{ sample_property_type.id }}",
  {% endfor %} #}
  //];
  //var $defaultColWidths = [120, 80, 100, 120, 80, 80, 80, 80, 80, 80, 80, 80, 80, 80, 150, 80, 110
  var $defaultColWidths = ['', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', ''
    {% for sample_property_type in sample_property_types %}
    {% if sample_property_type.sample_count > 0 %}
    , ''
    {% else %}
    , 0.1
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
      { data: "name", title: "Sample Name", readOnly: true },
      { data: "project_id", title: "Project Name", readOnly: true, renderer: projectRenderer },
      { data: "project_id", title: "PI Name", readOnly: true, renderer: projectPiRenderer },
      { data: "project_id", title: "Project Type", readOnly: true, renderer: projectTypeRenderer },
      { data: "sample_type_id", title: "Sample Type", readOnly: true, renderer: sampleTypeRenderer },
      { data: "organism_id", title: "Organism", readOnly: true, renderer: organismRenderer, source: organismRenderer },
      { data: "qual_concentration", title: "Conc. (ng/uL)", readOnly: true, type: 'numeric', format: '0.000' },
      { data: "qual_od260280", title: "A260/A280", readOnly: true, type: 'numeric', format: '0.00' },
      { data: "qual_od260230", title: "A260/A230", readOnly: true, type: 'numeric', format: '0.00' },
      { data: "qual_RIN", title: "RIN", readOnly: true, type: 'numeric', format: '0.00' },
      { data: "qual_fragmentsize", title: "Fragment Size", readOnly: true, type: 'numeric' },
      { data: "qual_nanodrop_conc", title: "Conc. (ng/uL) (NanoDrop)", readOnly: true, type: 'numeric', format: '0.000' },
      { data: "qual_volume", title: "Volume (uL)", readOnly: true, type: 'numeric', format: '0.00' },
      { data: "qual_amount", data: 0, title: "Total (ng)", readOnly: true, type: 'numeric', format: '0.00' },
      { data: "qual_date", title: "QC Date", readOnly: true, type: 'date', dateFormat: 'yy-mm-dd' },
      { data: "barcode_number", title: "2D barcode", readOnly: true  },
      { data: "sample_location_id", title: "Sample Repos.", readOnly: true, /* type: "dropdown", source: sampleLocationDrop, */ renderer: sampleLocationRenderer },
      {% for sample_property_type in sample_property_types %}
      { data: 'sample_property_types.{{ sample_property_type.id }}', title: '{{ sample_property_type.name }}', readOnly: true, type: 'text'},
      {% endfor %}
    ],
    /*
     afterChange: function (changes, source) {
     if (source === 'loadData') {
     return; // don't save this change
     }
     else {
     // Enable "Save", "Undo" link on toolbar above of table
     // after editting.
     // alert("afterEdit");
     $toolbar.find("#save, #undo, #clear").removeClass("disabled");
     $console.text('Click "Save" to save data to server').removeClass().addClass("alert alert-info");
     integrateIsDirtyAr(changes);

     // Show alert dialog when this page moved before save.
     $(window).on('beforeunload', function () {
     return 'CAUTION! You have not yet saved. Are you sure you want to leave?';
     });
     }

     //console.log(JSON.stringify(handsontable.getData()));

     if ($('#handsontable-autosave').find('input').is(':checked')) {
     clearTimeout(autosaveNotification);
     $.ajax({
     url: '{{ url("trackerdetails/saveSamples") }}',
     dataType: "json",
     type: "POST",
     data: {data: cleaveData(changes), changes: changes} // returns "data" as all data and "changes" as changed data
     })
     .done(function () {
     $console.text('Autosaved (' + changes.length + ' cell' + (changes.length > 1 ? 's' : '') + ')')
     .removeClass().addClass("alert alert-success");
     autosaveNotification = setTimeout(function () {
     $console.text('Changes will be autosaved').removeClass().addClass("alert alert-success");
     }, 1000);
     })
     .fail(function () {
     $console.text('Autosaved (' + changes.length + ' cell' + (changes.length > 1 ? 's' : '') + ') is Failed')
     .removeClass().addClass("alert alert-danger");
     });
     }

     }
     */
  });
  var $handsontable = $container.data('handsontable');

  function loadData() {
    $.ajax({
      url: '{{ url("samples/loadjson/0/0") }}',
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
          $('#sample_property_types').children('option').each(function (index, domEle) {
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

  /*
   $toolbar.find('#save').click(function () {
   //alert("save! "+$handsontable.getData());
   $.ajax({
   url: '
  {{ url("trackerdetails/saveSamples") }}',
   data: {data: cleaveData(isDirtyAr), changes: isDirtyAr }, // returns all cells
   dataType: 'text',
   type: 'POST'
   })
   .done(function (data, status, xhr) {
   //alert(status.toString());
   $console.text('Save success').removeClass().addClass("alert alert-success");
   $toolbar.find("#save").addClass("disabled");
   isDirtyAr = Object(); //Clear isDirtyAr

   // Disable alert dialog when this page is saved.
   $(window).off('beforeunload');
   })
   .fail(function (xhr, status, error) {
   //alert(status.toString());
   $console.text('Save error').removeClass().addClass("alert alert-danger");
   });
   });

   $toolbar.find('#undo').click(function () {
   // alert("undo! "+$handsontable.isUndoAvailable()+"
   // "+$handsontable.isRedoAvailable())
   $handsontable.undo();
   // $console.text('Undo!');
   if ($handsontable.isUndoAvailable()) {
   $toolbar.find("#undo").removeClass("disabled");
   } else {
   $toolbar.find("#undo").addClass("disabled");
   }

   if ($handsontable.isRedoAvailable()) {
   $toolbar.find("#redo").removeClass("disabled");
   } else {
   $toolbar.find("#redo").addClass("disabled");
   }
   });

   $toolbar.find('#redo').click(function () {
   // alert("redo! "+$handsontable.isUndoAvailable()+"
   // "+$handsontable.isRedoAvailable());
   $handsontable.redo();
   // $console.text('Redo!');
   if ($handsontable.isUndoAvailable()) {
   $toolbar.find("#undo").removeClass("disabled");
   } else {
   $toolbar.find("#undo").addClass("disabled");
   }

   if ($handsontable.isRedoAvailable()) {
   $toolbar.find("#redo").removeClass("disabled");
   } else {
   $toolbar.find("#redo").addClass("disabled");
   }
   });

   $toolbar.find('#clear').click(function () {
   loadData();
   $toolbar.find("#save, #undo, #redo, #clear").addClass("disabled");
   $console.text('All changes is discarded').removeClass().addClass("alert alert-success");
   // Disable alert dialog when this page is cleard.
   $(window).off('beforeunload');
   });


   $('#handsontable-autosave').find('input').click(function () {
   if ($(this).is(':checked')) {
   $console.text('Changes will be autosaved').removeClass().addClass("alert alert-success");
   }
   else {
   $console.text('Changes will not be autosaved').removeClass().addClass("alert alert-warning");
   }
   });
   */

  //var $samplePropertyTypesChecked = new Object();

  /*
   * Show/Hide sample_property_types columns when checkbox is checked/unchecked.
   */
  /*
   $('#sample_property_types').multiselect({
   onChange: function (element, checked) {

   var changedColWidths = $defaultColWidths;
   console.log(changedColWidths);

   for (var i = 0; i < $samplePropertyTypesColumns.length; i++) {
   var actualColWidthIdx = i + $samplePropertyTypesColumnsStartIdx;
   if ($samplePropertyTypesColumns[i] == element.val()) {
   //console.log($samplePropertyTypesColumns[i] + " : " + element.val());
   if (checked == true) {
   changedColWidths[actualColWidthIdx] = 120;
   } else {
   changedColWidths[actualColWidthIdx] = 0.1;
   }
   //$samplePropertyTypesChecked[$samplePropertyTypesColumns[i]] = checked;
   }
   }
   //Set session value for sample_property_types checked of checked/unchecked.
   //setOrderSessionVal('sample_property_types_checked', 0, $samplePropertyTypesChecked);
   //console.log($samplePropertyTypesChecked);

   //Change column width (Show checked sample_property_types column) on handsontable.
   $handsontable.updateSettings({'colWidths': changedColWidths});
   console.log(changedColWidths);
   }
   });
   */

});
</script>