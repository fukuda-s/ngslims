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
{% if step.step_phase_code == "MULTIPLEX" or step.step_phase_code == "DUALMULTIPLEX" %}
  <div class="row">
    <div class="col-md-10">
    </div>
    <div class="col-md-2">
      <button id="mixup-seqlibs-button" type="button" class="btn btn-primary">Mixup Seqlibs &raquo;</button>
    </div>
  </div>
  <hr>
{% endif %}
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
            <button type="button" class="btn btn-default btn-xs" id="show-inactive" data-toggle="collapse"
                    data-target=".panel-default#inactives" style="min-width: 87px">Show
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
          <span
              class="badge">{% if user.project_count > 0 %}{{ user.project_count }}{% else %}{{ user.project_count_all }}{% endif %}</span>
        </div>
        <div class="col-md-1">
          <span
              class="badge">{% if user.project_count > 0 %}{{ user.sample_count }}{% else %}{{ user.sample_count_all }}{% endif %}</span>
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
{% elsefor %} No projects are recorded
{% endfor %}
<script>
  function showTubeSeqLibs(step_id, project_id) {
    target_id = '#seqlib-tube-list-project-id-' + project_id;
    $.ajax({
      url: '{{ url("trackerProjectSamples/showTubeSeqLibs") }}',
      dataType: 'html',
      type: 'POST',
      data: {
        step_id: step_id, project_id: project_id
      }
    })
        .done(function (data) {
          $(target_id).html(data);
          console.log(target_id);

          $(target_id).find("#sample-holder").selectable();

          // put function to "Show inactive" button.
          $(target_id)
              .find('#show-inactive').click(function (e) {
                // @TODO 'Show/Hide Inactive' button should be hidden if .tube-inactive(s) are not exist.
                if ($(e.target).hasClass('active') == false) {
                  $(target_id)
                      .find('.tube-inactive')
                      .show('slow');
                  $(e.target)
                      .addClass('active')
                      .text('Hide Inactive');
                } else {
                  $(target_id)
                      .find('.tube-inactive')
                      .hide('slow');
                  $(e.target)
                      .removeClass('active')
                      .text('Show Inactive');
                }
              });
        });
  }

  $(document).ready(function () {
    $("#mixup-seqlibs-button").click(function () {
      var selectedSeqlibs = [];
      console.log("Clicked mixup-seqlibs-button");
      $(document).find(".ui-selected").each(function () {
        var seqlib_id = $(this).attr("id").replace("seqlib-id-", "");
        selectedSeqlibs.push(seqlib_id);
      });
      if (selectedSeqlibs.length) {
        $.ajax({
          url: '{{ url("tracker/multiplexSetSession") }}',
          dataType: 'json',
          type: 'POST',
          data: { selectedSeqlibs: selectedSeqlibs}
        })
            .done(function () {
              console.log(selectedSeqlibs);
              window.location = "{{ url("tracker/multiplex/") ~ step.id }}"
            });
      }
    })
    ;
  })
  ;
</script>
