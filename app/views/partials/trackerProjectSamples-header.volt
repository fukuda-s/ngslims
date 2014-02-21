{% if type == 'SHOW' %}
  <ol class="breadcrumb">
    <li>{{ link_to("tracker", "Tracker") }}</li>
    <li>{{ link_to("tracker/project", "Project Overview") }}</li>
    <li>{{ project.PIs.getName() }}</li>
    <li class="active">{{ project.name }}</li>
  </ol>
  <div
      align="left">{{ link_to("trackerProjectSamples/showTableSamples/" ~ project.id, "<< Back to Sample Info", "class": "btn btn-primary") }}</div>
{% else %}
  <ol class="breadcrumb">
    <li>{{ link_to("tracker", "Tracker") }}</li>
    <li>{{ link_to('tracker/experiments/' ~ step.step_phase_code , step.StepPhases.description ~ ' View' ) }}</li>
    <li>{{ link_to('tracker/experimentDetails/' ~ step.id , step.name ) }}</li>
    <li>{{ project.PIs.getName() }}</li>
    <li class="active">{{ project.name }}</li>
  </ol>
{% endif %}
{{ content() }}
