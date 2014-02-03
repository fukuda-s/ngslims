{{ content() }}
<div class="col-md-9">
  <div id="flash"></div>
  <div class="panel panel-default">
    <div class="panel-heading">User & Project</div>
    <div class="panel-body">
      <div id="lab_select" class="form-group">
        <label for="lab_id" class="control-label">Lab
        </label>
        {{ select('lab_id', labs, 'using': ['id', 'name'], 'useEmpty': true, 'emptyText': 'Please, choose Laboratory...', 'emptyValue': '@', 'class': 'form-control input-sm') }}
      </div>
      <div id="pi_user_select" class="form-group">
        <label for="pi_user_id" class="control-label">PI
        </label>
        <select id="pi_user_id" class="form-control input-sm" disabled>
          <option value="@">You have to select Labratory before...</option>
        </select>
      </div>
      <div id="project_select" class="form-group">
        <label for="project_id" class="control-label">Project
        </label>
        <select id="project_id" class="form-control input-sm" disabled></select>
      </div>
    </div>
    {% include "partials/modal-project.volt" %}
  </div>
  <div class="panel panel-default">
    <div class="panel-heading">Sample</div>
    <div class="panel-body">
      <div id="sample_type_select" class="form-group">
        <label for="sample_type_id" class="control-label">Sample Type
        </label>
        {{ select('sample_type_id', sampletypes, 'using': ['id', 'name'], 'useEmpty': true, 'emptyText': 'Please, choose Sample Type...', 'emptyValue': '@', 'class': 'form-control input-sm') }}
      </div>
      <div id="organism_select" class="form-group">
        <label for="organism_id" class="control-label">Organism
        </label>
        {{ select('organism_id', organisms, 'using': ['id', 'name'], 'useEmpty': true, 'emptyText': 'Please, choose Organism...', 'emptyValue': '@', 'class': 'form-control input-sm') }}
      </div>
      <!-- Handsontable toolbar -->
      <nav class="navbar navbar-default" role="navigation">
        <!-- Brand and toggle get grouped for better mobile display -->
        <div class="navbar-header">
          <button type="button" class="navbar-toggle" data-toggle="collapse" data-target="#handsontable-toolbar">
            <span class="sr-only">Toggle navigation</span>
            <span class="icon-bar"></span>
            <span class="icon-bar"></span>
            <span class="icon-bar"></span>
          </button>
        </div>
        <!-- Collect the nav links, forms, and other content for toggling -->
        <div class="collapse navbar-collapse" id="handsontable-toolbar">
          <ul class="nav navbar-nav">
            <li class="disabled" id="undo"><a href="#"><i class="fa fa-undo"></i> Undo</a></li>
            <li class="disabled" id="redo"><a href="#">Redo <i class="fa fa-repeat"></i></a></li>
          </ul>
          <form class="navbar-form navbar-right" role="search">
            <div class="form-group">
              <input type="text" class="form-control" placeholder="Search">
            </div>
          </form>
          <ul class="nav navbar-nav navbar-right">
            <li class="disabled" id="clear"><a href="#">Clear edit <i class="fa fa-refresh"></i></a></li>
          </ul>
        </div>
        <!-- /.navbar-collapse -->
      </nav>
      <!-- /Handsontable toolbar -->
      <div id="handsontable-sample"></div>
    </div>
  </div>
  <div class="panel panel-default">
    <div class="panel-heading">Sequence Library & Multiplex
      <div class="checkbox-inline pull-right">
        <label>
          <input type="checkbox" id="seqlib-undecided" data-toggle="collapse"
                 data-target=".seqlib-undecide-toggle-target">
          Undecided
        </label>
      </div>
    </div>
    <div class="panel-body seqlib-undecide-toggle-target collapse in">
      <div id="step_select" class="form-group">
        <label for="step_id" class="control-label">Experiment Step
        </label>
        <select id="step_id" class="form-control input-sm" disabled>
          <option value="@">Sample Type is necessary...</option>
        </select>
      </div>
      <div id="protocol_select" class="form-group">
        <label for="protocol_id" class="control-label">Protocol</label>
        <select id="protocol_id" class="form-control input-sm" disabled></select>
      </div>
    </div>
  </div>
  <div class="panel panel-default seqlib-undecide-toggle-target collapse in">
    <div class="panel-heading">Sequencing Run
      <div class="checkbox-inline pull-right">
        <label>
          <input type="checkbox" id="seqrun-undecided" data-toggle="collapse"
                 data-target=".seqrun-undecide-toggle-target">
          Undecided
        </label>
      </div>
    </div>
    <div class="panel-body seqrun-undecide-toggle-target collapse in">
      <div id="instrument_type_select" class="form-group">
        <label for="instrument_type_id">Instrument Type</label>
        <select id="instrument_type_id" class="form-control input-sm" disabled>
          <option value="@">Experiment Step is necessary...</option>
        </select>
      </div>
      <div id="seq_run_type_selects">
        <div id="seq_runmode_type_select" class="form-group">
          <label>Run Mode</label>
        </div>
        <div id="seq_runread_type_select" class="form-group">
          <label>Read Type</label>
        </div>
        <div id="seq_runcycle_type_select" class="form-group">
          <label>Read Cycle</label>
        </div>
      </div>
    </div>
  </div>
  <div class="seqrun-undecide-toggle-target collapse in">
    <div class="panel panel-default seqlib-undecide-toggle-target collapse in">
      <div class="panel-heading">Pipeline
        <div class="checkbox-inline pull-right">
          <label>
            <input type="checkbox" id="pipeline-undecided" data-toggle="collapse"
                   data-target=".pipeline-undecide-toggle-target">
            Undecided
          </label>
        </div>
      </div>
      <div class="panel-body pipeline-undecide-toggle-target collapse in"></div>
    </div>
  </div>
</div>
<div class="col-md-3" id="new_order_summary">
  <div class="panel panel-default">
    <div class="panel-heading">Summary</div>
    <ul class="list-group">
      <li class="list-group-item text-info">User & Project
        <ul id="user_project_selected" class="text-muted">
          <li id="lab_name_selected" style="display: none;"></li>
          <li id="pi_user_name_selected" style="display: none;"></li>
          <li id="project_name_selected" style="display: none;"></li>
        </ul>
      </li>
      <li class="list-group-item text-info">Sample
        <ul id="sample_selected" class="text-muted">
          <li id="sample_type_name_selected" style="display: none;"></li>
          <li id="organism_name_selected" style="display: none;"></li>
        </ul>
      </li>
      <li class="list-group-item text-info">Seqlib & Multiplex
        <ul id="seqlib_selected" class="text-muted">
          <li id="step_name_selected" style="display: none;"></li>
          <li id="protocol_name_selected" style="display: none;"></li>
        </ul>
      </li>
      <li class="list-group-item text-info">Sequencing
        <ul id="seqrun_selected" class="text-muted">
          <li id="instrument_type_name_selected" style="display: none;"></li>
          <li id="seq_runmode_type_name_selected" style="display: none;"></li>
          <li id="seq_runread_type_name_selected" style="display: none;"></li>
          <li id="seq_runcycle_type_name_selected" style="display: none;"></li>
        </ul>
      </li>
      <li class="list-group-item text-info">Pipeline
        <ul id="pipeline_selected" class="text-muted">
        </ul>
      </li>
    </ul>
    <div class="panel-footer">
      <button type="button" class="btn btn-default btn-xs" id="confirm"> Confirm <span
            class="glyphicon glyphicon-chevron-right"></span>
      </button>
    </div>
  </div>
</div>
<script>
$(document).ready(function () {
  /*
   * Fix cart on top
   */
  $("#new_order_summary").stick_in_parent();

  /*
   * Build function to set selected values to session.
   */
  function setOrderSessionVal(column, id, name) {
    $.ajax({
      url: '{{ url("order/orderSetSession/")}}' + column + '/' + id + '/' + name + '/',
      type: "POST"
    })
        .done(function (data) {
          $("#flash").html(data);
        });
  }

  /*
   * Build function to get project list from selected pi_user_id.
   */
  function getProjectList(pi_user_id) {
    $.ajax({
      url: '{{ url("order/projectSelectList/")}}' + pi_user_id + '/',
      dataType: "html",
      type: "POST"
    })
        .done(function (data) {
          $("#project_select").html(data);
          //Change project_name_selected value on right side summary with selected values
          $("#project_id").change(function () {
            var project_id_selected = $(this).val();
            var project_name_selected = $("option:selected", this).text();
            $("#project_name_selected").show("normal").text(project_name_selected);

            //Set selected project to session values.
            setOrderSessionVal('project_id', project_id_selected, project_name_selected);
          });
        });
  }

  /*
   * Build function to get project list from selected step_id.
   */
  function getProtocolList(step_id) {
    $.ajax({
      url: '{{ url("order/protocolSelectList/")}}' + step_id + '/',
      dataType: "html",
      type: "POST"
    })
        .done(function (data) {
          $("#protocol_select").html(data);
          //Change protocol_name_selected value on right side summary with selected values
          $("#protocol_id").change(function () {
            var protocol_id_selected = $(this).val();
            var protocol_name_selected = $("option:selected", this).text();
            $("#protocol_name_selected").show("normal").text(protocol_name_selected);

            //Set selected protocol to session values.
            setOrderSessionVal('protocol_id', protocol_id_selected, protocol_name_selected);
          });
        });
  }

  /*
   * Build function to get seq run type radio buttons from selected instrument_type_id.
   */
  function getSeqRunTypeList(instrument_type_id) {
    $.ajax({
      url: '{{ url("order/seqRunTypeSelectList/")}}' + instrument_type_id + '/',
      dataType: "html",
      type: "POST"
    })
        .done(function (data) {
          $("#seq_run_type_selects").html(data);

          //Change seq_runmode_type_name_selected value on right side summary with selected values
          $("input:radio[name='seq_runmode_type_id']").change(function () {
            var seq_runmode_type_id_selected = $(this).filter(":checked").val();
            var seq_runmode_type_name_selected = $(this).filter(":checked").parent("label").text();
            $("#seq_runmode_type_name_selected").show("normal").text(seq_runmode_type_name_selected);

            //Set selected seq_runmode_type to session values.
            setOrderSessionVal('seq_runmode_type_id', seq_runmode_type_id_selected, seq_runmode_type_name_selected);
          });

          //Change seq_runread_type_name_selected value on right side summary with selected values
          $("input:radio[name='seq_runread_type_id']").change(function () {
            var seq_runread_type_id_selected = $(this).filter(":checked").val();
            var seq_runread_type_name_selected = $(this).filter(":checked").parent("label").text();
            $("#seq_runread_type_name_selected").show("normal").text(seq_runread_type_name_selected);

            //Set selected seq_runread_type to session values.
            setOrderSessionVal('seq_runread_type_id', seq_runread_type_id_selected, seq_runread_type_name_selected);
          });

          //Change seq_runcycle_type_name_selected value on right side summary with selected values
          $("input:radio[name='seq_runcycle_type_id']").change(function () {
            var seq_runcycle_type_id_selected = $(this).filter(":checked").val();
            var seq_runcycle_type_name_selected = $(this).filter(":checked").parent("label").text();
            $("#seq_runcycle_type_name_selected").show("normal").text(seq_runcycle_type_name_selected);

            //Set selected seq_runcycle_type to session values.
            setOrderSessionVal('seq_runcycle_type_id', seq_runcycle_type_id_selected, seq_runcycle_type_name_selected);
          });
        });
  }

  /*
   * Build function to get instrument type list from selected step_id.
   */
  function getInstrumentTypeList(step_id) {
    $.ajax({
      url: '{{ url("order/instrumentTypeSelectList/")}}' + step_id + '/',
      dataType: "html",
      type: "POST"
    })
        .done(function (data) {
          $("#instrument_type_select").html(data);

          //Change instrument_type_name_selected value on right side summary with selected values
          $("#instrument_type_id").change(function () {
            var instrument_type_id_selected = $(this).val();
            var instrument_type_name_selected = $("option:selected", this).text();
            $("#instrument_type_name_selected").show("normal").text(instrument_type_name_selected);

            //Refresh seq_run_type radios
            getSeqRunTypeList(instrument_type_id_selected);

            //Set selected instrument_type to session values.
            setOrderSessionVal('instrument_type_id', instrument_type_id_selected, instrument_type_name_selected);
          });
        });
  }


  /*
   * Change PI user select list when lab select is changed
   */
  $("#lab_id").change(function () {
    var lab_id_selected = $(this).val();
    var lab_name_selected = $("option:selected", this).text();
    $.ajax({
      url: '{{ url("order/userSelectList/")}}' + $(this).val() + '/',
      dataType: "html",
      type: "POST"
    })
        .done(function (data) {
          //Make select
          $("#pi_user_select").html(data);
          // Change Project list when pi_user_id select is changed
          $("#pi_user_id").change(function () {
            getProjectList($(this).val());
            var pi_user_id_selected = $(this).val();
            var pi_user_name_selected = $("option:selected", this).text();
            $("#pi_user_name_selected").hide().show("normal").text(pi_user_name_selected);

            //Set selected pi_user to session values.
            setOrderSessionVal('pi_user_id', pi_user_id_selected, pi_user_name_selected);
          });

          //Change lab_name_selected value on right side summary with selected values
          $("#lab_name_selected").show("normal").text(lab_name_selected);

          //Refresh project_select when lab_id value has been changed.
          var pi_user_selected = $("#pi_user_id").find("option:selected");
          var pi_user_id_selected = pi_user_selected.val();
          var pi_user_name_selected = pi_user_selected.text();
          getProjectList(pi_user_id_selected);

          //Change pi_user_name_selected value on right side summary with first value (current user's name has been set).
          $("#pi_user_name_selected").show("normal").text(pi_user_name_selected);
        });

    //Set selected lab to session values.
    setOrderSessionVal('lab_id', lab_id_selected, lab_name_selected);
  });

  //Change sample_type_selected value on right side summary with selected values
  $("#sample_type_id").change(function () {
    var sample_type_id_selected = $(this).val();
    var sample_type_name_selected = $("option:selected", this).text();
    $("#sample_type_name_selected").show("normal").text(sample_type_name_selected);
    $.ajax({
      url: '{{ url("order/stepSelectList/")}}' + $(this).val() + '/',
      dataType: "html",
      type: "POST"
    })
        .done(function (data) {
          //Make select
          $("#step_select").html(data);

          // Change Project list when step_id select is changed
          $("#step_id").change(function () {
            var step_id_selected = $(this).val();
            var step_name_selected = $("option:selected", this).text();
            getProtocolList(step_id_selected);
            getInstrumentTypeList(step_id_selected);

            $("#step_name_selected").hide().show("normal").text(step_name_selected);

            //Set selected step to session values.
            setOrderSessionVal('step_id', step_id_selected, step_name_selected);
          });

          //Refresh protocol_select when sample_type has been changed
          var step_id_selected = $("#step_id").children().first().val();
          getProtocolList(step_id_selected);
          getInstrumentTypeList(step_id_selected);
        });

    //Set selected sample_type to session values.
    setOrderSessionVal('sample_type_id', sample_type_id_selected, sample_type_name_selected);
  });


  //Change organism_selected value on right side summary with selected values
  $("#organism_id").change(function () {
    var organism_id_selected = $(this).val();
    var organism_name_selected = $("option:selected", this).text();
    $("#organism_name_selected").show("normal").text(organism_name_selected);

    //Set selected sample_type to session values.
    setOrderSessionVal('organism_id', organism_id_selected, organism_name_selected);
  });

  /*
   * Control modal-project
   */
  $('#modal-project').on('shown.bs.modal', function (event) {
    var lab_id_selected = $("#lab_id").find("option:selected").text();
    event.target.find('#lab_id_selected').text("Find it!");
  });

  /*
   * Control "Undecided" checkbox action
   */
  var seqlib_selected_content;
  var seqlib_selected = $("#seqlib_selected");
  $("#seqlib-undecided").change(function () {
    if ($(this).prop("checked")) {
      seqlib_selected_content = seqlib_selected.html();
      seqlib_selected.html('<li class="text-warning">Undecided</li>');
    } else {
      seqlib_selected.html(seqlib_selected_content);
    }
    //Set selected seqlib-undecided to session values.
    setOrderSessionVal('seqlib-undecided', 0, $(this).prop("checked"));
  });

  var seqrun_selected_content;
  var seqrun_selected = $("#seqrun_selected");
  $("#seqrun-undecided").change(function () {
    if ($(this).prop("checked")) {
      seqrun_selected_content = seqrun_selected.html();
      seqrun_selected.html('<li class="text-warning">Undecided</li>');
    } else {
      seqrun_selected.html(seqrun_selected_content);
    }
    //Set selected seqrun-undecided to session values.
    setOrderSessionVal('seqrun-undecided', 0, $(this).prop("checked"));
  });

  // @TODO pipeline select control
  /*
  var pipeline_selected_content;
  pipeline_selected = $("#pipeline_selected");
  $("#pipeline-undecided").change(function () {
    if ($(this).prop("checked")) {
      pipeline_selected_content = pipeline_selected.html();
      pipeline_selected.html('<li class="text-warning">Undecided</li>');
    } else {
      pipeline_selected.html(pipeline_selected_content);
    }
   //Set selected pipeline-undecided to session values.
   setOrderSessionVal('pipeline-undecided', 0, $(this).prop("checked"));
  });
  */
  /*
   * Build Handsontable
   */
  var $container = $("#handsontable-sample");
  var $console = $("#handsontable-console");
  var $toolbar = $("#handsontable-toolbar");
  var isDirtyAr = [];
  $container.handsontable({
    stretchH: 'all',
    rowHeaders: true,
    contextMenu: true,
    minSpareRows: 1,
    columnSorting: true,
    manualColumnResize: true,
    columns: [
      { data: "name", title: "Sample Name" },
      { data: "qual_concentration", title: "Conc. (ng/uL)", type: 'numeric', format: '0.000' },
      { data: "qual_od260280", title: "A260/A280", type: 'numeric', format: '0.00' },
      { data: "qual_od260230", title: "A260/A230", type: 'numeric', format: '0.00' },
      { data: "qual_RIN", title: "RIN", type: 'numeric', format: '0.00' },
      { data: "qual_fragmentsize", title: "Fragment Size", type: 'numeric' },
      { data: "qual_nanodrop_conc", title: "Conc. (ng/uL) (NanoDrop)", type: 'numeric', format: '0.000' },
      { data: "qual_volume", title: "Volume (uL)", type: 'numeric', format: '0.00' },
      { data: "qual_amount", data: 0, title: "Total (ng)", type: 'numeric', format: '0.00' },
      { data: "qual_date", title: "QC Date", type: 'date', dateFormat: 'yy-mm-dd' }
    ],
    afterChange: function (changes, source) {
      if (source === 'loadData') {//not used now
        // don't save this change
      }
      else {
        // Enable "Save", "Undo" link on toolbar above of table
        // after edit.
        // alert("afterEdit");
        $toolbar.find("#save, #undo, #clear").removeClass("disabled");
        $console.text('Click "Save" to save data to server').removeClass().addClass("alert alert-info");
        $.each(changes, function (key, value) {
          isDirtyAr.push(value);
        });
      }
    }

  });

  var handsontable = $container.data('handsontable');

  //Build 'Undo' function on toolbar
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

  //Build 'Redo' function on toolbar
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
    $toolbar.find("#save, #undo, #redo, #clear").addClass("disabled");
    $console.text('All changes is discarded').removeClass().addClass("alert alert-success");
    $container.handsontable("loadData", null);
  });


});
</script>