{{ flashSession.output() }}
<div class="row">
  <div class="col-md-12">
    {{ partial('partials/trackerdetails-header') }}
    <hr>
    {% include 'partials/handsontable-toolbar.volt' %}
    <ul class="nav nav-tabs">
      <li>{{ link_to("trackerdetails/editSamples/" ~ type ~ '/' ~ step.id ~ '/' ~ project.id, "Samples") }}</li>
      <li class="active">{{ link_to("trackerdetails/editSeqlibs/" ~ type ~ '/' ~ step.id ~ '/' ~ project.id, "SeqLibs") }}</li>
      {% if type !== 'PREP' %}
        <li>{{ link_to("trackerdetails/editSeqlanes/" ~ type ~ '/' ~ step.id ~ '/' ~ project.id, "SeqLanes") }}</li>
      {% endif %}
      <button id="handsontable-size-ctl" type="button" class="btn btn-default pull-right">
        <span class="fa fa-expand"></span>
      </button>
    </ul>
    <div id="handsontable-editSeqlibs-body" style="overflow: scroll"></div>
  </div>
</div>
<script>
/*
 * Construct Handsontable
 */
// Make handsontable renderer and dropdown lists
var sampleNameAr = [];
var oligobarcodeAAr = [];
var oligobarcodeBAr = [];
var oligobarcodeADrop = [];
var oligobarcodeBDrop = [];
var protocolAr = [];
var protocolDrop = [];

$(document).ready(function () {

  function getSampleNameAr(data) {
    //console.log("stringified:"+JSON.stringify(data));
    var parseAr = JSON.parse(JSON.stringify(data));
    //alert(parseAr);
    $.each(parseAr, function (key, value) {
      //alert(value["id"]+" : "+value["name"]);
      var sample_id = value["id"];
      var sample_name = value["name"];
      sampleNameAr[sample_id] = sample_name;
    });
  }

  $.ajax({
    url: '{{ url("samples/loadjson/0/") ~ project.id }}',
    dataType: 'json',
    type: 'POST',
    data: {
    }
  })
      .done(function (data) {
        //alert(data);
        //alert(location.href);
        getSampleNameAr(data);
      });

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

  function getOligobarcodeAr(data) {
    //console.log("stringified:"+JSON.stringify(data));
    var parseAr = JSON.parse(JSON.stringify(data));
    //alert(parseAr);
    oligobarcodeAAr.length = 0;
    oligobarcodeADrop.length = 0;
    oligobarcodeBAr.length = 0;
    oligobarcodeBDrop.length = 0;

    oligobarcodeADrop.push(''); //Add Blank for first line on select
    oligobarcodeBDrop.push(''); //Add Blank for first line on select
    $.each(parseAr, function (key, value) {
      //alert(value["id"]+" : "+value["name"]);
      var oligobarcode_id = value["id"];
      var oligobarcode_name = value["name"];
      var oligobarcode_seq = value["barcode_seq"];
      var is_oligobarcodeB = value["is_oligobarcodeB"];
      if (is_oligobarcodeB !== 'Y') {
        oligobarcodeAAr[oligobarcode_id] = oligobarcode_name + " : " + oligobarcode_seq;
        oligobarcodeADrop.push(oligobarcode_name + " : " + oligobarcode_seq);
      } else {
        oligobarcodeBAr[oligobarcode_id] = oligobarcode_name + " : " + oligobarcode_seq;
        oligobarcodeBDrop.push(oligobarcode_name + " : " + oligobarcode_seq);
      }
    });
  }

  $.ajax({
    url: '{{ url("oligobarcodes/loadjson/") }}',
    dataType: "json",
    type: "POST",
    data: { protocol_id: 0 }
  })
      .done(function (data, status, xhr) {
        getOligobarcodeAr(data);
      });

  var sampleNameRenderer = function (instance, td, row, col, prop, value, cellProperties) {
    Handsontable.TextCell.renderer.apply(this, arguments);
    $(td).text(sampleNameAr[value]);
  };

  var oligobarcodeARenderer = function (instance, td, row, col, prop, value, cellProperties) {
    Handsontable.TextCell.renderer.apply(this, arguments);
    $(td).text(oligobarcodeAAr[value]);
  };

  var oligobarcodeBRenderer = function (instance, td, row, col, prop, value, cellProperties) {
    Handsontable.TextCell.renderer.apply(this, arguments);
    $(td).text(oligobarcodeBAr[value]);
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
  var $container = $("#handsontable-editSeqlibs-body");
  var $console = $("#handsontable-console");
  var $toolbar = $("#handsontable-toolbar");
  var autosaveNotification = String();
  $container.handsontable({
    stretchH: 'all',
    rowHeaders: true,
    colWidths: [80, 50, 150, 80, 80, , , , 90, 90, 90],
    columns: [
      { data: "sl.name", title: "Seqlib Name" },
      { data: "sl.sample_id", title: "Sample Name", readOnly: true, renderer: sampleNameRenderer },
      { data: "sl.protocol_id", title: "Protocol", type: "dropdown", source: protocolDrop, renderer: protocolRenderer },
      { data: "sl.oligobarcodeA_id", title: "OligoBarcode A", type: "dropdown", source: oligobarcodeADrop, renderer: oligobarcodeARenderer },
      { data: "sl.oligobarcodeB_id", title: "OligoBarcode B", type: "dropdown", source: oligobarcodeBDrop, renderer: oligobarcodeBRenderer },
      { data: "sl.concentration", title: "Conc. (nmol/L)", type: 'numeric', format: '0.000' },
      { data: "sl.stock_seqlib_volume", title: "Volume (uL)", type: 'numeric', format: '0.00' },
      { data: "sl.fragment_size", title: "Fragment Size", type: 'numeric' },
      { data: "sl.started_at", title: "Started Date", type: 'date', dateFormat: 'yy-mm-dd' },
      { data: "sl.finished_at", title: "Finished Date", type: 'date', dateFormat: 'yy-mm-dd' },
      { data: "se.status", title: "Status", type: 'dropdown', source: ['', 'Completed', 'In Progress', 'On Hold'] }
    ],
    minSpareCols: 0,
    minSpareRows: 0,
    contextMenu: true,
    columnSorting: true,
    manualColumnResize: true,
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
        $(window).on('beforeunload', function() {
          return 'CAUTION! You have not yet saved. Are you sure you want to leave?';
        });
      }

      if ($('#handsontable-autosave').find('input').is(':checked')) {
        clearTimeout(autosaveNotification);
        $.ajax({
          url: '{{ url("trackerdetails/saveSeqlibs") }}',
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

    },
    afterSelectionEnd: function (r, c, r2, c2) {
      if (c >= 3 && c <= 4) {
        var protocol_id = handsontable.getData(r, 2, r, 2).toString();
        $.ajax({
          url: '{{ url("oligobarcodes/loadjson/") }}',
          dataType: "json",
          type: "POST",
          data: { protocol_id: protocol_id }
        })
            .done(function (data, status, xhr) {
              getOligobarcodeAr(data);
            });

        console.log(protocol_id);
      }
    }
  });
  var handsontable = $container.data('handsontable');

  function loadData() {
    $.ajax({
      url: '{{ url("seqlibs/loadjson/") ~ step.id ~ '/' ~ project.id }}',
      dataType: 'json',
      type: 'POST',
      data: {
      }
    })
        .done(function (data) {
          //alert(data);
          //alert(location.href);
          //console.log(data);
          $container.handsontable("loadData", data);
        });
  }

  loadData(); // loading data at first.

  $toolbar.find('#save').click(function () {
    //alert("save! "+handsontable.getData());
    $.ajax({
      url: '{{ url("trackerdetails/saveSeqlibs") }}',
      data: {data: cleaveData(isDirtyAr), changes: isDirtyAr }, // returns all cells
      dataType: 'text',
      type: 'POST'
    })
        .done(function () {
          //alert(status.toString());
          $console.text('Save success').removeClass().addClass("alert alert-success");
          $toolbar.find("#save").addClass("disabled");
          isDirtyAr = Object(); //Clear isDirtyAr

          // Disable alert dialog when this page is saved.
          $(window).off('beforeunload');
        })
        .fail(function (error) {
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

});
</script>