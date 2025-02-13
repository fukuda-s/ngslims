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
    <div
        align="left">{{ link_to("trackerdetails/showTableSamples/" ~ project.id ~ "?pre_action=" ~ previousAction, "<< Back to Sample Info", "class": "btn btn-primary") }}</div>
    <hr>
    {% include 'partials/handsontable-toolbar.volt' %}
    <ul class="nav nav-tabs">
      <li>{{ link_to("trackerdetails/editSamples/" ~ type ~ '/' ~ step.id ~ '/' ~ project.id ~ '?pre_action=' ~ previousAction, "Samples") }}</li>
      <li>{{ link_to("trackerdetails/editSeqlibs/" ~ type ~ '/' ~ step.id ~ '/' ~ project.id ~ '?pre_action=' ~ previousAction, "SeqLibs") }}</li>
      <li class="active">{{ link_to("trackerdetails/editSeqlanes/" ~ type ~ '/' ~ step.id ~ '/' ~ project.id ~ '?pre_action=' ~ previousAction, "SeqLanes") }}</li>
    </ul>
    <div id="handsontable-editSeqlanes-body" style="height: 400px; overflow: auto"></div>
  </div>
</div>
<script>
/*
 * Construct Handsontable
 */
// Make handsontable renderer and dropdown lists
var sampleTypeAr = [];
var organismAr = [];

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

});

$(document).ready(function () {

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

  // Construct handsontable
  var $container = $("#handsontable-editSeqlanes-body");
  var $console = $("#handsontable-console");
  var $toolbar = $("#handsontable-toolbar");
  var autosaveNotification = String();
  var isDirtyAr = [];
  $container.handsontable({
    licenseKey: 'non-commercial-and-evaluation',
    stretchH: 'all',
    rowHeaders: true,
    columns: [
      { data: "name", title: "Sample Name", editor: false },
      { data: "sample_type_id", title: "Sample Type", editor: false, renderer: sampleTypeRenderer },
      { data: "taxonomy_id", title: "Organism", editor: false, renderer: organismRenderer, source: organismRenderer },
      { data: "qual_concentration", title: "Conc. (ng/uL)", type: 'numeric', format: '0.000' },
      { data: "qual_od260280", title: "A260/A280", type: 'numeric', format: '0.00' },
      { data: "qual_od260230", title: "A260/A230", type: 'numeric', format: '0.00' },
      { data: "qual_RIN", title: "RIN", type: 'numeric', format: '0.00' },
      { data: "qual_fragmentsize", title: "Fragment Size (From)", type: 'numeric' },
      { data: "qual_nanodrop_conc", title: "Conc. (ng/uL) (NanoDrop)", type: 'numeric', format: '0.000' },
      { data: "qual_volume", title: "Volume (uL)", type: 'numeric', format: '0.00' },
      { data: "qual_amount", data: 0, title: "Total (ng)", type: 'numeric', format: '0.00' },
      { data: "qual_date", title: "QC Date", type: 'date', dateFormat: 'yy-mm-dd' }
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

        // Show alert dialog when this page moved before save.
        $(window).on('beforeunload', function() {
          return 'CAUTION! You have not yet saved. Are you sure you want to leave?';
        });
      }

      if ($('#handsontable-autosave').find('input').is(':checked')) {
        clearTimeout(autosaveNotification);
        $.ajax({
          url: '{{ url("trackerdetails/saveSamples") }}',
          dataType: "json",
          type: "POST",
          data: {data: handsontable.getSourceData(), changes: changes} // returns "data" as all data and "changes" as changed data
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
      url: '{{ url("samples/loadjson/") ~ project.id }}',
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
      url: '{{ url("trackerdetails/saveSamples") }}',
      data: {data: handsontable.getSourceData(), changes: isDirtyAr }, // returns all cells
      dataType: 'json',
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