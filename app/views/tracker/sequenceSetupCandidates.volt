<ol class="breadcrumb" xmlns="http://www.w3.org/1999/html">
  <li>
    {{ link_to('tracker', 'Tracker') }}
  </li>
  <li>
    {{ link_to('tracker/sequence/', 'Sequencing Run Setup View' ) }}
  </li>
  <li class="active">
    {{ instrument_type.name }}
  </li>
</ol>
{{ flashSession.output() }}
{{ form('tracker/sequenceSetupConfirm/' ~ instrument_type.id, 'id': 'sequenceSetupForm', 'onbeforesubmit': 'return false') }}
<div class="row">
  <div class="col-md-12">
    <div class="panel panel-primary" id="sequencer-panel">
      <div class="panel-heading">
        <h3 class="panel-title">{{ instrument_type.name }}</h3>
      </div>
      <div class="panel-body">
        <div id="seq_instruments_select" class="form-group">
          <label for="instrument_id">Instrument</label>
          {{ select("instrument_id", instruments, "using": ["id", "name"], 'useEmpty': true, 'emptyText': 'Please, choose instrument...', 'emptyValue': '@', 'class': 'form-control input-sm') }}
        </div>
        <div id="run_stated_date_input" class="form-group">
          <label for="run_started_date">Run Started Date</label>
          {{ date_field('run_started_date' , 'class': 'input-sm') }}
        </div>
        <div id="seq_runmode_types_checkbox" class="form-group">
          <label>Run Mode</label>
        </div>
        <hr>
        {% for slot in slots_per_run %}
          <h4>Slot{{ slot }}</h4>
          <div id="run_number_input_{{ slot }}" class="form-group" slot="{{ slot }}">
            <label for="{{ 'run_number_' ~ slot }}">Run Number</label>
            {{ numeric_field('run_number_' ~ slot , 'class': 'input-sm') }}
          </div>

          <div id="seq_runread_types_checkbox_{{ slot }}" class="form-group" slot="{{ slot }}">
            <label>Read Type</label>
          </div>
          <div id="seq_runcycle_types_checkbox_{{ slot }}" class="form-group" slot="{{ slot }}">
            <label>Read Cycle</label>
          </div>
          <div id="seq_flowcells_select_{{ slot }}" class="form-group" slot="{{ slot }}">
            <label for="flowcell_id_{{ slot }}">Flowcell</label>
            {% for flowcell in flowcells %}
              {% if loop.first %}
                <select id="flowcell_id_{{ slot }}" name="flowcell_id_{{ slot }}" class="form-control input-sm">
                <option value="@">Please, choose flowcell...</option>
              {% endif %}
              <option value="{{ flowcell.fc.id }}"
                      seq_runmode_type_id="{{ flowcell.fc.seq_runmode_type_id }}">{{ flowcell.fc.name }}</option>
              {% if loop.last %}
                </select>
              {% endif %}
            {% endfor %}
          </div>
          {% if loop.last %}
          {% else %}
            <hr>
          {% endif %}
        {% endfor %}
      </div>
      <div class="panel-footer clearfix">
        <button id="flowcell-clear-button" type="button" class="btn btn-default" disabled>Clear Flowcell Setup</button>
        {{ submit_button('Confirm Flowcell Setup »', 'class': 'btn btn-primary pull-right') }}
      </div>
    </div>
  </div>
</div>
</form>
<hr>
<div class="row">
  <div class="col-md-12">
    {% for flowcell in flowcells %}
      {% if loop.first %}
        <div class="panel panel-default">
        <div class="panel-heading">
          <div class="row">
            <div class="col-md-4">Available Flowcells</div>
            <div class="col-md-4">Flowcell Required Seq Run Type</div>
            <div class="col-md-4">Request Required Seq Run Type</div>
          </div>
        </div>
        <div class="panel-group">
      {% endif %}
      <div class="panel panel-info" id="flowcell-panel-{{ flowcell.fc.id }}">
        <div class="panel-heading" id="flowcell-header-{{ flowcell.fc.id }}" data-toggle="collapse"
             href="#seqtemplate-tube-list-flowcell-id-{{ flowcell.fc.id }}"
             onclick="showTubeSeqtemplates({{ flowcell.fc.id }})">
          <div class="row">
            <div class="col-md-4">
              {{ flowcell.fc.name }}
            </div>
            <div class="col-md-4">
              {{ flowcell.fcsrmt.name }}
            </div>
            <div class="col-md-4">
              {{ flowcell.seqrun_prop_name }}
            </div>
          </div>
        </div>
        <div id="seqtemplate-tube-list-flowcell-id-{{ flowcell.fc.id }}" class="panel-collapse collapse"></div>
      </div>
      {% if loop.last %}
        </div>
        </div>
      {% endif %}
      {% elsefor %} No flowcells recorded
    {% endfor %}
  </div>
</div>
<script>
  /*
   * Function to set selected values to session.
   * @TODO Should I use "ajaxSuccess" function?
   */
  function setOrderSessionVal(column, id, name) {
    $.ajax({
      url: '{{ url('order/orderSetSession/')}}',
      dataType: 'html',
      type: 'POST',
      data: { column: column, id: id, name: name}
    })
        .done(function (data) {
          $('#flash').html(data);
          console.log(column + " : " + id + " : " + name);
        });
  }

  function showTubeSeqtemplates(flowcell_id) {
    target_id = '#seqtemplate-tube-list-flowcell-id-' + flowcell_id;
    $.ajax({
      url: '{{ url("trackerdetails/showTubeSeqtemplates") }}',
      dataType: 'html',
      type: 'POST',
      data: {
        flowcell_id: flowcell_id
      }
    })
        .done(function (data) {
          $(target_id).html(data);
          //console.log(target_id);
        });
  }

  function showPopoverTableSeqlibs(obj, seqtemplate_id, seqtemplate_name, seqlane_id) {
    var target_id = '#seqlane-tube-seqlane-id-' + seqlane_id;
    $.ajax({
      url: '{{ url("trackerdetails/showTableSeqlibs") }}',
      dataType: 'html',
      type: 'POST',
      data: {
        seqtemplate_id: seqtemplate_id
      }
    })
        .done(function (data) {
          $(target_id).popover({
            title: "Seqlibs in " + seqtemplate_name,
            content: data,
            html: true,
            placement: "auto"
          });
          //console.log(target_id);
        });
  }

  function getSeqRunmodeTypesList(instrument_type_id) {
    $.ajax({
      url: '{{ url('order/seqRunmodeTypesSelectList/')}}',
      dataType: 'html',
      type: 'POST',
      data: { instrument_type_id: instrument_type_id }
    })
        .done(function (data) {
          $('#seq_runmode_types_checkbox').html(data);

          //Refresh seq_runread_types_checkbox when seq_runmode_type_id has session value
          var seq_runmode_type_id_selected = $("input:radio[name='seq_runmode_type_id']").filter(':checked').val();
          $('[id^=seq_runread_types_checkbox_]').each(function () {
            var slot = $(this).attr('slot');
            //console.log(instrument_type_id + " : " + seq_runmode_type_id_selected + " : " + slot);
            getSeqRunreadTypesList(instrument_type_id, seq_runmode_type_id_selected, slot);
          });

          //Except un-selected runmode flowcells.
          $('select[id^=flowcell_id_]').each(function () {
            //Once remove attribute 'disabled' from all options.
            $(this).find('option').removeAttr("disabled");
            $(this).find('option[seq_runmode_type_id!=' + seq_runmode_type_id_selected + ']').each(function () {
              $(this).attr("disabled", "disabled");
            });
          });

          //Change seq_runmode_type_name_selected value on right side summary with selected values
          $("input:radio[name='seq_runmode_type_id']").on('change', function () {
            var seq_runmode_type_id_selected = $(this).filter(':checked').val();
            var seq_runmode_type_name_selected = $(this).filter(':checked').parent('label').text();

            //Excepted un-selected runmode flowcells.
            $('select[id^=flowcell_id_]').each(function () {
              //Once remove attribute 'disabled' from all options.
              $(this).find('option').removeAttr("disabled");
              $(this).find('option[seq_runmode_type_id!=' + seq_runmode_type_id_selected + ']').each(function () {
                if ($(this).val() != "@") {
                  $(this).attr("disabled", "disabled");
                  $(this).filter(":selected").attr("selected", false);
                }
              });
            });

            //Set selected seq_runmode_type to session values.
            setOrderSessionVal('seq_runmode_type', seq_runmode_type_id_selected, seq_runmode_type_name_selected);

            //Refresh seq_runread_types_checkbox when seq_runmode_type_id is changed
            $('[id^=seq_runread_types_checkbox_]').each(function () {
              var slot = $(this).attr('slot');
              getSeqRunreadTypesList(instrument_type_id, seq_runmode_type_id_selected, slot);
            })
          });
        });

  }

  function getSeqRunreadTypesList(instrument_type_id, seq_runmode_type_id, slot) {
    var seq_runread_types_checkbox_attr = '#seq_runread_types_checkbox_' + slot;
    var seq_runread_type_id_attr = 'seq_runread_type_id_' + slot;
    $.ajax({
      url: '{{ url('order/seqRunreadTypesSelectList/')}}',
      dataType: 'html',
      type: 'POST',
      data: { instrument_type_id: instrument_type_id, seq_runmode_type_id: seq_runmode_type_id, slot: slot }
    })
        .done(function (data) {
          $(seq_runread_types_checkbox_attr).html(data);
          //console.log(seq_runread_types_checkbox_attr + ' replaced.')

          //Refresh seq_runcycle_types_checkbox when seq_runread_type_id has session value
          var seq_runread_type_id_selected = $('input:radio[name=' + seq_runread_type_id_attr + ']').filter(':checked').val();
          getSeqRuncycleTypesList(instrument_type_id, seq_runmode_type_id, seq_runread_type_id_selected, slot);

          //Change seq_runread_type_name_selected value on right side summary with selected values
          $('input:radio[name=' + seq_runread_type_id_attr + ']').on('change', function () {
            var seq_runread_type_id_selected = $(this).filter(':checked').val();
            var seq_runread_type_name_selected = $(this).filter(':checked').parent('label').text();

            //Set selected seq_runread_type to session values.
            setOrderSessionVal('seq_runread_type', seq_runread_type_id_selected, seq_runread_type_name_selected);

            //Refresh seq_runcycle_types_checkbox when seq_runread_type_id is changed
            getSeqRuncycleTypesList(instrument_type_id, seq_runmode_type_id, seq_runread_type_id_selected, slot);
          });
        });
  }

  function getSeqRuncycleTypesList(instrument_type_id, seq_runmode_type_id, seq_runread_type_id, slot) {
    $.ajax({
      url: '{{ url('order/seqRuncycleTypesSelectList/')}}',
      dataType: 'html',
      type: 'POST',
      data: { instrument_type_id: instrument_type_id, seq_runmode_type_id: seq_runmode_type_id, seq_runread_type_id: seq_runread_type_id, slot: slot }
    })
        .done(function (data) {
          var seq_runcycle_types_checkbox_attr = '#seq_runcycle_types_checkbox_' + slot;
          var seq_runcycle_type_id_attr = 'seq_runcycle_type_id_' + slot;
          $(seq_runcycle_types_checkbox_attr).html(data);
          //Change seq_runcycle_type_name_selected value on right side summary with selected values
          $('input:radio[name=' + seq_runcycle_type_id_attr + ']').on('change', function () {
            var seq_runcycle_type_id_selected = $(this).filter(':checked').val();
            var seq_runcycle_type_name_selected = $(this).filter(':checked').parent('label').text();

            //Set selected seq_runcycle_type to session values.
            setOrderSessionVal('seq_runcycle_type', seq_runcycle_type_id_selected, seq_runcycle_type_name_selected);
          });
        });
  }

  $(document).ready(function () {
    //Refresh seq_runmode_types_checkbox
    getSeqRunmodeTypesList({{ instrument_type.id }});

    //Hide flowcell when the flowcell_id is selected at seq_flowcells_select.
    $('select[id^=flowcell_id_]').each(function () {
      $(this).on('change', function () {
        var changed_select_id = $(this).attr('id');
        var flowcell_id = $(this).find('option:selected').val();

        $('select[id^=flowcell_id_]').each(function () {
          var another_select_id = $(this).attr('id');
          if (changed_select_id != another_select_id) { //Skip same select[id^=flowcell_id_].
            $(this).find('option[value!=' + flowcell_id + ']').each(function () {
              var seq_runmode_type_id_selected = $("input:radio[name='seq_runmode_type_id']").filter(':checked').val();
              var seq_runmode_type_id = $(this).attr("seq_runmode_type_id");
              if (seq_runmode_type_id == seq_runmode_type_id_selected) { //Keep disable for unexpected seq_runmode_type flowcell.
                //console.log(seq_runmode_type_id_selected + " : " + seq_runmode_type_id);
                $(this).removeAttr("disabled");
              }
            });
            $(this).find('option[value=' + flowcell_id + ']').attr("disabled", "disabled");
            //console.log(another_select_id + ' : ' + flowcell_id);
          }
        });

      });
    });
  })

</script>
