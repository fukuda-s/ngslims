<ol class="breadcrumb">
  <li>
    {{ link_to('tracker', 'Tracker') }}
  </li>
  <li>
    {{ link_to('tracker/experiments/' ~ step.step_phase_code , step.StepPhases.description ~ ' View' ) }}
  </li>
  <li>
    {{ link_to('tracker/flowcellSetupCandidates/' ~ step.id, step.name) }}
  </li>
  <li class="active">
    Confirm
  </li>
</ol>
{{ flashSession.output() }}
<div class="row">
  <div class="col-md-12">
    <div class="panel panel-info" id="flowcell-panel">
      <div class="panel-heading">
        <h3 class="panel-title">Flowcell : {{ flowcell_name }}</h3>
      </div>
      <table class="table table-bordered table-hover table-condensed table-responsive">
        <thead>
        <tr>
          <th>Lane #</th>
          <th style="width: 70%;">Seqtemplate Name</th>
          <th style="width: 15%;">Apply Conc.(pM)</th>
          <th>Control Lane</th>
        </tr>
        </thead>
        <tbody id="flowcell-tbody">
        {% for lane_number in lane_index %}
          {% if seqlanes[lane_number] is defined %}
            {% set seqlane = seqlanes[lane_number] %}
            <tr class="success">
              <td>{{ seqlane["seqlane_number"] }}</td>
              <td>{{ seqlane["seqtemplate_name"] }}</td>
              <td>{{ text_field('apply_conc-' ~ seqlane["seqlane_number"], 'class': 'form-control input-sm') }}</td>
              {% if seqlane["is_control"] is 'Y' %}
                <td>{{ check_field('is_control-' ~ seqlane["seqlane_number"], 'class': 'checkbox', 'checked': 'checked', 'disabled': 'disabled') }}</td>
              {% else %}
                <td>{{ check_field('is_control-' ~ seqlane["seqlane_number"], 'class': 'checkbox') }}</td>
              {% endif %}
            </tr>
          {% else %}
            <tr class="warning">
              <td>{{ lane_number }}</td>
              <td>NULL</td>
              <td>NULL</td>
              <td>NULL</td>
            </tr>
          {% endif %}
        {% endfor %}
        </tbody>
      </table>
      <div class="panel-footer clearfix">
        <button id="flowcell-save-button" type="button" class="btn btn-success pull-right">Save Flowcell
          Setup &raquo;</button>
      </div>
    </div>
  </div>
</div>
<script>
  $(document).ready(function () {
    $("#flowcell-save-button").click(function () {
      var seqlanes_add = new Object();
      $('#flowcell-tbody').children('tr.success').each(function () {
        var lane_number = $(this).index() + 1;
        var apply_conc = $(this).find('input[id^=apply_conc-]').val();
        var is_control = 'N';
        if ($(this).find('input[id^=is_control-]').prop('checked')) {
          is_control = 'Y';
        }
        seqlanes_add[lane_number] = {lane_number: lane_number, apply_conc: apply_conc, is_control: is_control};
      });
      console.log(seqlanes_add);

      $.ajax({
        url: '{{ url("tracker/flowcellSetupSave/") ~ step.id }}',
        dataType: 'json',
        type: 'POST',
        data: {
          seqlanes_add: seqlanes_add
        }
      })
          .done(function (data) {
            $('#flowcell-save-button').prop('disabled', true);
            console.log(data);
            var flowcell_id = data["id"];
            window.location = "{{ url("tracker/flowcell/")}}" + flowcell_id
          })
          .fail(function (data) {
            console.log(data);
            window.location = "{{ url("tracker/flowcellSetupConfirm/") ~ step.id }}"
          });


    });
  })
</script>
