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
        </tr>
        </thead>
        <tbody>
        {% for index in lane_index %}
          {% set lane_number = index + 1 %}
          <tr>
            {% if seqlanes[index] is defined %}
              {% set seqlane = seqlanes[index] %}
              <td>{{ seqlane.number }}</td>
              {% if seqlane.is_control == 'Y' %}
                <td class="info">Control</td>
              {% else %}
                <td class="success">{{ seqlane.getSeqtemplates().name }}</td>
              {% endif %}
            {% else %}
              <td>{{ lane_number }}</td>
              <td class="warning">NULL</td>
            {% endif %}
          </tr>
        {% endfor %}
        </tbody>
      </table>
    </div>
  </div>
</div>
