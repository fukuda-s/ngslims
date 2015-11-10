{{ content() }}
<div class="col-sm-9">
  {{ flashSession.output() }}
  <div id="flash"></div>
  <div class="panel panel-success">
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
  <div class="panel panel-success">
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
      <div id="qc_inside_select" class="form-group">
        <label for="qc_inside">QC Inside?</label><br>
        <label class="radio-inline">
          {{ radio_field('qc_inside', 'value':'true', 'id':'qc_inside_yes', 'name':'qc_inside') }}Yes
        </label>
        <label class="radio-inline">
          {{ radio_field('qc_inside', 'value':'false', 'id':'qc_inside_no', 'name':'qc_inside') }}No
        </label>
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
              <select id="sample_property_types" multiple="multiple">
                {% for sample_property_type in sample_property_types %}
                  {% set sample_property_type_id_str = "sample_property_type_id_" ~ sample_property_type.id %}
                  {% if sample_property_types_checked.name[sample_property_type_id_str] is defined
                  and sample_property_types_checked.name[sample_property_type_id_str] == "true" %}
                    <option value="{{ sample_property_type_id_str }}" selected>{{ sample_property_type.name }}</option>
                  {% else %}
                    <option value="{{ sample_property_type_id_str }}">{{ sample_property_type.name }}</option>
                  {% endif %}
                {% endfor %}
              </select>
              <input type="text" class="form-control" placeholder="Search" id="search_field">
            </div>
          </form>
          <ul class="nav navbar-nav navbar-right">
            <li class="disabled" id="clear"><a href="#">Clear edit <i class="fa fa-refresh"></i></a></li>
          </ul>
        </div>
        <!-- /.navbar-collapse -->
      </nav>
      <!-- /Handsontable toolbar -->
      <!--<div id="handsontable-orderSamples-body" style="overflow: hidden"></div>-->
      <div id="handsontable-orderSamples-body"></div>
    </div>
  </div>
  <div class="panel panel-success">
    <div class="panel-heading">Sequence Library & Multiplex
      <div class="checkbox-inline pull-right">
        <label>
          <input type="checkbox" id="seqlib-undecided" data-toggle="collapse"
                 data-target=".seqlib-undecide-toggle-target"
                 {% if seqlib_undecided.name === "true" %}checked{% endif %}>
          Undecided
        </label>
      </div>
    </div>
    <div
        class="panel-body seqlib-undecide-toggle-target collapse {% if seqlib_undecided.name === "false" %}in{% endif %}">
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
      <div id="samples_per_seqtemplate_form" class="form-group">
        <label for="samples_per_seqtemplate" class="control-label"># of Samples / Lane
          <small>(How many sample(s) will be multiplexed in one mixed library?)</small>
        </label>
        <input type="number" id="samples_per_seqtemplate" class="form-control input-sm" min="1">
      </div>
    </div>
  </div>
  <div
      class="panel panel-success seqlib-undecide-toggle-target collapse {% if seqlib_undecided.name === "false" %}in{% endif %}">
    <div class="panel-heading">Sequencing Run
      <div class="checkbox-inline pull-right">
        <label>
          <input type="checkbox" id="seqrun-undecided" data-toggle="collapse"
                 data-target=".seqrun-undecide-toggle-target"
                 {% if seqrun_undecided.name === "true" %}checked{% endif %}>
          Undecided
        </label>
      </div>
    </div>
    <div
        class="panel-body seqrun-undecide-toggle-target collapse {% if seqlib_undecided.name === "false" and seqrun_undecided.name === "false" %}in{% endif %}">
      <div id="instrument_type_select" class="form-group">
        <label for="instrument_type">Instrument Type</label>
        <select id="instrument_type" class="form-control input-sm" disabled>
          <option value="@">Experiment Step is necessary...</option>
        </select>
      </div>
      <div id="seq_run_type_select">
        <div id="seq_runmode_types_radio" class="form-group">
          <label>Run Mode</label>
        </div>
        <div id="seq_runread_types_radio" class="form-group">
          <label>Read Type</label>
        </div>
        <div id="seq_runcycle_types_radio" class="form-group">
          <label>Read Cycle</label>
        </div>
      </div>
      <div id="lanes_per_seqtemplate_form" class="form-group">
        <label for="lanes_per_seqtemplate" class="control-label"># of Lane / Multiplexed Library
          <small>(How many lane(s) will be required per one multiplexed library?)</small>
        </label>
        <input type="number" id="lanes_per_seqtemplate" class="form-control input-sm" min="1">
      </div>
    </div>
  </div>
  <div class="seqrun-undecide-toggle-target collapse in">
    <div
        class="panel panel-success seqlib-undecide-toggle-target collapse {% if seqlib_undecided.name === "false" and seqrun_undecided.name === "false" %}in{% endif %}">
      <div class="panel-heading">Pipeline
        <div class="checkbox-inline pull-right">
          <label>
            <input type="checkbox" id="pipeline-undecided" data-toggle="collapse"
                   data-target=".pipeline-undecide-toggle-target">
            Undecided
          </label>
        </div>
      </div>
      <div
          class="panel-body pipeline-undecide-toggle-target collapse {% if seqlib_undecided.name === "false" and seqrun_undecided.name === "false" %}in{% endif %}"></div>
    </div>
  </div>
</div>
<div class="col-sm-3" id="new_order_summary">
  <div class="panel panel-primary" data-offset-top="50" data-spy="affix">
    <div class="panel-heading">Summary</div>
    <ul class="list-group">
      <li class="list-group-item text-info">User & Project
        <ul class="text-muted">
          <li id="lab_name_selected" style="display: none;"></li>
          <li id="pi_user_name_selected" style="display: none;"></li>
          <li id="project_name_selected" style="display: none;"></li>
        </ul>
      </li>
      <li class="list-group-item text-info">Sample
        <ul class="text-muted">
          <li id="sample_type_name_selected" style="display: none;"></li>
          <li id="organism_name_selected" style="display: none;"></li>
          <li id="qc_inside_selected" style="display: none;"></li>
        </ul>
      </li>
      <li class="list-group-item text-info">Seqlib & Multiplex
        <ul class="text-muted">
          <li id="seqlib_undecided_selected" class="text-warning" style="display: none;">Undecided</li>
          <li id="step_name_selected" style="display: none;"></li>
          <li id="protocol_name_selected" style="display: none;"></li>
          <li id="samples_per_seqtemplate_inputted" style="display: none;"><span></span>
            <small> sample(s)/1 lane</small>
          </li>
        </ul>
      </li>
      <li class="list-group-item text-info">Sequencing
        <ul class="text-muted">
          <li id="seqrun_undecided_selected" class="text-warning" style="display: none;">Undecided</li>
          <li id="instrument_type_name_selected" style="display: none;"></li>
          <li id="seq_runmode_type_name_selected" style="display: none;"></li>
          <li id="seq_runread_type_name_selected" style="display: none;"></li>
          <li id="seq_runcycle_type_name_selected" style="display: none;"></li>
          <li id="lanes_per_seqtemplate_inputted" style="display: none;"><span></span>
            <small> lane(s)/1 multiplexed library</small>
          </li>
        </ul>
      </li>
      <li class="list-group-item text-info">Pipeline
        <ul class="text-muted">
          <li id="pipeline_undecided" class="text-warning" style="display: none;">Undecided</li>
        </ul>
      </li>
    </ul>
    <div class="panel-footer">
      <button type="button" class="btn btn-default btn-xs pull-right" id="confirm"
              onclick="location.href='{{ url("order/confirm") }}'"> Confirm <span
            class="glyphicon glyphicon-chevron-right"></span>
      </button>
      <div class="clearfix"></div>
    </div>
  </div>
  <button id="removeOrderSession" class="btn btn-warning pull-right"><span class="fa fa-trash"></span>&ensp;Clear Forms
  </button>
</div>
<script>
  /*
   * Fix cart on top
   */
  //$('#new_order_summary').stick_in_parent();

  /*
   * Function to set selected values to session.
   * @TODO Should I use "ajaxSuccess" function?
   */
  function setOrderSessionVal(column, id, name) {
    $.ajax({
      url: '{{ url('order/orderSetSession/')}}',
      dataType: 'html',
      type: 'POST',
      data: {column: column, id: id, name: name}
    })
        .done(function (data) {
          $('#flash').html(data);
          console.log(column + " : " + id + " : " + name);
        });
  }

  /*
   * Get select list via ajax from OrderController.php
   * To use this function, all "id" values should be named with rule as follows.
   * - (class) : (id)
   * - div.form-group : <column>_select
   * - select.form-control : <column>_id
   * - li(in #new_order_summary): <column>_name_selected
   */
  function getSelectList(column, key) {
    //Make upper camel name for controller
    var columnUpperCamel = column.
        replace(
        /_./g,
        function (matched) {
          return matched.charAt(1).toUpperCase();
        });
    var urlStr = {{ url() }}+"order/" + columnUpperCamel + "SelectList/" + key + "/";
    $.ajax({
      url: urlStr,
      dataType: 'html',
      type: 'POST'
    })
        .done(function (data) {
          //rewrite select list by ajax data
          $('#' + column + '_select').html(data);

          //set on change action to rewrite right-side summary when the select list will be changed
          $('#' + column + '_id').on('change', function () {
            var id_selected = $(this).val();
            var name_selected = $('option:selected', this).text();
            $('#' + column + '_name_selected').hide().show('normal').text(name_selected);

            //Set selected value to session values.
            setOrderSessionVal(column, id_selected, name_selected);
          });

          //Change project_name_selected value on right side summary with selected values
          var name_selected = $('#' + column + '_id').find('option:selected').text();
          $('#' + column + '_name_selected').hide().show('normal').text(name_selected);
        });
  }

  function setSelectChangedVals(selector, followSelects) {
    $('#' + selector + '_id').on('change', function () {
      var id_selected = $(this).val();
      var name_selected = $('option:selected', this).text();
      $('#' + selector + '_name_selected').hide().show('normal').text(name_selected);

      //Set selected value to session values.
      setOrderSessionVal(selector, id_selected, name_selected);

      for (var key in followSelects) {
        getSelectList(followSelects[key], id_selected);
      }

    });
  }

  /*
   * Build function to get seq run type radio buttons from selected instrument_type_id.
   * These select lists are cascaded as follows.
   * (Cascaded column should be changed when parent column has been changed.)
   *
   *  + Lab & User
   *    lab_id -> pi_user_id (lab_id) -> project_id (pi_user_id)
   *  + Sample
   *    + sample_type_id
   *    + organism_id
   *  + Sequence Library & Multiplex
   *    + step_id (sample_type_id)
   *    + protocol_id
   *  + Sequence Run
   *    + instrument_id (step_id)
   *    + seq_runmode_type_id (instrument_id)
   *    + seq_runread_type_id (instrument_id)
   *    + seq_runcycle_type_id (instrument_id)
   *
   */
  /*
   * Build function to get instrument type list from selected step_id.
   */
  function getInstrumentTypeList(step_id) {
    $.ajax({
      url: '{{ url('order/instrumentTypeSelectList/')}}' + step_id + '/',
      dataType: 'html',
      type: 'POST'
    })
        .done(function (data) {
          $('#instrument_type_select').html(data);

          //setSelectChangedVals('instrument_type', new Array('seq_run_type'));
          $('#instrument_type').on('change', function () {
            var instrument_type_id_selected = $(this).val();
            var instrument_type_name_selected = $('option:selected', this).text();
            $('#instrument_type_name_selected').hide().show('normal').text(instrument_type_name_selected);

            //Set selected step to session values.
            setOrderSessionVal('instrument_type', instrument_type_id_selected, instrument_type_name_selected);

            //Refresh seq_runmode_types_radio when instrument_type_id is changed
            getSeqRunmodeTypesList(instrument_type_id_selected);
          });

          //Refresh seq_runmode_types_radio when instrument_type_id has session value
          var instrument_type_id_selected = $('#instrument_type').val();
          getSeqRunmodeTypesList(instrument_type_id_selected);

        });
  }

  function getSeqRunmodeTypesList(instrument_type_id) {
    $.ajax({
      url: '{{ url('order/seqRunmodeTypesSelectList/')}}',
      dataType: 'html',
      type: 'POST',
      data: {instrument_type_id: instrument_type_id}
    })
        .done(function (data) {
          $('#seq_runmode_types_radio').html(data);

          //Change seq_runmode_type_name_selected value on right side summary with selected values
          $("input:radio[name='seq_runmode_type']").on('change', function () {
            var seq_runmode_type_id_selected = $(this).filter(':checked').val();
            var seq_runmode_type_name_selected = $(this).filter(':checked').parent('label').text();
            $('#seq_runmode_type_name_selected').hide().show('normal').text(seq_runmode_type_name_selected);

            //Set selected seq_runmode_type to session values.
            setOrderSessionVal('seq_runmode_type', seq_runmode_type_id_selected, seq_runmode_type_name_selected);

            //Refresh seq_runread_types_radio when seq_runmode_type_id is changed
            getSeqRunreadTypesList(instrument_type_id, seq_runmode_type_id_selected);
          });

          //Refresh seq_runread_types_radio when seq_runmode_type_id has session value
          var seq_runmode_type_id_selected = $("input:radio[name='seq_runmode_type']").filter(':checked').val();
          getSeqRunreadTypesList(instrument_type_id, seq_runmode_type_id_selected);

        });
  }

  function getSeqRunreadTypesList(instrument_type_id, seq_runmode_type_id) {
    $.ajax({
      url: '{{ url('order/seqRunreadTypesSelectList/')}}',
      dataType: 'html',
      type: 'POST',
      data: {instrument_type_id: instrument_type_id, seq_runmode_type_id: seq_runmode_type_id}
    })
        .done(function (data) {
          $('#seq_runread_types_radio').html(data);

          //Change seq_runread_type_name_selected value on right side summary with selected values
          $("input:radio[name='seq_runread_type']").on('change', function () {
            var seq_runread_type_id_selected = $(this).filter(':checked').val();
            var seq_runread_type_name_selected = $(this).filter(':checked').parent('label').text();
            $('#seq_runread_type_name_selected').hide().show('normal').text(seq_runread_type_name_selected);

            //Set selected seq_runread_type to session values.
            setOrderSessionVal('seq_runread_type', seq_runread_type_id_selected, seq_runread_type_name_selected);

            //Refresh seq_runcycle_types_radio when seq_runread_type_id is changed
            getSeqRuncycleTypesList(instrument_type_id, seq_runmode_type_id, seq_runread_type_id_selected);
          });

          //Refresh seq_runcycle_types_radio when seq_runread_type_id has session value
          var seq_runread_type_id_selected = $("input:radio[name='seq_runread_type']").filter(':checked').val();
          getSeqRuncycleTypesList(instrument_type_id, seq_runmode_type_id, seq_runread_type_id_selected);
        });
  }

  function getSeqRuncycleTypesList(instrument_type_id, seq_runmode_type_id, seq_runread_type_id) {
    $.ajax({
      url: '{{ url('order/seqRuncycleTypesSelectList/')}}',
      dataType: 'html',
      type: 'POST',
      data: {
        instrument_type_id: instrument_type_id,
        seq_runmode_type_id: seq_runmode_type_id,
        seq_runread_type_id: seq_runread_type_id
      }
    })
        .done(function (data) {
          $('#seq_runcycle_types_radio').html(data);
          //Change seq_runcycle_type_name_selected value on right side summary with selected values
          $("input:radio[name='seq_runcycle_type']").on('change', function () {
            var seq_runcycle_type_id_selected = $(this).filter(':checked').val();
            var seq_runcycle_type_name_selected = $(this).filter(':checked').parent('label').text();
            $('#seq_runcycle_type_name_selected').hide().show('normal').text(seq_runcycle_type_name_selected);

            //Set selected seq_runcycle_type to session values.
            setOrderSessionVal('seq_runcycle_type', seq_runcycle_type_id_selected, seq_runcycle_type_name_selected);
          });
        });
  }


  /*
   * Build function to get pi_user list from selected step_id.
   */
  function getStepSelectList(sample_type_id) {
    $.ajax({
      url: '{{ url('order/stepSelectList/')}}' + sample_type_id + '/',
      dataType: 'html',
      type: 'POST'
    })
        .done(function (data) {
          //Make select
          $('#step_select').html(data);


          $('#step_id').on('change', function () {
            var step_id_selected = $(this).val();
            var step_name_selected = $('option:selected', this).text();
            $('#step_name_selected').hide().show('normal').text(step_name_selected);

            //Set selected step to session values.
            setOrderSessionVal('step', step_id_selected, step_name_selected);

            //Refresh protocol_selected and instrument_select when step_id is changed
            getSelectList('protocol', step_id_selected);
            getInstrumentTypeList(step_id_selected);
          });

          //Refresh protocol_select when sample_type has been changed
          var step_selected = $('#step_id').find('option:selected');
          var step_id_selected = step_selected.val();
          var step_name_selected = step_selected.text();
          $('#step_name_selected').hide().show('normal').text(step_name_selected);

          getSelectList('protocol', step_id_selected);
          getInstrumentTypeList(step_id_selected);
        });
  }

  /*
   * Build function to get pi_user list from selected step_id.
   */
  function getUserSelectList(lab_id) {
    $.ajax({
      url: '{{ url('order/userSelectList/')}}' + lab_id + '/',
      dataType: 'html',
      type: 'POST'
    })
        .done(function (data) {
          //Make select
          $('#pi_user_select').html(data);
          //Change pi_user_id_selected value on right side summary with selected values

          setSelectChangedVals('pi_user', new Array('project'));

          //Refresh project_select when lab_id value has been changed.
          var pi_user_selected = $('#pi_user_id').find('option:selected');
          var pi_user_id_selected = pi_user_selected.val();
          var pi_user_name_selected = pi_user_selected.text();
          getSelectList('project', pi_user_id_selected);

          //Change pi_user_name_selected value on right side summary with first value (current user's name has been set).
          $('#pi_user_name_selected').hide().show('normal').text(pi_user_name_selected);

          //Change pi_user_name on project_modal
          $("#modal_project_pi_user_name").text(pi_user_name_selected);
          $('#pi_user_id').on('change', function () {
            var pi_user_id_selected = $('option:selected', this).val();
            var pi_user_name_selected = $('option:selected', this).text();
            $("#modal_project_pi_user_name").text(pi_user_name_selected);
            getSelectList('project', pi_user_id_selected);
            setOrderSessionVal('pi_user', pi_user_id_selected, pi_user_name_selected);
            setOrderSessionVal('project', '@', '');
          });

          //Set selected pi_user to session values.
          setOrderSessionVal('pi_user', pi_user_id_selected, pi_user_name_selected);
        });
  }


  $(function () {
    /*
     * Change child select list and right-side summary when parent select list is changed
     */
    /* User & Project */
    //Change lab_id_selected value on right side summary with selected values
    $('#lab_id').on('change', function () {
      var lab_id_selected = $(this).val();
      var lab_name_selected = $('option:selected', this).text();
      $('#lab_name_selected').hide().show('normal').text(lab_name_selected);

      //Change lab_name on project_modal
      $("#modal_project_lab_name").text(lab_name_selected);

      //Set selected lab to session values.
      setOrderSessionVal('lab', lab_id_selected, lab_name_selected);

      //Refresh pi_user_select when lab_id is changed
      getUserSelectList(lab_id_selected);

    });

    /* Sample */
    //Change sample_type_selected value on right side summary with selected values
    $('#sample_type_id').on('change', function () {
      var sample_type_id_selected = $(this).val();
      var sample_type_name_selected = $('option:selected', this).text();
      $('#sample_type_name_selected').hide().show('normal').text(sample_type_name_selected);

      //Set selected sample_type to session values.
      setOrderSessionVal('sample_type', sample_type_id_selected, sample_type_name_selected);

      //Refresh step_select when sample_type_id is changed
      getStepSelectList(sample_type_id_selected);


    });

    //Change organism_selected value on right side summary with selected values
    $('#organism_id').on('change', function () {
      var organism_id_selected = $(this).val();
      var organism_name_selected = $('option:selected', this).text();
      $('#organism_name_selected').hide().show('normal').text(organism_name_selected);

      //Set selected sample_type to session values.
      setOrderSessionVal('organism', organism_id_selected, organism_name_selected);
    });

    //Change qc_inside_select value on right side summary with selected values
    $("input:radio[name='qc_inside']").on('change', function () {
      var qc_inside_value_selected = $(this).filter(':checked').val();
      var qc_inside_name_selected = $(this).filter(':checked').parent('label').text();
      $('#qc_inside_selected').hide().show('normal').text('QC Inside?: ' + qc_inside_name_selected);

      //Set selected seq_runcycle_type to session values.
      setOrderSessionVal('qc_inside', 0, qc_inside_value_selected);
    });

    /* Sequence Library & Multiplex */
    //Change protocol_name_selected value on right side summary with selected values
    $('#protocol_id').on('change', function () {
      var protocol_id_selected = $(this).val();
      var protocol_name_selected = $('option:selected', this).text();
      $('#protocol_name_selected').hide().show('normal').text(protocol_name_selected);

      //Set selected protocol to session values.
      setOrderSessionVal('protocol', protocol_id_selected, protocol_name_selected);
    });

    //Change samples_per_seqtemplate_inputted value on right side summary with inputted values
    $('#samples_per_seqtemplate').on('change', function () {
      var samples_per_seqtemplate_inputted = $('#samples_per_seqtemplate').val();
      $('#samples_per_seqtemplate_inputted').hide().show('normal').find('span').text(samples_per_seqtemplate_inputted);

      //Set inputted samples_per_seqtemplate to session values.
      setOrderSessionVal('samples_per_seqtemplate', 0, samples_per_seqtemplate_inputted);
    });

    /*
     * Sequencing Run
     */
    //Change samples_per_seqtemplate_inputted value on right side summary with inputted values
    $('#lanes_per_seqtemplate').on('change', function () {
      var lanes_per_seqtemplate_inputted = $('#lanes_per_seqtemplate').val();
      $('#lanes_per_seqtemplate_inputted').hide().show('normal').find('span').text(lanes_per_seqtemplate_inputted);

      //Set inputted lanes_per_seqtemplate to session values.
      setOrderSessionVal('lanes_per_seqtemplate', 0, lanes_per_seqtemplate_inputted);
    });

    /*
     * Set control for "Undecided" check box
     */
    $('#seqrun-undecided').change(function () {
      if ($(this).prop('checked')) {
        $('#instrument_type_name_selected').hide();
        $('#seq_runmode_type_name_selected').hide();
        $('#seq_runread_type_name_selected').hide();
        $('#seq_runcycle_type_name_selected').hide();
        $('#lanes_per_seqtemplate_inputted').hide();

        $("#seqrun_undecided_selected").show('normal');
        //$("#pipeline_undecided_selected").show('normal');
      } else {
        $("#seqrun_undecided_selected").hide();
        //$("#pipeline_undecided_selected").hide();

        var instrument_type_selected = $('#instrument_type').find('option:selected');
        var instrument_type_name_selected = instrument_type_selected.text();
        $('#instrument_type_name_selected').hide().show('normal').text(instrument_type_name_selected);

        var seq_runmode_types_selected = $("input:radio[name='seq_runmode_type']").filter(':checked');
        var seq_runmode_type_name_selected = seq_runmode_types_selected.parent('label').text();
        $('#seq_runmode_type_name_selected').hide().show('normal').text(seq_runmode_type_name_selected);

        var seq_runread_types_selected = $("input:radio[name='seq_runread_type']").filter(':checked');
        var seq_runread_type_name_selected = seq_runread_types_selected.parent('label').text();
        $('#seq_runread_type_name_selected').hide().show('normal').text(seq_runread_type_name_selected);

        var seq_runcycle_types_selected = $("input:radio[name='seq_runcycle_type']").filter(':checked');
        var seq_runcycle_type_name_selected = seq_runcycle_types_selected.parent('label').text();
        $('#seq_runcycle_type_name_selected').hide().show('normal').text(seq_runcycle_type_name_selected);

        var lanes_per_seqtemplate_inputted = $('#lanes_per_seqtemplate').val();
        $('#lanes_per_seqtemplate_inputted').hide().show('normal').find('span').text(lanes_per_seqtemplate_inputted);
      }
      //Set selected seqrun-undecided to session values.
      setOrderSessionVal('seqrun_undecided', 0, $(this).prop('checked'));
      //Set selected pipeline-undecided to session values.
      //setOrderSessionVal('pipeline-undecided', 0, $(this).prop('checked'));
    });

    $('#seqlib-undecided').change(function () {
      if ($(this).prop('checked')) {
        $('#instrument_type_name_selected').hide();
        $('#seq_runmode_type_name_selected').hide();
        $('#seq_runread_type_name_selected').hide();
        $('#seq_runcycle_type_name_selected').hide();
        $('#lanes_per_seqtemplate_inputted').hide();
        $("#seqlib_undecided_selected").show('normal');

        $('#step_name_selected').hide();
        $('#protocol_name_selected').hide();
        $('#samples_per_seqtemplate_inputted').hide();

        $("#seqrun_undecided_selected").show('normal');
        //$("#pipeline_undecided_selected").show('normal');
      } else {
        $("#seqlib_undecided_selected").hide();

        //Restore right-side summary if #seqlib-undecided is un-checked
        var step_selected = $('#step_id').find('option:selected');
        var step_name_selected = step_selected.text();
        $('#step_name_selected').hide().show('normal').text(step_name_selected);
        console.log("onchange " + step_name_selected);

        var protocol_selected = $('#protocol_id').find('option:selected');
        var protocol_name_selected = protocol_selected.text();
        $('#protocol_name_selected').hide().show('normal').text(protocol_name_selected);

        var samples_per_seqtemplate_inputted = $('#samples_per_seqtemplate').val();
        $('#samples_per_seqtemplate_inputted').hide().show('normal').find('span').text(samples_per_seqtemplate_inputted);

        $("#seqrun_undecided_selected").hide();

        var instrument_type_selected = $('#instrument_type').find('option:selected');
        var instrument_type_name_selected = instrument_type_selected.text();
        $('#instrument_type_name_selected').hide().show('normal').text(instrument_type_name_selected);

        var seq_runmode_types_selected = $("input:radio[name='seq_runmode_type']").filter(':checked');
        var seq_runmode_type_name_selected = seq_runmode_types_selected.parent('label').text();
        $('#seq_runmode_type_name_selected').hide().show('normal').text(seq_runmode_type_name_selected);

        var seq_runread_types_selected = $("input:radio[name='seq_runread_type']").filter(':checked');
        var seq_runread_type_name_selected = seq_runread_types_selected.parent('label').text();
        $('#seq_runread_type_name_selected').hide().show('normal').text(seq_runread_type_name_selected);

        var seq_runcycle_types_selected = $("input:radio[name='seq_runcycle_type']").filter(':checked');
        var seq_runcycle_type_name_selected = seq_runcycle_types_selected.parent('label').text();
        $('#seq_runcycle_type_name_selected').hide().show('normal').text(seq_runcycle_type_name_selected);

        var lanes_per_seqtemplate_inputted = $('#lanes_per_seqtemplate').val();
        $('#lanes_per_seqtemplate_inputted').hide().show('normal').find('span').text(lanes_per_seqtemplate_inputted);
      }
      //Set selected seqlib_undecided to session values.
      setOrderSessionVal('seqlib_undecided', 0, $(this).prop('checked'));
      //Set selected seqrun_undecided to session values.
      setOrderSessionVal('seqrun_undecided', 0, $(this).prop('checked'));
      //Set selected pipeline-undecided to session values.
      //setOrderSessionVal('pipeline-undecided', 0, $(this).prop('checked'));
    });

    // @TODO pipeline select control
    /*
     var pipeline_selected_content;
     pipeline_selected = $('#pipeline_selected');
     $('#pipeline-undecided').change(function () {
     if ($(this).prop('checked')) {
     pipeline_selected_content = pipeline_selected.html();
     pipeline_selected.html('<li class='text-warning'>Undecided</li>');
     } else {
     pipeline_selected.html(pipeline_selected_content);
     }
     //Set selected pipeline-undecided to session values.
     setOrderSessionVal('pipeline-undecided', 0, $(this).prop('checked'));
     });
     */

    /*
     * Control modal-project
     */
    $('#modal-project').on('shown.bs.modal', function (event) {
      var lab_id_selected = $('#lab_id').find('option:selected').text();
      event.target.find('#lab_id_selected').text('Find it!');
    });

    /*
     * Check and load session values.
     * Some select list should be rewrite when cascaded (parent) value has session value
     */
    var lab_selected = $('#lab_id').find('option:selected');
    var lab_id_selected = lab_selected.val();
    var lab_name_selected = lab_selected.text();
    if (lab_selected.val() !== '@') {
      $('#lab_name_selected').hide().show('normal').text(lab_name_selected);

      //Change lab_name on project_modal
      $("#modal_project_lab_name").text(lab_name_selected);

      getUserSelectList(lab_id_selected);
    }

    var sample_type_selected = $('#sample_type_id').find('option:selected');
    var sample_type_id_selected = sample_type_selected.val();
    var sample_type_name_selected = sample_type_selected.text();
    if (sample_type_id_selected !== '@') {
      getStepSelectList(sample_type_id_selected);

      //Change sample_type_name_selected value on right side summary with selected values
      $('#sample_type_name_selected').hide().show('normal').text(sample_type_name_selected);
    }

    var organism_selected = $('#organism_id').find('option:selected');
    var organism_id_selected = organism_selected.val();
    var organism_name_selected = organism_selected.text();
    if (organism_id_selected !== '@') {
      //Change organism_name_selected value on right side summary with selected values
      $('#organism_name_selected').hide().show('normal').text(organism_name_selected);
    }

    var qc_inside_name_selected = $("input:radio[name='qc_inside']").filter(':checked').parent('label').text();
    $('#qc_inside_selected').hide().show('normal').text('QC Inside?: ' + qc_inside_name_selected);

    var instrument_type_id_selected = $('#instrument_type').val();
    if ($('#seqrun-undecided').prop('checked')) {
      //Remove from right-side summary
      $('#instrument_type_name_selected').hide();
      $('#seq_runmode_type_name_selected').hide();
      $('#seq_runread_type_name_selected').hide();
      $('#seq_runcycle_type_name_selected').hide();
      $('#samples_per_seqtemplate_inputted').hide();
      $("#seqrun_undecided_selected").show('normal');
    } else if (instrument_type_id_selected == '@') {
      //Remove from right-side summary
      $("#seqrun_undecided_selected").hide();
      $('#seq_runmode_type_name_selected').hide();
      $('#seq_runread_type_name_selected').hide();
      $('#seq_runcycle_type_name_selected').hide();
      $('#samples_per_seqtemplate_inputted').hide();
    } else {
      $("#seqrun_undecided_selected").hide();

      var instrument_type_selected = $('#instrument_type').find('option:selected');
      var instrument_type_name_selected = instrument_type_selected.text();
      $('#instrument_type_name_selected').hide().show('normal').text(instrument_type_name_selected);

      var seq_runmode_types_selected = $("input:radio[name='seq_runmode_type']").filter(':checked');
      var seq_runmode_type_name_selected = seq_runmode_types_selected.parent('label').text();
      $('#seq_runmode_type_name_selected').hide().show('normal').text(seq_runmode_type_name_selected);

      var seq_runread_types_selected = $("input:radio[name='seq_runread_type']").filter(':checked');
      var seq_runread_type_name_selected = seq_runread_types_selected.parent('label').text();
      $('#seq_runread_type_name_selected').hide().show('normal').text(seq_runread_type_name_selected);

      var seq_runcycle_types_selected = $("input:radio[name='seq_runcycle_type']").filter(':checked');
      var seq_runcycle_type_name_selected = seq_runcycle_types_selected.parent('label').text();
      $('#seq_runcycle_type_name_selected').hide().show('normal').text(seq_runcycle_type_name_selected);

      var lanes_per_seqtemplate_inputted = $('#lanes_per_seqtemplate').val();
      $('#lanes_per_seqtemplate_inputted').hide().show('normal').find('span').text(lanes_per_seqtemplate_inputted);
    }

    var step_id_selected = $('#step_id').val();
    if ($('#seqlib-undecided').prop('checked')) {
      //Remove from right-side summary
      $('#instrument_type_name_selected').hide();
      $('#seq_runmode_type_name_selected').hide();
      $('#seq_runread_type_name_selected').hide();
      $('#seq_runcycle_type_name_selected').hide();
      $('#lanes_per_seqtemplate_inputted').hide();
      $("#seqlib_undecided_selected").show('normal');

      $('#step_name_selected').hide();
      $('#protocol_name_selected').hide();
      $('#samples_per_seqtemplate_inputted').hide();
      $("#seqrun_undecided_selected").show('normal');
      //$("#pipeline_undecided_selected").show('normal');
    } else if (step_id_selected === '@') {
      //Remove from right-side summary
      $('#instrument_type_name_selected').hide();
      $('#seq_runmode_type_name_selected').hide();
      $('#seq_runread_type_name_selected').hide();
      $('#seq_runcycle_type_name_selected').hide();
      $('#lanes_per_seqtemplate_inputted').hide();
      $("#seqlib_undecided_selected").hide();

      $('#step_name_selected').hide();
      $('#protocol_name_selected').hide();
      $('#samples_per_seqtemplate_inputted').hide();
      $("#seqrun_undecided_selected").hide();
      //$("#pipeline_undecided_selected").show('normal');
    } else {
      $("#seqlib_undecided_selected").hide();

      //Restore right-side summary if #seqlib-undecided is un-checked
      var step_selected = $('#step_id').find('option:selected');
      var step_name_selected = step_selected.text();
      $('#step_name_selected').hide().show('normal').text(step_name_selected);

      var protocol_selected = $('#protocol_id').find('option:selected');
      var protocol_name_selected = protocol_selected.text();
      $('#protocol_name_selected').hide().show('normal').text(protocol_name_selected);

      var samples_per_seqtemplate_inputted = $('#samples_per_seqtemplate').val();
      $('#samples_per_seqtemplate_inputted').hide().show('normal').find('span').text(samples_per_seqtemplate_inputted);

      $("#seqrun_undecided_selected").hide();

      var instrument_type_selected = $('#instrument_type').find('option:selected');
      var instrument_type_name_selected = instrument_type_selected.text();
      $('#instrument_type_name_selected').hide().show('normal').text(instrument_type_name_selected);

      var seq_runmode_types_selected = $("input:radio[name='seq_runmode_type']").filter(':checked');
      var seq_runmode_type_name_selected = seq_runmode_types_selected.parent('label').text();
      $('#seq_runmode_type_name_selected').hide().show('normal').text(seq_runmode_type_name_selected);

      var seq_runread_types_selected = $("input:radio[name='seq_runread_type']").filter(':checked');
      var seq_runread_type_name_selected = seq_runread_types_selected.parent('label').text();
      $('#seq_runread_type_name_selected').hide().show('normal').text(seq_runread_type_name_selected);

      var seq_runcycle_types_selected = $("input:radio[name='seq_runcycle_type']").filter(':checked');
      var seq_runcycle_type_name_selected = seq_runcycle_types_selected.parent('label').text();
      $('#seq_runcycle_type_name_selected').hide().show('normal').text(seq_runcycle_type_name_selected);

      var lanes_per_seqtemplate_inputted = $('#lanes_per_seqtemplate').val();
      $('#lanes_per_seqtemplate_inputted').hide().show('normal').find('span').text(lanes_per_seqtemplate_inputted);
    }

    /*
     *
     * Build Handsontable
     *
     */
    //var $container = $('#handsontable-orderSamples-body');
    var $container = document.getElementById('handsontable-orderSamples-body');
    var $console = $('#handsontable-console');
    var $toolbar = $('#handsontable-toolbar');
    var sample_name_validator_fn = function (value, callback) {
    };

    var $samplePropertyTypesColumns = [
      {% for sample_property_type in sample_property_types %}
      "sample_property_type_id_{{ sample_property_type.id }}",
      {% endfor %}
    ];

    /*
     * Build $samplePropertyTypesDataSchema object.
     * @TODO it's not smart to make object but it's good to use code formatter of PhpStorm.
     */
    var $samplePropertyTypesDataSchema = {};
    {% for sample_property_type in sample_property_types %}
    $samplePropertyTypesDataSchema["{{ sample_property_type.id }}"] = null;
    {% endfor %}

    /*
     * Set up column width; if '' is shown but '0.1' is hidden.
     */
    //var $defaultColWidths = [100, 80, 80, 80, 40, 80, 80, 80, 80, 80,
    var $defaultColWidths = ['', '', '', '', '', '', '', '', '', ''];
    var $samplePropertyTypesChecked = {};
    {% for sample_property_type in sample_property_types %}
    {% set sample_property_type_id_str = "sample_property_type_id_" ~ sample_property_type.id %}
    {% if sample_property_types_checked.name[sample_property_type_id_str] is defined
      and sample_property_types_checked.name[sample_property_type_id_str] == "true" %}
    $defaultColWidths.push('');
    $samplePropertyTypesChecked["{{ sample_property_type_id_str }}"] = 'true';
    {% else %}
    $defaultColWidths.push('0.1');
    {% endif %}
    {% endfor %}
    //console.log($defaultColWidths);
    var $samplePropertyTypesColumnsStartIdx = 10; //@TODO First index number(begin by 0) of sample_property_types

    var hot = new Handsontable($container, {
      stretchH: 'all',
      rowHeaders: true,
      contextMenu: false,
      minSpareRows: 1,
      columnSorting: true,
      manualColumnResize: true,
      manualRowResize: true,
      //fixedColumnsLeft: 1,
      currentRowClassName: 'currentRow',
      autoWrapRow: true,
      autoColumnSize: true,
      search: true,
      copyPaste: true,
      data: [],
      dataSchema: {
        name: null,
        qual_concentration: null,
        qual_od260280: null,
        qual_od260230: null,
        qual_RIN: null,
        qual_fragmentsize: null,
        qual_nanodrop_conc: null,
        qual_volume: null,
        qual_amount: null,
        qual_date: null,
        sample_property_types: $samplePropertyTypesDataSchema
      },
      columns: [
        {data: 'name', title: 'Sample Name', type: 'text'},
        {data: 'qual_concentration', title: 'Conc. (ng/uL)', type: 'numeric', format: '0.000'},
        {data: 'qual_od260280', title: 'A260/A280', type: 'numeric', format: '0.00'},
        {data: 'qual_od260230', title: 'A260/A230', type: 'numeric', format: '0.00'},
        {data: 'qual_RIN', title: 'RIN', type: 'numeric', format: '0.00'},
        {data: 'qual_fragmentsize', title: 'Fragment Size', type: 'numeric'},
        {data: 'qual_nanodrop_conc', title: 'Conc. (ng/uL) (NanoDrop)', type: 'numeric', format: '0.000'},
        {data: 'qual_volume', title: 'Volume (uL)', type: 'numeric', format: '0.00'},
        {data: 'qual_amount', title: 'Total (ng)', type: 'numeric', format: '0.00'},
        {data: 'qual_date', title: 'QC Date', type: 'date', dateFormat: 'YYYY-MM-DD'},
        {% for sample_property_type in sample_property_types %}
        {
          data: 'sample_property_types.{{ sample_property_type.id }}',
          title: '{{ sample_property_type.name }}',
          type: 'text'
        },
        {% endfor %}
      ],
      //colWidths: $defaultColWidths,
      afterChange: function (changes, source) {
        if (source === 'loadData') {//not used now
          // don't save this change
        }
        else {
          // Enable 'Save', 'Undo' link on toolbar above of table after edit.
          //alert('afterChange');
          $toolbar.find('#save, #undo, #clear').removeClass('disabled');
          $console.text('Click Save to save data to server').removeClass().addClass('alert alert-info');

          //var sample_data_array = $container.handsontable('getData');
          var sample_data_array = hot.getSourceData();
          sample_data_array.pop(); //pop because last row is always null because of "minSpareRows: 1" option of handsontable.
          var sample_data = JSON.stringify(sample_data_array);
          setOrderSessionVal('sample', 0, sample_data);
          //console.log(source);
          //console.log(sample_data);
        }
      }

    });

    //var $handsontable = $container.handsontable('getInstance');
    var $handsontable = hot.getInstance();


    function loadData() {
      $.ajax({
        url: '{{ url("order/loadSessionSampleData") }}',
        dataType: 'json',
        type: 'POST',
        data: {}
      })
          .done(function (data) {
            //alert(data);
            //alert(location.href);
            $handsontable.loadData(data);
          });
    }

    //loadData(); // loading data at first.

    /*
     * Set column width of SamplePropertyTypes to 0.1 (not shown) or '' (auto column width) if sample has SampleProperty.
     */
    var changedColWidths = $defaultColWidths;
    //console.log(changedColWidths);


    $('#sample_property_types').children('option').each(function (index, domEle) {
      var actualColWidthIdx = index + $samplePropertyTypesColumnsStartIdx;
      if ($(domEle).attr('selected')) {
        changedColWidths[actualColWidthIdx] = '';
      } else {
        changedColWidths[actualColWidthIdx] = 0.1;
      }
    });

    //Change column width (Show checked sample_property_types column) on handsontable.
    $handsontable.updateSettings({'colWidths': changedColWidths});
    //console.log(changedColWidths);

    /*
     * Build 'Undo' function on toolbar
     */
    $toolbar.find('#undo').click(function () {
      // alert('undo! '+$handsontable.isUndoAvailable()+'
      // '+$handsontable.isRedoAvailable())
      $handsontable.undo();
      // $console.text('Undo!');
      if ($handsontable.isUndoAvailable()) {
        $toolbar.find('#undo').removeClass('disabled');
      } else {
        $toolbar.find('#undo').addClass('disabled');
      }

      if ($handsontable.isRedoAvailable()) {
        $toolbar.find('#redo').removeClass('disabled');
      } else {
        $toolbar.find('#redo').addClass('disabled');
      }
    });

    /*
     * Build 'Redo' function on toolbar
     */
    $toolbar.find('#redo').click(function () {
      // alert('redo! '+$handsontable.isUndoAvailable()+'
      // '+$handsontable.isRedoAvailable());
      $handsontable.redo();
      // $console.text('Redo!');
      if ($handsontable.isUndoAvailable()) {
        $toolbar.find('#undo').removeClass('disabled');
      } else {
        $toolbar.find('#undo').addClass('disabled');
      }

      if ($handsontable.isRedoAvailable()) {
        $toolbar.find('#redo').removeClass('disabled');
      } else {
        $toolbar.find('#redo').addClass('disabled');
      }
    });

    $toolbar.find('#clear').click(function () {
      $toolbar.find('#save, #undo, #redo, #clear').addClass('disabled');
      $console.text('All changes is discarded').removeClass().addClass('alert alert-success');
      $handsontable.loadData(null);
    });

    /*
     * Build sample_property_types multiselect on handsontable tool-bar
     */
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
              changedColWidths[actualColWidthIdx] = '';
            } else {
              changedColWidths[actualColWidthIdx] = 0.1;
            }
            $samplePropertyTypesChecked[$samplePropertyTypesColumns[i]] = checked;
          }
        }
        //Set session value for sample_property_types checked of checked/unchecked.
        setOrderSessionVal('sample_property_types_checked', 0, $samplePropertyTypesChecked);
        console.log($samplePropertyTypesChecked);

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

    /*
     * Clear session saved values on all forms.
     */
    $('#removeOrderSession').click(function () {
      $.ajax({
        url: '{{ url("order/removeOrderSession") }}',
        type: 'POST',
        data: {}
      })
          .done(function () {
            window.location.reload();
          });
    });
  });

</script>