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
{{ flashSession.output() }}
<div class="panel-group" id="projectOverview">
  {% for user in pi_users %}
    {% if loop.first %}
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
              <button type="button" class="btn btn-default btn-xs" id="show-inactive" data-toggle="collapse"
                      data-target="[id^=inactives]">
                Show Completed/On Hold
              </button>
            </div>
          </div>
        </div>
      </div>
    {% endif %}

    {% if user.status is empty or user.status is 'In Progress' %}
      {% set active_status = 'active' %}
    {% else %}
      {% set active_status = 'inactive' %}
    {% endif %}

    <div {% if active_status is 'active' %} class="panel panel-info" id="pi_user_id_{{ user.u.id }}"
    {% else %} class="panel panel-default collapse" id="inactives-{{ user.u.id }}" {% endif %}>
      <div class="panel-heading" data-toggle="collapse"
           data-target="#list_user_id_{{ user.u.id }}[status='{{ user.status }}']" id="OwnerList">
        <h4 class="panel-title">
          <div class="row">
            <div class="col-md-8">
              <div class="">{{ user.u.getFullname() }}</div>
            </div>
            <div class="col-md-1">
          <span
              class="badge">{{ user.project_count }}</span>
            </div>
            <div class="col-md-1">
          <span
              class="badge">{{ user.sample_count }}</span>
            </div>
            <div class="col-md-1">
              {{ user.status }}
            </div>
            <div class="col-md-1">
              <i class="indicator glyphicon glyphicon-chevron-right pull-right"></i>
            </div>
          </div>
        </h4>
      </div>
      <ul class="list-group collapse" id="list_user_id_{{ user.u.id }}" status="{{ user.status }}">
        {{ elements.getTrackerExperimentDetailProjectList( user.u.id, step.step_phase_code, step.id, user.status ) }}
      </ul>
    </div>
    {% elsefor %} No projects are recorded
  {% endfor %}
</div>
<script>
  $(document).ready(function () {
    /*
     * If URL has #pi_user_id_ then open collapsed panel-body
     */
    if (location.search) {
      var pi_user_id = $.getUrlVar('pi_user_id');
      var status = decodeURIComponent($.getUrlVar('status'));
      if(status === 'NULL'){
        status = '';
      }
      console.log(pi_user_id + ":" + status);
      $('#list_user_id_' + pi_user_id + '[status=\'' + status + '\']')
          .addClass('in')
          .parents('.panel')
          .addClass('in');
    }

    $('[id^=inactives]')
        .first()
        .on('hidden.bs.collapse', function () {
          var buttonObj = $('button#show-inactive')
          var buttonStr = buttonObj.text().replace('Hide', 'Show');
          buttonObj.text(buttonStr);
        })
        .on('shown.bs.collapse', function () {
          var buttonObj = $('button#show-inactive')
          var buttonStr = buttonObj.text().replace('Show', 'Hide');
          buttonObj.text(buttonStr);
        });
  });
</script>
