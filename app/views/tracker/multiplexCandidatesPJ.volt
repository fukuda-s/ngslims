<ul class="nav nav-tabs">
  <li>{{ link_to('tracker/multiplexCandidates/' ~ step.id ~ '?view_type=PI', 'PI') }}</li>
  <li class="active"><a href="#">Project</a></li>
  <li>{{ link_to('tracker/multiplexCandidates/' ~ step.id ~ '?view_type=CP', 'Cherry Picking') }}</li>
  <li>{{ link_to('tracker/multiplexCandidates/' ~ step.id ~ '?view_type=SP', 'Search Picking') }}</li>
</ul>
<div class="panel-group" id="projectOverview">
  {% for project in projects %}
    {% if loop.first %}
      <div class="panel panel-default">
        <div class="panel-heading">
          <div class="row">
            <div class="col-md-6">Project Name</div>
            <div class="col-md-3">PI Name</div>
            <div class="col-md-1">
              <small>#seqlib</small>
            </div>
            <div class="col-md-2">
              <button type="button" class="btn btn-default btn-xs" id="show-inactive-panel">
                <div>Show Completed/On Hold</div>
                <div style="display: none">Hide Completed/On Hold</div>
              </button>
            </div>
          </div>
        </div>
      </div>
    {% endif %}

    {% if project.seqlib_count_all !== project.seqlib_count_used %}
      {% set active_status = 'active' %}
      {% set seqlib_count = project.seqlib_count_all - project.seqlib_count_used %}
    {% else %}
      {% set active_status = 'inactive' %}
      {% set seqlib_count = project.seqlib_count_all %}
    {% endif %}

    <div {% if active_status is 'active' %} class="panel panel-info" id="project_id_{{ project.p.id }}"
    {% else %} class="panel panel-default collapse" id="inactives-{{ project.p.id }}" {% endif %}>
      <div class="panel-heading" data-toggle="collapse"
           data-target="#seqlib-tube-list-target-id-{{ project.p.id }}-0" id="OwnerList" onclick="showTubeSeqlibs({{ step.id }}, {{ project.p.id  }}, 0)">
        <h4 class="panel-title">
          <div class="row">
            <div class="col-md-6">
              <div class="">{{ project.p.name }}</div>
            </div>
            <div class="col-md-3">
              <div class="">{{ project.u.getFullname() }}</div>
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
      <div class="collapse" id="seqlib-tube-list-target-id-{{ project.p.id }}-0">
      </div>
    </div>
    {% elsefor %} No projects are recorded
  {% endfor %}
</div>