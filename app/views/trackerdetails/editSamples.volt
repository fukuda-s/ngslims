<!--
  ~ (The MIT License)
  ~
  ~ Copyright (c) 2014-2018 Genome Science Division, RCAST, Univ.Tokyo. <fukuda-s@genome.rcast.u-tokyo.ac.jp>
  ~
  ~ Permission is hereby granted, free of charge, to any person obtaining
  ~ a copy of this software and associated documentation files (the
  ~ 'Software'), to deal in the Software without restriction, including
  ~ without limitation the rights to use, copy, modify, merge, publish,
  ~ distribute, sublicense, and/or sell copies of the Software, and to
  ~ permit persons to whom the Software is furnished to do so, subject to
  ~ the following conditions:
  ~
  ~ The above copyright notice and this permission notice shall be
  ~ included in all copies or substantial portions of the Software.
  ~
  ~ THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
  ~ EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
  ~ MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
  ~ IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
  ~ CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
  ~ TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
  ~ SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
  -->

<div class="row">
  <div class="col-md-12">
    {{ partial('partials/trackerdetails-header') }}
    {% if type === 'SHOW' %}
      <div
          align="left">{{ link_to("trackerdetails/showTableSamples/" ~ project.id ~ "?pre_action" ~ previousAction, "<< Back to Sample Info", "class": "btn btn-primary") }}</div>
      <hr>
    {% endif %}
    {{ flashSession.output() }}
    {% include 'partials/handsontable-toolbar.volt' %}
    {# {{ dump(sample_property_types) }} #}
    <ul class="nav nav-tabs">
      <!--
      <li class="active">{{ link_to("trackerdetails/editSamples/" ~ type ~ '/' ~ step.id ~ '/' ~ project.id ~ '?pre_action=' ~ previousAction, "Samples") }}</li>
      -->
      <li class="active"><a href="#">Samples</a></li>
      {% if type === 'QC' or type === 'PREP' %}
        <li>{{ link_to("trackerdetails/editSeqlibs/" ~ type ~ '/' ~ step.id ~ '/' ~ project.id ~ '/' ~ previousStatus, "SeqLibs") }}</li>
      {% else %}
        <li>{{ link_to("trackerdetails/editSeqlibs/" ~ type ~ '/0/' ~ project.id ~ '/?pre_action=' ~ previousAction, "SeqLibs") }}</li>
      {% endif %}
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
              var taxonomy_id = value["taxonomy_id"];
              var organism_name = value["name"];
              organismAr[taxonomy_id] = organism_name;
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
              protocolDrop.push(protocol_name);
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

      function getSampleLocationAr(data) {
          //console.log("stringified:"+JSON.stringify(data));
          var parseAr = JSON.parse(JSON.stringify(data));
          //alert(parseAr);
          $.each(parseAr, function (key, value) {
              //alert(value["id"]+" : "+value["name"]);
              var sample_location_id = value["id"];
              var sample_location_name = value["name"];
              sampleLocationAr[sample_location_id] = sample_location_name;
              sampleLocationDrop.push(sample_location_name);
          });
      }

      $.getJSON(
          '{{ url("samplelocations/loadjson") }}',
          {},
          function (data, status, xhr) {
              getSampleLocationAr(data);
          }
      );

      (function (Handsontable) {

          function sampleTypeRenderer(instance, td, row, col, prop, value, cellProperties) {
              var escaped = Handsontable.helper.stringify(value);
              td.innerHTML = sampleTypeAr[escaped];

              return td;
          }

          Handsontable.renderers.registerRenderer('sampleTypeRenderer', sampleTypeRenderer);

          function organismRenderer(instance, td, row, col, prop, value, cellProperties) {
              var escaped = Handsontable.helper.stringify(value);
              td.innerHTML = organismAr[escaped];

              return td;
          }

          Handsontable.renderers.registerRenderer('organismRenderer', organismRenderer);

          function protocolRenderer(instance, td, row, col, prop, value, cellProperties) {
              var escaped = Handsontable.helper.stringify(value);
              var protocolStr = protocolAr[escaped];
              if (protocolStr !== undefined) {
                  td.innerHTML = protocolStr;
              } else {
                  td.innerHTML = escaped;
              }
              return td;
          }

          Handsontable.renderers.registerRenderer('protocolRenderer', protocolRenderer);

          function sampleLocationRenderer(instance, td, row, col, prop, value, cellProperties) {
              var escaped = Handsontable.helper.stringify(value);
              var sampleLocationStr = sampleLocationAr[escaped];
              if (sampleLocationStr !== undefined) {
                  td.innerHTML = sampleLocationStr;
              } else {
                  td.innerHTML = escaped;
              }
              return td;
          }

          Handsontable.renderers.registerRenderer('sampleLocationRenderer', sampleLocationRenderer);

      })(Handsontable);

    /*
     * Cleaved edited row from whole data of handsontable.
     */
      var cleavedData = Object();

    /*
     * Integrate 'changes' on handsontable, because editor can change same cell at several times.
     */
      var isDirtyAr = Object();

      function integrateIsDirtyAr(changes) {
          $.each(changes, function (key, value) {
              if (value) {
                  var rowNumToChange = value[0];
                  var columnToChange = value[1];
                  var valueChangeTo = value[3];
                  var sample_id = hot.getDataAtRowProp(rowNumToChange, 's.id');
                  if (!isDirtyAr[sample_id]) {
                      isDirtyAr[sample_id] = Object();
                  }
                  isDirtyAr[sample_id][columnToChange] = valueChangeTo; //Over write isDirtyAr with current changes.
              }
          });
          //console.log(isDirtyAr);
      }

      // Construct handsontable
      //var $container = $("#handsontable-editSamples-body");
      var $container = document.getElementById('handsontable-editSamples-body');
      var $console = $("#handsontable-console");
      var $toolbar = $("#handsontable-toolbar");
      var autosaveNotification = String();
      var $samplePropertyTypesColumns = [
        {% for sample_property_type in sample_property_types %}
          "sample_property_type_id_{{ sample_property_type.id }}",
        {% endfor %}
      ];
      var $defaultColWidths = ['', '', '', '', '', '', '', '', '', '', '', '', '', '', '', ''
        {% for sample_property_type in sample_property_types %}
        {% if sample_property_type.sample_count > 0 %}, ''
        {% else %}, 0.1
        {% endif %}
        {% endfor %}
        {% if type === 'PREP' %}, 80, 150
        {% endif %}
      ];

    /*
     * Setup columns number of not sample_property_types. This number used for setting of column width of sample_propery_types on loadData() function.
     * CAUTION: This number should be changed manually if the NOT sample_property_types column is added.
     */
      var $samplePropertyTypesColumnsStartIdx = 16; //@TODO First index number(begin by 0) of sample_property_types

    /*
     * Setting of Handsontable;
     */
      var hot = new Handsontable($container, {
          licenseKey: 'non-commercial-and-evaluation',
          stretchH: 'all',
          height: 500,
          rowHeaders: false,
          minSpareCols: 0,
          minSpareRows: 0,
          fillHandle: {
              autoInsertRow: false,
              direction: 'vertical'
          },
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
              {data: "s.id", title: "ID", type: 'numeric', editor: false},
              {data: "s.name", title: "Sample Name", editor: false},
              {
                  data: "s.sample_type_id",
                  title: "Sample Type",
                  editor: false,
                  renderer: 'sampleTypeRenderer'
              },
              {
                  data: "s.taxonomy_id",
                  title: "Organism",
                  editor: false,
                  renderer: 'organismRenderer'
              },
              {data: "s.qual_concentration", title: "Conc. (ng/uL)", type: 'numeric', format: '0.000'},
              {data: "s.qual_od260280", title: "A260/A280", type: 'numeric', format: '0.00'},
              {data: "s.qual_od260230", title: "A260/A230", type: 'numeric', format: '0.00'},
              {data: "s.qual_RIN", title: "RIN", type: 'numeric', format: '0.00'},
              {data: "s.qual_fragmentsize", title: "Fragment Size", type: 'numeric'},
              {data: "s.qual_nanodrop_conc", title: "Conc. (ng/uL) (NanoDrop)", type: 'numeric', format: '0.000'},
              {data: "s.qual_volume", title: "Volume (uL)", type: 'numeric', format: '0.00'},
              {data: "s.qual_amount", title: "Total (ng)", type: 'numeric', format: '0.00'},
              {data: "s.qual_date", title: "QC Date", type: 'date', dateFormat: 'YYYY-MM-DD'},
              {
                  data: "ste.status",
                  title: "Status",
                  //editor: "select",
                  //selectOptions: ['', 'Completed', 'In Progress', 'On Hold']
                  type: "dropdown",
                  source: ['', 'Completed', 'In Progress', 'On Hold']
              },
              {data: "s.barcode_number", title: "2D barcode"},
              {
                  data: "s.sample_location_id",
                  title: "Sample Repos.",
                  editor: "select",
                  selectOptions: sampleLocationDrop,
                  renderer: 'sampleLocationRenderer'
              },
            {% for sample_property_type in sample_property_types %}
              {
                  data: 'sample_property_types.{{ sample_property_type.id }}',
                  title: '{{ sample_property_type.name }}',
                  type: 'text'
              },
            {% endfor %}
            {% if type === 'PREP' %}
              {data: "prep.to_prep", title: "Create New SeqLib", type: 'checkbox'},
              {
                  data: "prep.to_prep_protocol_name",
                  title: "Protocol",
                  editor: "select",
                  selectOptions: protocolDrop,
                  renderer: 'protocolRenderer'
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

      function loadData() {
          $.ajax({
              url: '{{ url("samples/loadjson") }}',
              dataType: 'json',
              type: 'POST',
              data: {
                {% if not (status is empty) %}
                  status: '{{ status }}',
                {% endif %}
                {% if not (nuc_type is empty) %}
                  nucleotide_type: '{{ nuc_type }}',
                {% endif %}
                {% if type is 'QC' %}
                  step_id: {{ step.id }},
                {% elseif type is 'PICK' %}
                  type: '{{ type }}',
                {% endif %}
                  project_id: {{ project.id }}
              }
          })
              .done(function (data) {
                  //alert(data);
                  //alert(location.href);
                  $.each(data, function (key, value) {
                      value["to_prep"] = "false";
                      value["to_prep_protocol_name"] = '';
                  });
                  hot.loadData(data);

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
                  hot.updateSettings({'colWidths': changedColWidths});
                  //console.log(changedColWidths);
              });
      }

      loadData(); // loading data at first.

      $toolbar.find('#save').click(function () {
          //alert("save! "+hot.getData());
          $(".loading_icon").collapse('show');
          $.ajax({
              url: '{{ url("trackerdetails/saveSamples") }}',
              data: {changes: isDirtyAr},
              dataType: 'text',
              type: 'POST'
          })
              .always(function(){
                  $(".loading_icon").fadeIn();
              })
              .done(function (data, status, xhr) {
                  //alert(status.toString());
                  $console.text('Save success').removeClass().addClass("alert alert-success");
                  $toolbar.find("#save").addClass("disabled");
                  isDirtyAr = Object(); //Clear isDirtyAr
                  $(".loading_icon").fadeOut();

                  loadData(); //Refresh with saved data.
                  // Disable alert dialog when this page is saved.
                  $(window).off('beforeunload');
              })
              .fail(function (xhr, status, error) {
                  //alert(status.toString());
                  $(".loading_icon").fadeOut();
                  $console.text('Save error').removeClass().addClass("alert alert-danger");
              });
          $(".loading_icon").collapse('hide');
      });

      $toolbar.find('#undo').click(function () {
          // alert("undo! "+hot.isUndoAvailable()+"
          // "+hot.isRedoAvailable())
          hot.undo();
          // $console.text('Undo!');
          if (hot.isUndoAvailable()) {
              $toolbar.find("#undo").removeClass("disabled");
          } else {
              $toolbar.find("#undo").addClass("disabled");
          }

          if (hot.isRedoAvailable()) {
              $toolbar.find("#redo").removeClass("disabled");
          } else {
              $toolbar.find("#redo").addClass("disabled");
          }
      });

      $toolbar.find('#redo').click(function () {
          // alert("redo! "+hot.isUndoAvailable()+"
          // "+hot.isRedoAvailable());
          hot.redo();
          // $console.text('Redo!');
          if (hot.isUndoAvailable()) {
              $toolbar.find("#undo").removeClass("disabled");
          } else {
              $toolbar.find("#undo").addClass("disabled");
          }

          if (hot.isRedoAvailable()) {
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
              hot.updateSettings({'colWidths': changedColWidths});
              //console.log(changedColWidths);
          }
      });

    /*
     * Set up search function.
     */
      var searchFiled = document.getElementById('search_field');
      Handsontable.dom.addEvent(searchFiled, 'keyup', function (event) {
          var queryResult = hot.search.query(this.value);

          console.log(queryResult);
          hot.render();
      });

  });
</script>