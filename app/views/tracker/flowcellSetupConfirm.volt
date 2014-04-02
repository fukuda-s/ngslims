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
    <div class="panel panel-success" id="flowcell-panel">
      <div class="panel-heading">
        <h3 class="panel-title">Flowcell : {{ flowcell_name }}</h3>
      </div>
      <table class="table table-bordered table-hover table-condensed table-responsive">
        <thead>
        <tr>
          <th>Lane #</th>
          <th>Seqtemplate Name</th>
        </tr>
        </thead>
        <tbody>
        {% for index in lane_index %}
          {% set lane_number = index + 1 %}
          <tr>
            {% if seqlanes[index] is defined %}
              {% set seqlane = seqlanes[index] %}
              <td>{{ seqlane["seqlane_number"] }}</td>
              <td class="success">{{ seqlane["seqtemplate_name"] }}</td>
            {% else %}
              <td>{{ lane_number }}</td>
              <td class="warning">NULL</td>
            {% endif %}
          </tr>
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
  $(document).ready(function(){
    $("#flowcell-save-button").click(function(){
      $.ajax({
        url: '{{ url("tracker/flowcellSetupSave/") ~ step.id }}',
        dataType: 'json',
        type: 'POST',
        data: {
        }
      })
          .done(function (data) {
            $('#flowcell-save-button').prop('disabled',true);
            console.log(data);
            var flowcell_id = data["id"];
            window.location = "{{ url("tracker/flowcell/")}}"+flowcell_id
          })
          .fail(function(data) {
            console.log(data);
            window.location = "{{ url("tracker/flowcellSetupConfirm/") ~ step.id }}"
          })


    });
  })
</script>
