{{ content() }}
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
          <th>Apply Conc.(pM)</th>
          <th>Is Control</th>
        </tr>
        </thead>
        <tbody>
        {% for lane_number in lane_index %}
          <tr>
            {% if seqlanes[lane_number] is defined %}
              {% set seqlane = seqlanes[lane_number] %}
              <td>{{ lane_number }}</td>
              <td class="success">{{ seqlane['seqtemplate_name'] }}</td>
              {% if seqlanes_add[lane_number] is defined %}
                {% set seqlane_add = seqlanes_add[lane_number] %}
                <td class="success">{{ seqlane_add['apply_conc'] }}</td>
                <td class="success">{{ seqlane_add['is_control'] }}</td>
              {% else %}
                <td class="success"></td>
                <td class="success"></td>
              {% endif %}
            {% else %}
              <td>{{ lane_number }}</td>
              <td class="warning">NULL</td>
              <td class="warning"></td>
              <td class="warning"></td>
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
  $(document).ready(function () {
    /*
     * Build function for #flowcell-setup-button
     */
    $("#flowcell-save-button").click(function () {
      $.ajax({
        url: '{{ url("tracker/flowcellSetupSave/") ~ step.id }}',
        dataType: 'json',
        type: 'POST',
        data: {}
      })
          .done(function () {
            //$('#flowcell-save-button').prop('disabled', true);
            //console.log('done');
            window.location = "{{ url("tracker/flowcellSetupCandidates/") ~ step.id }}"
          })
          .fail(function () {
            //console.log('fail');
            window.location = "{{ url("tracker/flowcellSetupConfirm/") ~ step.id }}"
          });
    });
  });
</script>
