{{ content() }}
<div class="panel-group" id="projectOverview">
  <div class="panel panel-default">
    <div class="panel-heading">
      <div class="row">
        <div class="col-md-6">Project Name</div>
        <div class="col-md-3">PI Name</div>
        <div class="col-md-1">
          <small>#sample</small>
        </div>
        <div class="col-md-2">
        </div>
      </div>
    </div>
  </div>
  {% for project in projects %}
  <div class="panel panel-success">
    <div class="panel-heading" data-toggle="collapse" href="#project_panel_body_{{ project.id }}">
      <h4 class="panel-title">
        <div class="row">
          <div class="col-md-6">
            <div class="">{{ project.name }}</div>
          </div>
          <div class="col-md-3">
            {% if project.pi_user_id > 0 and project.PIs is defined %}
              <div class="">{{ project.PIs.getFullname() }}</div>
            {% else %}
              <div class="">(Undefined)</div>
            {% endif %}
          </div>
          <div class="col-md-1">
            <span class="badge">{{ project.Samples|length }}</span>
          </div>
          <div class="col-md-2">
            <a href="#" rel="tooltip" data-placement="right" data-original-title="Edit Project"><i
                  class="glyphicon glyphicon-pencil"></i></a> <i
                class="indicator glyphicon glyphicon-chevron-right pull-right"></i>
          </div>
      </h4>
    </div>
    <div class="panel-body collapse" id="project_panel_body_{{ project.id }}">
      {{ link_to("trackerdetails/showTableSamples/" ~ project.id ~ "?pre=projectName", "Details") }}
    </div>
  </div>
{% elsefor %} No projects are recorded
{% endfor %}
</div>
