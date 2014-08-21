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
    {% if project.Samples|length == 0 %}
      {% continue %}
    {% endif %}
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
        <p>
          {{ link_to("trackerdetails/showTableSamples/" ~ project.id ~ "?pre=projectName", "» Link to detail of project samples") }}
        </p>
        <div class="progress-label">QC</div>
        <div class="progress">
          {% if project.Samples.StepEntries is defined
            and project.Samples|length == project.Samples.StepEntries|length %}
            {% set samples = project.Samples %}
            {% set sample_num = samples.StepEntries|length %}
            {% set complete_num = samples.getStepEntries("status = 'Completed'")|length %}
            {% set complete_rate = complete_num / sample_num * 100 %}
            {% set inprogress_num = samples.getStepEntries("status = 'In Progress'")|length %}
            {% set inprogress_rate = inprogress_num / sample_num * 100 %}
            {% set onhold_num = samples.getStepEntries("status = 'On Hold'")|length %}
            {% set onhold_rate = onhold_num / sample_num * 100 %}
            <div class="progress-bar progress-bar-success" style="width: {{ complete_rate }}%">
              {{ complete_num ~ '/' ~ sample_num ~ ' (' ~ complete_rate ~ '%)' }}
              <span class="sr-only">{{ complete_rate }}% Completed</span>
            </div>
            <div class="progress-bar progress-bar-warning" style="width: {{ inprogress_rate }}%">
              {{ inprogress_num ~ '/' ~ sample_num ~ ' (' ~ inprogress_rate ~ '%)' }}
              <span class="sr-only">{{ inprogress_rate }}% In Progress</span>
            </div>
            <div class="progress-bar progress-bar-danger" style="width: {{ onhold_rate }}%">
              {{ onhold_num ~ '/' ~ sample_num ~ ' (' ~ onhold_rate ~ '%)' }}
              <span class="sr-only">{{ onhold_rate }}% On Hold</span>
            </div>
          {% else %}
            {% set sample_num = project.Samples|length %}
            {% set complete_num = project.getSamples("qual_date IS NOT NULL")|length %}
            {% set complete_rate = complete_num / sample_num * 100 %}
            <div class="progress-bar progress-bar-success" style="width: {{ complete_rate }}%">
              {{ complete_num ~ '/' ~ sample_num ~ ' (' ~ complete_rate ~ '%)' }}
              <span class="sr-only">{{ complete_rate }}% Complete (success)</span>
            </div>
          {% endif %}
        </div>
        <div class="progress-label">SeqLib</div>
        <div class="progress">
          <div class="progress-bar progress-bar-success" style="width: 35%">
            35%
            <span class="sr-only">35% Complete (success)</span>
          </div>
          <div class="progress-bar progress-bar-warning progress-bar-striped" style="width: 20%">
            <span class="sr-only">20% Complete (warning)</span>
          </div>
          <div class="progress-bar progress-bar-danger" style="width: 10%">
            <span class="sr-only">10% Complete (danger)</span>
          </div>
        </div>
        <div class="progress-label">SeqRun</div>
        <div class="progress">
          <div class="progress-bar progress-bar-success" style="width: 35%">
            35%
            <span class="sr-only">35% Complete (success)</span>
          </div>
          <div class="progress-bar progress-bar-warning progress-bar-striped" style="width: 20%">
            <span class="sr-only">20% Complete (warning)</span>
          </div>
          <div class="progress-bar progress-bar-danger" style="width: 10%">
            <span class="sr-only">10% Complete (danger)</span>
          </div>
        </div>
      </div>
    </div>
    {% elsefor %} No projects are recorded
  {% endfor %}
</div>
