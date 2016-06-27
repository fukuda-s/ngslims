<div class="row">
  <div class="col-md-12">
    {{ partial('partials/trackerdetails-header') }}
    {% if type === 'SHOW' %}
      <div
          align="left">{{ link_to("trackerdetails/showTableSamples/" ~ project.id ~ "?pre_action=" ~ previousAction, "<< Back to Sample Info", "class": "btn btn-primary") }}</div>
      <hr>
    {% endif %}
    {{ flashSession.output() }}
    {% include 'partials/handsontable-toolbar.volt' %}
    <ul class="nav nav-tabs">
      {% if type === 'PREP' %}
        <li>{{ link_to("trackerdetails/editSamples/" ~ type ~ '/' ~ step.id ~  '/' ~ project.id ~ '?nuc_type=' ~ step.nucleotide_type ~ '&pre_status=' ~ status, "Samples") }}</li>
      {% else %}
        <li>{{ link_to("trackerdetails/editSamples/" ~ type ~ '/' ~ step.id ~ '/' ~ project.id ~ '?pre_action=' ~ previousAction, "Samples") }}</li>
      {% endif %}
      <li class="active"><a href="#">SeqLibs</a></li>
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
        var sample_id = value["s"]["id"];
        var sample_name = value["s"]["name"];
        sampleNameAr[sample_id] = sample_name;
      });
    }

    $.ajax({
          url: '{{ url("samples/loadjson") }}',
          dataType: 'json',
          type: 'POST',
          data: {type: '{{ type }}', project_id: {{ project.id }}}
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
        protocolDrop.push(protocol_name);
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
          url: '{{ url("oligobarcodes/loadjson/") ~ step.id }}',
          dataType: "json",
          type: "POST",
          data: {}
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
          var seqlib_id = rowData[0];
          if (!isDirtyAr[seqlib_id]) {
            isDirtyAr[seqlib_id] = Object();
          }
          isDirtyAr[seqlib_id][columnToChange] = valueChangeTo; //Over write isDirtyAr with current changes.
        }
      });
      //console.log(isDirtyAr);
    }

    // Construct handsontable
    //var $container = $("#handsontable-editSeqlibs-body");
    var $container = document.getElementById('handsontable-editSeqlibs-body');
    var $console = $("#handsontable-console");
    var $toolbar = $("#handsontable-toolbar");
    var autosaveNotification = String();

    //$container.handsontable({
    var hot = new Handsontable($container, {
      stretchH: 'all',
      height: 500,
      rowHeaders: false,
      minSpareCols: 0,
      minSpareRows: 0,
      contextMenu: false,
      columnSorting: true,
      manualColumnResize: true,
      manualRowResize: true,
      autoColumnSize: true,
      fixedColumnsLeft: 2,
      currentRowClassName: 'currentRow',
      autoWrapRow: true,
      search: true,
      columns: [
        {data: "sl.id", title: "Seqlib ID", editor: false, type: 'numeric'},
        {data: "sl.name", title: "Seqlib Name"},
        {data: "sl.sample_id", title: "Sample Name", editor: false, renderer: sampleNameRenderer},
        {
          data: "sl.protocol_id",
          title: "Protocol",
          editor: "select",
          selectOptions: protocolDrop,
          renderer: protocolRenderer
        },
        {
          data: "sl.oligobarcodeA_id",
          title: "OligoBarcode A",
          //editor: "select",
          //selectOptions: oligobarcodeADrop,
          editor: "dropdown",
          source: oligobarcodeADrop,
          renderer: oligobarcodeARenderer
        },
        {
          data: "sl.oligobarcodeB_id",
          title: "OligoBarcode B",
          //editor: "select",
          //selectOptions: oligobarcodeBDrop,
          editor: "dropdown",
          source: oligobarcodeBDrop,
          renderer: oligobarcodeBRenderer
        },
        {data: "sl.concentration", title: "Conc. (nmol/L)", type: 'numeric', format: '0.000'},
        {data: "sl.stock_seqlib_volume", title: "Volume (uL)", type: 'numeric', format: '0.00'},
        {data: "sl.fragment_size", title: "Fragment Size", type: 'numeric'},
        {
          data: "sl.started_at",
          title: "Started Date",
          type: 'date',
          dateFormat: 'YYYY-MM-DD',
          correctFormat: true
        },
        {
          data: "sl.finished_at",
          title: "Finished Date",
          type: 'date',
          dateFormat: 'YYYY-MM-DD',
          correctFormat: true
        },
        {
          data: "ste.status",
          title: "Status",
          //editor: "select",
          //selectOptions: ['', 'Completed', 'In Progress', 'On Hold']
          type: "dropdown",
          source: ['', 'Completed', 'In Progress', 'On Hold']
        }
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

          // Show alert dialog when this page moved before save.
          $(window).on('beforeunload', function () {
            return 'CAUTION! You have not yet saved. Are you sure you want to leave?';
          });
        }

        if ($('#handsontable-autosave').find('input').is(':checked')) {
          clearTimeout(autosaveNotification);
          $.ajax({
                url: '{{ url("trackerdetails/saveSeqlibs") }}',
                dataType: "json",
                type: "POST",
                data: {changes: isDirtyAr} // returns "data" as all data and "changes" as changed data
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
      afterSelectionByProp: function (r, p, r2, c2) {
        //console.log(p);
        if (p === 'sl.oligobarcodeA_id' || p === 'sl.oligobarcodeB_id') {
          var protocol_id = $handsontable.getDataAtRowProp(r, 'sl.protocol_id').toString();
          $.ajax({
                url: '{{ url("oligobarcodes/loadjson/") }}',
                dataType: "json",
                type: "POST",
                data: {protocol_id: protocol_id}
              })
              .done(function (data, status, xhr) {
                getOligobarcodeAr(data);
              });

          //console.log('protocol_id: ' + protocol_id);
        }
      }
    });
    //var $handsontable = $container.data('handsontable');
    var $handsontable = hot;

    function loadData() {
      $.ajax({
            url: '{{ url("seqlibs/loadjson") }}',
            dataType: 'json',
            type: 'POST',
            data: {
              {% if not (type is empty) %}
              type: '{{ type }}',
              {% endif %}
              {% if not (status is empty) %}
              status: '{{ status }}',
              {% endif %}
              {% if type is 'PREP' %}
              step_id: {{ step.id }},
              {% endif %}
              project_id: {{ project.id }}
            }
          })
          .done(function (data) {
            //alert(data);
            //alert(location.href);
            //console.log(data);
            //$container.handsontable("loadData", data);
            $handsontable.loadData(data);
          });
    }

    loadData(); // loading data at first.

    $toolbar.find('#save').click(function () {
      //alert("save! "+handsontable.getData());
      $.ajax({
            url: '{{ url("trackerdetails/saveSeqlibs") }}',
            data: {changes: isDirtyAr}, // returns all cells
            dataType: 'text',
            type: 'POST'
          })
          .done(function () {
            //alert(status.toString());
            $console.text('Save success').removeClass().addClass("alert alert-success");
            $toolbar.find("#save").addClass("disabled");
            isDirtyAr = Object(); //Clear isDirtyAr

            loadData(); //Refresh with saved data.
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
      // alert("redo! "+handsontable.isUndoAvailable()+"
      // "+handsontable.isRedoAvailable());
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