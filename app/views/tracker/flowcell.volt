{{ content() }}
{{ flashSession.output() }}
<div class="row">
  <div class="col-md-12">
    <div class="panel panel-success" id="flowcell-panel">
      <div class="panel-heading">
        <h3 class="panel-title">Flowcell : {{ flowcell.name }}</h3>
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
              <td>{{ seqlane.number }}</td>
              {% if seqlane.seqtemplate_id != "" %}
                <td class="success">{{ seqlane.getSeqtemplates().name }}</td>
              {% elseif seqlane.control_id != "" %}
                <td class="success">{{ seqlane.getControls().name }}</td>
              {% endif %}
                <td class="success">{{ seqlane.apply_conc }}</td>
                <td class="success">{{ seqlane.is_control }}</td>
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
    </div>
  </div>
</div>
