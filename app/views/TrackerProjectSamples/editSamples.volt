<div class="row">
  <div class="col-md-12">
    {{ partial('partials/trackerProjectSamples-header') }}
    <hr>
    {{ flashSession.output() }}
    {% include 'partials/handsontable-toolbar.volt' %}
    <ul class="nav nav-tabs">
      <li class="active">{{ link_to("trackerProjectSamples/editSamples/" ~ type ~ '/' ~ step.id ~ '/' ~ project.id, "Samples") }}</li>
      {% if type !== 'QC' %}
        <li>{{ link_to("trackerProjectSamples/editSeqlibs/" ~ type ~ '/' ~ step.id ~ '/' ~ project.id, "SeqLibs") }}</li>
        {% if type !== 'PREP' %}
          <li>{{ link_to("trackerProjectSamples/editSeqlanes/" ~ type ~ '/' ~ step.id ~ '/' ~ project.id, "SeqLanes") }}</li>
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

  // Cleaved edited row from whole data of handsontable.
  function cleaveData(changes) {
    var data = handsontable.getData();
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

  // Integrate 'changes' on handsontable, because editor can change same cell at several times.
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

  // Construct handsontable
  var $container = $("#handsontable-editSamples-body");
  var $console = $("#handsontable-console");
  var $toolbar = $("#handsontable-toolbar");
  var autosaveNotification = String();
  $container.handsontable({
    stretchH: 'all',
    rowHeaders: true,
    minSpareCols: 0,
    minSpareRows: 0,
    contextMenu: true,
    columnSorting: true,
    manualColumnResize: true,
    colWidths: [120, , , , , , , , , , , 150, , 150],
    columns: [
      { data: "name", title: "Sample Name", readOnly: true },
      { data: "sample_type_id", title: "Sample Type", readOnly: true, renderer: sampleTypeRenderer },
      { data: "organism_id", title: "Organism", readOnly: true, renderer: organismRenderer, source: organismRenderer },
      { data: "qual_concentration", title: "Conc. (ng/uL)", type: 'numeric', format: '0.000' },
      { data: "qual_od260280", title: "A260/A280", type: 'numeric', format: '0.00' },
      { data: "qual_od260230", title: "A260/A230", type: 'numeric', format: '0.00' },
      { data: "qual_RIN", title: "RIN", type: 'numeric', format: '0.00' },
      { data: "qual_fragmentsize", title: "Fragment Size", type: 'numeric' },
      { data: "qual_nanodrop_conc", title: "Conc. (ng/uL) (NanoDrop)", type: 'numeric', format: '0.000' },
      { data: "qual_volume", title: "Volume (uL)", type: 'numeric', format: '0.00' },
      { data: "qual_amount", data: 0, title: "Total (ng)", type: 'numeric', format: '0.00' },
      { data: "qual_date", title: "QC Date", type: 'date', dateFormat: 'yy-mm-dd' }
      {% if type === 'PREP' %}
      ,
      { data: "to_prep", title: "Create New SeqLib", type: 'checkbox' },
      { data: "to_prep_protocol_name", title: "Protocol", type: "dropdown", source: protocolDrop, renderer: protocolRenderer }
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
      }

      //console.log(JSON.stringify(handsontable.getData()));

      if ($('#handsontable-autosave').find('input').is(':checked')) {
        clearTimeout(autosaveNotification);
        $.ajax({
          url: '{{ url("trackerProjectSamples/saveSamples") }}',
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
  });
  var handsontable = $container.data('handsontable');

  function loadData() {
    $.ajax({
      url: '{{ url("samples/loadjson/") ~ step.id ~ '/' ~ project.id }}',
      dataType: 'json',
      type: 'POST',
      data: {
      }
    })
        .done(function (data) {
          //alert(data);
          //alert(location.href);
          $.each(data, function (key, value) {
            value["to_prep"] = "false";
            value["to_prep_protocol_name"] = '';
          });
          $container.handsontable("loadData", data);
        });
  }

  loadData(); // loading data at first.

  $toolbar.find('#save').click(function () {
    //alert("save! "+handsontable.getData());
    $.ajax({
      url: '{{ url("trackerProjectSamples/saveSamples") }}',
      data: {data: cleaveData(isDirtyAr), changes: isDirtyAr }, // returns all cells
      dataType: 'text',
      type: 'POST'
    })
        .done(function (data, status, xhr) {
          //alert(status.toString());
          $console.text('Save success').removeClass().addClass("alert alert-success");
          $toolbar.find("#save").addClass("disabled");
          isDirtyAr = Object(); //Clear isDirtyAr
        })
        .fail(function (xhr, status, error) {
          //alert(status.toString());
          $console.text('Save error').removeClass().addClass("alert alert-danger");
        });
  });

  $toolbar.find('#undo').click(function () {
    // alert("undo! "+handsontable.isUndoAvailable()+"
    // "+handsontable.isRedoAvailable())
    handsontable.undo();
    // $console.text('Undo!');
    if (handsontable.isUndoAvailable()) {
      $toolbar.find("#undo").removeClass("disabled");
    } else {
      $toolbar.find("#undo").addClass("disabled");
    }

    if (handsontable.isRedoAvailable()) {
      $toolbar.find("#redo").removeClass("disabled");
    } else {
      $toolbar.find("#redo").addClass("disabled");
    }
  });

  $toolbar.find('#redo').click(function () {
    // alert("redo! "+handsontable.isUndoAvailable()+"
    // "+handsontable.isRedoAvailable());
    handsontable.redo();
    // $console.text('Redo!');
    if (handsontable.isUndoAvailable()) {
      $toolbar.find("#undo").removeClass("disabled");
    } else {
      $toolbar.find("#undo").addClass("disabled");
    }

    if (handsontable.isRedoAvailable()) {
      $toolbar.find("#redo").removeClass("disabled");
    } else {
      $toolbar.find("#redo").addClass("disabled");
    }
  });

  $toolbar.find('#clear').click(function () {
    loadData();
    $toolbar.find("#save, #undo, #redo, #clear").addClass("disabled");
    $console.text('All changes is discarded').removeClass().addClass("alert alert-success");
  });


  $('#handsontable-autosave').find('input').click(function () {
    if ($(this).is(':checked')) {
      $console.text('Changes will be autosaved').removeClass().addClass("alert alert-success");
    }
    else {
      $console.text('Changes will not be autosaved').removeClass().addClass("alert alert-warning");
    }
  });

});
</script>