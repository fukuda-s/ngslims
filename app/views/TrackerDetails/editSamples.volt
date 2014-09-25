<div class="row">
  <div class="col-md-12">
    {{ partial('partials/trackerdetails-header') }}
    <div
        align="left">{{ link_to("trackerdetails/showTableSamples/" ~ project.id ~ "?pre=" ~ previousAction, "<< Back to Sample Info", "class": "btn btn-primary") }}</div>
    <hr>
    {{ flashSession.output() }}
    {# {{ dump(sample_property_types) }} #}
    {% include 'partials/handsontable-toolbar.volt' %}
    <ul class="nav nav-tabs">
      <li class="active">{{ link_to("trackerdetails/editSamples/" ~ type ~ '/' ~ step.id ~ '/' ~ project.id ~ '?pre=' ~ previousAction, "Samples") }}</li>
      {% if type !== 'QC' %}
        <li>{{ link_to("trackerdetails/editSeqlibs/" ~ type ~ '/' ~ step.id ~ '/' ~ project.id ~ '?pre=' ~ previousAction, "SeqLibs") }}</li>
        {% if type !== 'PREP' %}
          <!--
          <li>{{ link_to("trackerdetails/editSeqlanes/" ~ type ~ '/' ~ step.id ~ '/' ~ project.id ~ '?pre=' ~ previousAction, "SeqLanes") }}</li>
          -->
        {% endif %}
      {% endif %}
      <button id="handsontable-size-ctl" type="button" class="btn btn-default pull-right">
        <span class="fa fa-expand"></span>
      </button>
    </ul>
    <div id="handsontable-editSamples-body" style="overflow: scroll"></div>
  </div>
</div>
<script>
/*
 * Construct Handsontable
 */
// Make handsontable renderer and dropdown lists
var sampleTypeAr = [];
var organismAr = [];
var protocolAr = [];
var protocolDrop = [];
var sampleLocationAr = [];
var sampleLocationDrop = [];

$(document).ready(function () {

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

  function getProtocolAr(data) {
    //console.log("stringified:"+JSON.stringify(data));
    var parseAr = JSON.parse(JSON.stringify(data));
    //alert(parseAr);
    $.each(parseAr, function (key, value) {
      //alert(value["id"]+" : "+value["name"]);
      var protocol_id = value["id"];
      var protocol_name = value["name"];
      protocolAr[protocol_id] = protocol_name;
      protocolDrop.push(value["name"]);
    });
  }

  $.getJSON(
      '{{ url("protocols/loadjson/") ~ step.id }}',
      {},
      function (data, status, xhr) {
        getProtocolAr(data);
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
      sampleLocationDrop.push(value["name"]);
    });
  }

  $.getJSON(
      '{{ url("samplelocations/loadjson") }}',
      {},
      function (data, status, xhr) {
        getSampleLocationAr(data);
      }
  );

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

  var protocolRenderer = function (instance, td, row, col, prop, value, cellProperties) {
    Handsontable.TextCell.renderer.apply(this, arguments);
    $(td).text(protocolAr[value]);
  };

  var sampleLocationRenderer = function (instance, td, row, col, prop, value, cellProperties) {
    Handsontable.TextCell.renderer.apply(this, arguments);
    //alert("renderer: "+sampleTypeAr[value]);
    $(td).text(sampleLocationAr[value]);
  };

  /*
   * Cleaved edited row from whole data of handsontable.
   */
  var cleavedData = Object();

  /*
   * Integrate 'changes' on handsontable, because editor can change same cell at several times.
   */
  var isDirtyAr = Object();

  function integrateIsDirtyAr(changes) {
    //for (var i = 0; i < changes.length; i++) {
    $.each(changes, function (key, value) {
      if (value) {
        var rowNumToChange = value[0];
        var columnToChange = value[1];
        var valueChangeTo = value[3];
        var rowData = $handsontable.getDataAtRow(rowNumToChange);
        var sample_id = rowData[0];
        if (!isDirtyAr[sample_id]) {
          isDirtyAr[sample_id] = Object();
        }
        isDirtyAr[sample_id][columnToChange] = valueChangeTo; //Over write isDirtyAr with current changes.
      }
    });
    console.log(isDirtyAr);
  }

  // Construct handsontable
  var $container = $("#handsontable-editSamples-body");
  var $console = $("#handsontable-console");
  var $toolbar = $("#handsontable-toolbar");
  var autosaveNotification = String();
  var $samplePropertyTypesColumns = [
    {% for sample_property_type in sample_property_types %}
    "sample_property_type_id_{{ sample_property_type.id }}",
    {% endfor %}
  ];
  //var $defaultColWidths = [120, 80, 80, 80, 80, 80, 80, 80, 80, 80, 80, 160, 80, 110
  var $defaultColWidths = ['', '', '', '', '', '', '', '', '', '', '', '', '', '', ''
    {% for sample_property_type in sample_property_types %}
    {% if sample_property_type.sample_count > 0 %}, ''
    {% else %}, 0.1
    {% endif %}
    {% endfor %}
    {% if type === 'PREP' %}, 80, 150
    {% endif %}
  ];
  var $samplePropertyTypesColumnsStartIdx = 15; //@TODO First index number(begin by 0) of sample_property_types
  $container.handsontable({
    stretchH: 'all',
    height: 500,
    //rowHeaders: true,
    minSpareCols: 0,
    minSpareRows: 0,
    contextMenu: false,
    columnSorting: true,
    manualColumnResize: true,
    manualRowResize: true,
    fixedColumnsLeft: 2,
    currentRowClassName: 'currentRow',
    autoWrapRow: true,
    search: true,
    //colWidths: $defaultColWidths,
    autoColumnSize: true,
    columns: [
      {data: "id", title: "ID", type: 'numeric', readOnly: true},
      {data: "name", title: "Sample Name", readOnly: true},
      {data: "sample_type_id", title: "Sample Type", readOnly: true, renderer: sampleTypeRenderer},
      {data: "organism_id", title: "Organism", readOnly: true, renderer: organismRenderer, source: organismRenderer},
      {data: "qual_concentration", title: "Conc. (ng/uL)", type: 'numeric', format: '0.000'},
      {data: "qual_od260280", title: "A260/A280", type: 'numeric', format: '0.00'},
      {data: "qual_od260230", title: "A260/A230", type: 'numeric', format: '0.00'},
      {data: "qual_RIN", title: "RIN", type: 'numeric', format: '0.00'},
      {data: "qual_fragmentsize", title: "Fragment Size", type: 'numeric'},
      {data: "qual_nanodrop_conc", title: "Conc. (ng/uL) (NanoDrop)", type: 'numeric', format: '0.000'},
      {data: "qual_volume", title: "Volume (uL)", type: 'numeric', format: '0.00'},
      {data: "qual_amount", title: "Total (ng)", type: 'numeric', format: '0.00'},
      {data: "qual_date", title: "QC Date", type: 'date', dateFormat: 'yy-mm-dd'},
      {data: "barcode_number", title: "2D barcode"},
      {
        data: "sample_location_id",
        title: "Sample Repos.",
        type: "dropdown",
        source: sampleLocationDrop,
        renderer: sampleLocationRenderer
      },
      {% for sample_property_type in sample_property_types %}
      {
        data: 'sample_property_types.{{ sample_property_type.id }}',
        title: '{{ sample_property_type.name }}',
        type: 'text'
      },
      {% endfor %}
      {% if type === 'PREP' %}
      {data: "to_prep", title: "Create New SeqLib", type: 'checkbox'},
      {
        data: "to_prep_protocol_name",
        title: "Protocol",
        type: "dropdown",
        source: protocolDrop,
        renderer: protocolRenderer
      }
      {% endif %}
    ],
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
        //cleaveData(changes);

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
          data: {changes: isDirtyAr}
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
  });
  var $handsontable = $container.data('handsontable');

  function loadData() {
    $.ajax({
      url: '{{ url("samples/loadjson/") ~ step.id ~ '/' ~ project.id }}',
      dataType: 'json',
      type: 'POST',
      data: {}
    })
        .done(function (data) {
          //alert(data);
          //alert(location.href);
          $.each(data, function (key, value) {
            value["to_prep"] = "false";
            value["to_prep_protocol_name"] = '';
          });
          $handsontable.loadData(data);

          var changedColWidths = $defaultColWidths;
          //console.log(changedColWidths);

          //Set column width of SamplePropertyTypes to 0.1 (not shown) or '' (auto column width) if sample has SampleProperty.
          $('#sample_property_types').children('option').each(function (index, domEle) {
            var actualColWidthIdx = index + $samplePropertyTypesColumnsStartIdx;
            if ($(domEle).attr('selected')) {
              changedColWidths[actualColWidthIdx] = '';
            } else {
              changedColWidths[actualColWidthIdx] = 0.1;
            }
          });
          //Set session value for sample_property_types checked of checked/unchecked.
          //setOrderSessionVal('sample_property_types_checked', 0, $samplePropertyTypesChecked);
          //console.log($samplePropertyTypesChecked);

          //Change column width (Show checked sample_property_types column) on handsontable.
          $handsontable.updateSettings({'colWidths': changedColWidths});
          //console.log(changedColWidths);
        });
  }

  loadData(); // loading data at first.

  $toolbar.find('#save').click(function () {
    //alert("save! "+$handsontable.getData());
    $.ajax({
      url: '{{ url("trackerdetails/saveSamples") }}',
      data: {changes: isDirtyAr},
      dataType: 'text',
      type: 'POST'
    })
        .done(function (data, status, xhr) {
          //alert(status.toString());
          $console.text('Save success').removeClass().addClass("alert alert-success");
          $toolbar.find("#save").addClass("disabled");
          isDirtyAr = Object(); //Clear isDirtyAr

          loadData(); //Refresh with saved data.
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

  //var $samplePropertyTypesChecked = {};
  $('#sample_property_types').multiselect({
    /*
     * Show/Hide sample_property_types columns when checkbox is checked/unchecked.
     */
    onChange: function (element, checked) {

      var changedColWidths = $defaultColWidths;
      //console.log(changedColWidths);

      for (var i = 0; i < $samplePropertyTypesColumns.length; i++) {
        var actualColWidthIdx = i + $samplePropertyTypesColumnsStartIdx;
        if ($samplePropertyTypesColumns[i] == element.val()) {
          //console.log($samplePropertyTypesColumns[i] + " : " + element.val());
          if (checked == true) {
            changedColWidths[actualColWidthIdx] = "";
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
      //console.log(changedColWidths);
    }
  });

  /*
   * Set up search function.
   */
  $('#search_field').on('keyup', function (event) {
    var queryStr = event.target.value;
    var hot = $container.handsontable('getInstance');
    var queryResult = hot.search.query(queryStr);
    //console.log(queryResult);

    hot.render();
  });

});
</script>