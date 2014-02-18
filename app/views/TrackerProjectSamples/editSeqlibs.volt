<div class="row">
  <div class="col-md-12">
    {{ partial('partials/trackerProjectSamples-header') }}
    <hr>
    {% include 'partials/handsontable-toolbar.volt' %}
    <ul class="nav nav-tabs">
      <li>{{ link_to("trackerProjectSamples/editSamples/" ~ type ~ '/' ~ step.id ~ '/' ~ project.id, "Samples") }}</li>
      <li class="active">{{ link_to("trackerProjectSamples/editSeqlibs/" ~ type ~ '/' ~ step.id ~ '/' ~ project.id, "SeqLibs") }}</li>
      <li>{{ link_to("trackerProjectSamples/editSeqlanes/" ~ type ~ '/' ~ step.id ~ '/' ~ project.id, "SeqLanes") }}</li>
      <button id="handsontable-size-ctl" type="button" class="btn btn-default pull-right">
        <span class="fa fa-expand"></span>
      </button>
    </ul>
    <div id="handsontable-editSeqlibs-body" style="height: 400px; overflow: auto"></div>
  </div>
</div>
<script>
/*
 * Construct Handsontable
 */
// Make handsontable renderer and dropdown lists
var sampleNameAr = [];
var oligobarcodeAr = [];
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
    url: '{{ url("samples/loadjson/") ~ project.id }}',
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
    $.each(parseAr, function (key, value) {
      //alert(value["id"]+" : "+value["name"]);
      var oligobarcode_id = value["id"];
      var oligobarcode_name = value["name"];
      var oligobarcode_seq = value["barcode_seq"];
      oligobarcodeAr[oligobarcode_id] = oligobarcode_name + " " + oligobarcode_seq;
    });
  }

  $.getJSON(
      '{{ url("oligobarcodes/loadjson") }}',
      {},
      function (data, status, xhr) {
        getOligobarcodeAr(data);
      }
  );

});

$(document).ready(function () {

  var sampleNameRenderer = function (instance, td, row, col, prop, value, cellProperties) {
    Handsontable.TextCell.renderer.apply(this, arguments);
    $(td).text(sampleNameAr[value]);
  };

  var oligobarcodeRenderer = function (instance, td, row, col, prop, value, cellProperties) {
    Handsontable.TextCell.renderer.apply(this, arguments);
    $(td).text(oligobarcodeAr[value]);
  };

  var protocolRenderer = function (instance, td, row, col, prop, value, cellProperties) {
    Handsontable.TextCell.renderer.apply(this, arguments);
    $(td).text(protocolAr[value]);
  };


  // Construct handsontable
  var $container = $("#handsontable-editSeqlibs-body");
  var $console = $("#handsontable-console");
  var $toolbar = $("#handsontable-toolbar");
  var autosaveNotification = String();
  var isDirtyAr = [];
  $container.handsontable({
    stretchH: 'all',
    rowHeaders: true,
    colWidths: [80, 50, 150, 80, 80, , , , 90, 90],
    columns: [
      { data: "name", title: "Seqlib Name", readOnly: true },
      { data: "sample_id", title: "Sample Name", readOnly: true, renderer: sampleNameRenderer },
      { data: "protocol_id", title: "Protocol", type: "dropdown", source: protocolDrop, renderer: protocolRenderer },
      { data: "oligobarcodeA_id", title: "OligoBarcode A", renderer: oligobarcodeRenderer },
      { data: "oligobarcodeB_id", title: "OligoBarcode B", renderer: oligobarcodeRenderer },
      { data: "concentration", title: "Conc. (ng/uL)", type: 'numeric', format: '0.000' },
      { data: "stock_seqlib_volume", title: "Volume (uL)", type: 'numeric', format: '0.00' },
      { data: "fragmentsize", title: "Fragment Size", type: 'numeric' },
      { data: "started_at", title: "Started Date", type: 'date', dateFormat: 'yy-mm-dd' },
      { data: "finished_at", title: "Finished Date", type: 'date', dateFormat: 'yy-mm-dd' }
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
        $.each(changes, function (key, value) {
          isDirtyAr.push(value);
        });
      }

      if ($('#handsontable-autosave').find('input').is(':checked')) {
        clearTimeout(autosaveNotification);
        $.ajax({
          url: '{{ url("trackerProjectSamples/saveSeqlibs") }}',
          dataType: "json",
          type: "POST",
          data: {data: handsontable.getData(), changes: changes} // returns "data" as all data and "changes" as changed data
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
      url: '{{ url("seqlibs/loadjson/") ~ project.id }}',
      dataType: 'json',
      type: 'POST',
      data: {
      }
    })
        .done(function (data) {
          //alert(data);
          //alert(location.href);
          $container.handsontable("loadData", data);
        });
  }

  loadData(); // loading data at first.

  $toolbar.find('#save').click(function () {
    //alert("save! "+handsontable.getData());
    $.ajax({
      url: '{{ url("trackerProjectSamples/saveSeqlibs") }}',
      data: {data: handsontable.getData(), changes: isDirtyAr }, // returns all cells
      dataType: 'json',
      type: 'POST'
    })
        .done(function () {
          //alert(status.toString());
          $console.text('Save success').removeClass().addClass("alert alert-success");
          $toolbar.find("#save").addClass("disabled");
          isDirtyAr.length = 0;
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