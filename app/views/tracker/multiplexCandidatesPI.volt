<ul class="nav nav-tabs">
  <li class="active"><a href="#">PI</a></li>
  <li>{{ link_to('tracker/multiplexCandidates/' ~ step.id ~ '?view_type=PJ', 'Project') }}</li>
  <li>{{ link_to('tracker/multiplexCandidates/' ~ step.id ~ '?view_type=CP', 'Cherry Picking') }}</li>
</ul>
<div class="panel-group" id="projectOverview">
  {% for user in pi_users %}
    {% if loop.first %}
      <div class="panel panel-default">
        <div class="panel-heading">
          <div class="row">
            <div class="col-md-8">PI Name</div>
            <div class="col-md-1">
              <small>#project</small>
            </div>
            <div class="col-md-1">
              <small>#seqlib</small>
            </div>
            <div class="col-md-2">
              <button type="button" class="btn btn-default btn-xs" id="show-inactive-panel" data-toggle="collapse"
                      data-target="[id^=inactives]">
                Show Completed/On Hold
              </button>
            </div>
          </div>
        </div>
      </div>
    {% endif %}

    {% if user.seqlib_count_all !== user.seqlib_count_used %}
      {% set active_status = 'active' %}
      {% set seqlib_count = user.seqlib_count_all - user.seqlib_count_used %}
    {% else %}
      {% set active_status = 'inactive' %}
      {% set seqlib_count = user.seqlib_count_all %}
    {% endif %}

    <div {% if active_status is 'active' %} class="panel panel-info" id="pi_user_id_{{ user.u.id }}"
    {% else %} class="panel panel-default collapse" id="inactives-{{ user.u.id }}" {% endif %}>
      <div class="panel-heading" data-toggle="collapse"
           data-target="#list_user_id_{{ user.u.id }}" id="OwnerList">
        <h4 class="panel-title">
          <div class="row">
            <div class="col-md-8">
              <div class="">{{ user.u.getFullname() }}</div>
            </div>
            <div class="col-md-1">
              <span class="badge">{{ user.project_count_all }}</span>
            </div>
            <div class="col-md-2">
              <span class="badge">{{ seqlib_count }}</span>
            </div>
            <div class="col-md-1">
              <i class="indicator glyphicon glyphicon-chevron-right pull-right"></i>
            </div>
          </div>
        </h4>
      </div>
      <ul class="list-group collapse" id="list_user_id_{{ user.u.id }}">
        {{ elements.getTrackerMultiplexCandidatesProjectList( user.u.id, step.step_phase_code, step.id ) }}
      </ul>
    </div>
    {% elsefor %} No projects are recorded
  {% endfor %}
</div>