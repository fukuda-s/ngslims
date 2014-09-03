{% if type == 'SHOW' %}
  <ol class="breadcrumb">
    <li>{{ link_to("tracker", "Tracker") }}</li>
    <li>{{ link_to("summary/" ~ previousAction, "Project Overview") }}</li>
    {% if project.PIs is empty %}
      <li>(Undefined PI)</li>
    {% else %}
      <li>{{ project.PIs.getFullname() }}</li>
    {% endif %}
    <li class="active">{{ project.name }}</li>
  </ol>
  <div
      align="left">{{ link_to("trackerdetails/showTableSamples/" ~ project.id ~ "?pre=" ~ previousAction, "<< Back to Sample Info", "class": "btn btn-primary") }}</div>
{% else %}
  <ol class="breadcrumb">
    <li>{{ link_to("tracker", "Tracker") }}</li>
    <li>{{ link_to('tracker/experiments/' ~ step.step_phase_code , step.StepPhases.description ~ ' View' ) }}</li>
    <li>{{ link_to('tracker/experimentDetails/' ~ step.id , step.name ) }}</li>
    <li>{{ project.PIs.getFullname() }}</li>
    <li class="active">{{ project.name }}</li>
  </ol>
{% endif %}
{{ content() }}
