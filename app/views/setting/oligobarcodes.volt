<div class="row">
  <div class="col-md-12">
    <ol class="breadcrumb">
      <li>{{ link_to('setting', 'Setting') }}</li>
      <li class="active">Oligobarcodes</li>
    </ol>
    {{ flashSession.output() }}

    {% include 'partials/handsontable-toolbar.volt' %}

    <div id="handsontable-editOligobarcodes-body" style="overflow: scroll"></div>
  </div>
</div>
<script>
  /*
   * Construct Handsontable
   */
  // Make handsontable renderer and dropdown lists
  var oligobarcodeSchemeAr = [];
  var oligobarcodeSchemeDrop = [];

  $(document).ready(function () {

      function getOligobarcodeSchemeAr(data) {
          //console.log("stringified:"+JSON.stringify(data));
          var parseAr = JSON.parse(JSON.stringify(data));
          //alert(parseAr);
          $.each(parseAr, function (key, value) {
              //alert(value["id"]+" : "+value["name"]);
              var oligobarcode_scheme_id = value["id"];
              var oligobarcode_scheme_name = value["name"];
              oligobarcodeSchemeAr[oligobarcode_scheme_id] = oligobarcode_scheme_name;
              oligobarcodeSchemeDrop.push(value["name"]);
          });
      }

      $.getJSON(
          '{{ url("oligobarcodeschemes/loadjson/") }}',
          {},
          function (data, status, xhr) {
              getOligobarcodeSchemeAr(data);
          }
      );

      var barcodeSeqRenderer = function (instance, td, row, col, prop, value, cellProperties) {
          Handsontable.TextCell.renderer.apply(this, arguments);
          td.className = "barcode-seq";
      };

      var oligobarcodeSchemeRenderer = function (instance, td, row, col, prop, value, cellProperties) {
          Handsontable.TextCell.renderer.apply(this, arguments);
          $(td).text(oligobarcodeSchemeAr[value]);
      };

      var activeRenderer = function (instance, td, row, col, prop, value, cellProperties) {
          Handsontable.TextCell.renderer.apply(this, arguments);
          if (value == 'N') {
              $(td).parent('tr').addClass("bg-inactive");
          }
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
                  var oligobarcode_id = rowData[0];
                  if(!oligobarcode_id){
                      oligobarcode_id = 10000000 + rowNumToChange;
                  }
                  if (!isDirtyAr[oligobarcode_id]) {
                      isDirtyAr[oligobarcode_id] = Object();
                  }
                  isDirtyAr[oligobarcode_id][columnToChange] = valueChangeTo; //Over write isDirtyAr with current changes.
              }
          });
          //console.log(isDirtyAr);
          //console.log(changes);
      }

      // Construct handsontable
      //var $container = $("#handsontable-editSeqlibs-body");
      var $container = document.getElementById('handsontable-editOligobarcodes-body');
      var $console = $("#handsontable-console");
      var $toolbar = $("#handsontable-toolbar");
      var autosaveNotification = String();

      //$container.handsontable({
      var hot = new Handsontable($container, {
          stretchH: 'all',
          height: 500,
          rowHeaders: false,
          minSpareCols: 0,
          minSpareRows: 1,
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
              {data: "id", title: "ID", editor: false, type: 'numeric'},
              {data: "name", title: "Barcode Name"},
              {
                  data: "barcode_seq",
                  title: "Barcode Sequence",
                  renderer: barcodeSeqRenderer
              },
              {
                  data: "oligobarcode_scheme_id",
                  title: "Oligobarcode Scheme",
                  //editor: "select",
                  //selectOptions: oligobarcodeSchemeDrop,
                  editor: "dropdown",
                  source: oligobarcodeSchemeDrop,
                  renderer: oligobarcodeSchemeRenderer
              },
              {data: "sort_order", title: "Sort Order", type: 'numeric', format: '0'},
              {
                  data: "active",
                  title: "Active",
                  type: "dropdown",
                  source: ['Y', 'N'],
                  renderer: activeRenderer
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
                      url: '{{ url("setting/Oligobarcodes") }}',
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

          }
      });
      //var $handsontable = $container.data('handsontable');
      var $handsontable = hot;

      function loadData() {
          $.ajax({
              url: '{{ url("oligobarcodes/loadjson") }}', //0 is step_id (not indicate in this case.
              dataType: 'json',
              type: 'POST'
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
              url: '{{ url("setting/oligobarcodes") }}',
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