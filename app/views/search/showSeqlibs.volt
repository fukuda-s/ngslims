{{ flashSession.output() }}
<div class="row">
  <div class="col-md-12">
    {# {{ dump(sample_property_types) }} #}
    <div class="panel panel-info">
      <div class="panel-heading" data-toggle="collapse" href="#seqlib_result_panel_body">
        <div class="panel-title">Seqlib Search Results</div>
      </div>
      <div id="seqlib_result_panel_body" class="panel-body collapse in">
        <div id="handsontable-showSeqlibs-body" style="overflow: scroll"></div>
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
var sampleNameAr = [];
var oligobarcodeAAr = [];
var oligobarcodeBAr = [];
var oligobarcodeADrop = [];
var oligobarcodeBDrop = [];
var protocolAr = [];
var protocolDrop = [];

$(document).ready(function () {

  function getProjectAr(data) {
    //console.log("stringified:"+JSON.stringify(data));
    var parseAr = JSON.parse(JSON.stringify(data));
    //alert(parseAr);
    $.each(parseAr, function (key, value) {
      //alert(value["id"]+" : "+value["name"]);
      var project_id = value["id"];
      var project_name = value["name"];
      var project_pi_name = value["pi_name"];
      var project_type_name = value["project_type_name"];
      projectAr[project_id] = project_name;
      projectPiAr[project_id] = project_pi_name;
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

  /*
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
   url: '
  {{ url("samples/loadjson/0/") }}',
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
   */

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

  $.ajax({
    url: '{{ url("protocols/loadjson") }}',
    dataType: 'json',
    type: 'POST',
    data: {
      type: '{{ type }}',
      step_id: '{{ step.id }}'
    }
  })
      .done(function (data) {
        //alert(data);
        //alert(location.href);
        getProtocolAr(data);
      });

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
    data: {}
  })
      .done(function (data, status, xhr) {
        getOligobarcodeAr(data);
      });

  /*
  var sampleNameRenderer = function (instance, td, row, col, prop, value, cellProperties) {
    Handsontable.TextCell.renderer.apply(this, arguments);
    $(td).text(sampleNameAr[value]);
  };
  */

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



  // Construct handsontable
  var $container = $("#handsontable-showSeqlibs-body");

  $container.handsontable({
    stretchH: 'all',
    height: 400,
    rowHeaders: false,
    columns: [
      { data: "sl.name", title: "Seqlib Name" },
      //{ data: "sl.sample_id, title: "Sample Name", editor: false },
      { data: "sl.protocol_id", title: "Protocol", editor: false, type: "dropdown", /* source: protocolDrop, */ renderer: protocolRenderer },
      { data: "sl.oligobarcodeA_id", title: "OligoBarcode A", editor: false, type: "dropdown", /* source: oligobarcodeADrop, */ renderer: oligobarcodeARenderer },
      { data: "sl.oligobarcodeB_id", title: "OligoBarcode B", editor: false, type: "dropdown", /* source: oligobarcodeBDrop, */ renderer: oligobarcodeBRenderer },
      { data: "sl.concentration", title: "Conc. (nmol/L)", editor: false, type: 'numeric', format: '0.000' },
      { data: "sl.stock_seqlib_volume", title: "Volume (uL)", editor: false, type: 'numeric', format: '0.00' },
      { data: "sl.fragment_size", title: "Fragment Size", editor: false, type: 'numeric' },
      { data: "sl.started_at", title: "Started Date", editor: false, type: 'date', dateFormat: 'yy-mm-dd' },
      { data: "sl.finished_at", title: "Finished Date", editor: false, type: 'date', dateFormat: 'yy-mm-dd' },
      { data: "ste.status", title: "Status", editor: false/*, type: 'dropdown', source: ['', 'Completed', 'In Progress', 'On Hold'] */ }
    ],
    minSpareCols: 0,
    minSpareRows: 0,
    contextMenu: false,
    columnSorting: true,
    manualColumnResize: true,
    manualRowResize: true,
    autoColumnSize: true,
    fixedColumnsLeft: 1,
    currentRowClassName: 'currentRow',
    autoWrapRow: true
  });
  var handsontable = $container.data('handsontable');

  function loadData() {
    $.ajax({
      url: '{{ url("seqlibs/loadjson") }}',
      dataType: 'json',
      type: 'POST',
      data: {
        query: '{{ query  }}'
      }
    })
        .done(function (data) {
          //alert(location.href);
          //console.log(data);
          $container.handsontable("loadData", data);
        });
  }

  loadData(); // loading data at first.

});
</script>