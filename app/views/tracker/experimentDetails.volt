<ol class="breadcrumb">
  <li>
    {{ link_to('tracker', 'Tracker') }}
  </li>
  <li>
    {{ link_to('tracker/experiments/' ~ step.step_phase_code , step.StepPhases.description ~ ' View' ) }}
  </li>
  <li class="active">
    {{ step.name }}
  </li>
</ol>
{% for user in pi_users %}
  {% if loop.first %}
    <div class="panel-group" id="projectOverview">
    <div class="panel panel-default">
      <div class="panel-heading">
        <div class="row">
          <div class="col-md-8">PI</div>
          <div class="col-md-1">
            <small>#project</small>
          </div>
          <div class="col-md-1">
            <small>#sample</small>
          </div>
          <div class="col-md-2">
            <button type="button" class="btn btn-default btn-xs" id="show-inactive"  data-toggle="collapse" data-target=".panel-default#inactives" style="min-width: 87px">Show
              inactive
            </button>
          </div>
        </div>
      </div>
    </div>
  {% endif %}


  <div class="panel {% if user.project_count > 0 %}panel-info"{% else %}panel-default
                                                              collapse" id="inactives"{% endif %}>
  <div class="panel-heading" data-toggle="collapse" href="#user_id_{{ user.id }}" id="OwnerList">
    <h4 class="panel-title">
      <div class="row">
        <div class="col-md-8">
          <div class="">{{ user.name }}</div>
        </div>
        <div class="col-md-1">
          <span class="badge">{{ user.project_count }}</span>
        </div>
        <div class="col-md-1">
          <span class="badge">{{ user.sample_count }}</span>
        </div>
        <div class="col-md-2">
          <i class="indicator glyphicon glyphicon-chevron-right pull-right"></i>
        </div>
      </div>
    </h4>
  </div>
  <ul class="list-group">
    <div id="user_id_{{ user.id }}" class="panel-body panel-collapse collapse">
      {{ elements.getTrackerExperimentDetailProjectList( user.id, step.nucleotide_type, step.step_phase_code, step.id ) }}
    </div>
  </ul>
  </div>
  {% if loop.last %}
    </div>
  {% endif %}
{% else %} No projects are recorded
{% endfor %}
