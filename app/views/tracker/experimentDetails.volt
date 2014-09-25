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
                      data-target="[id^=inactives]" style="min-width: 87px">
                Show inactive
              </button>
            </div>
          </div>
        </div>
      </div>
    {% endif %}

    <div {% if user.project_count > 0 %} class="panel panel-info" id="pi_user_id_{{ user.id }}"
    {% else %} class="panel panel-default collapse" id="inactives-{{ user.id }}" {% endif %}>
      <div class="panel-heading" data-toggle="collapse" data-target="#list_user_id_{{ user.id }}" id="OwnerList">
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
        <div id="list_user_id_{{ user.id }}" class="panel-body panel-collapse collapse">
          {{ elements.getTrackerExperimentDetailProjectList( user.id, step.nucleotide_type, step.step_phase_code, step.id ) }}
        </div>
      </ul>
    </div>
    {% elsefor %} No projects are recorded
  {% endfor %}
</div>
<script>
  function showTubeSeqlibs(step_id, project_id) {
    var target_id = '#seqlib-tube-list-project-id-' + project_id;
    $.ajax({
      url: '{{ url("trackerdetails/showTubeSeqlibs") }}',
      dataType: 'html',
      type: 'POST',
      data: {
        step_id: step_id, project_id: project_id
      }
    })
        .done(function (data) {
          $(target_id).html(data);
          console.log(target_id);

          /*
           * Add selectable function to seqlib tubes.
           */
          $(target_id).find("#sample-holder").selectable();

          /*
           * put function to "Show inactive" button.
           */
          $(target_id)
              .find('button#show-inactive').click(function (e) {
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
          $(target_id)
              .find('button#select-all').click(function (e) {
                $(target_id).find('.tube.ui-selectee').addClass('ui-selected')
                if ($(e.target).hasClass('active') == false) {
                  $(target_id)
                      .find('.tube.ui-selectee')
                      .addClass('ui-selected')
                  $(e.target)
                      .addClass('active')
                      .text('Un-select all');
                } else {
                  $(target_id)
                      .find('.tube.ui-selectee')
                      .removeClass('ui-selected')
                  $(e.target)
                      .removeClass('active')
                      .text('Select all');
                }
              });

        });
  }

  $(document).ready(function () {
    $("#mixup-seqlibs-button").click(function () {
      var selectedSeqlibs = [];
      console.log("Clicked mixup-seqlibs-button");
      $(document).find(".ui-selected[id^=seqlib-id-]").each(function () {
        var seqlib_id = $(this).attr("id").replace("seqlib-id-", "");
        selectedSeqlibs.push(seqlib_id);
      });
      if (selectedSeqlibs.length) {
        $.ajax({
          url: '{{ url("tracker/multiplexSetSession") }}',
          dataType: 'json',
          type: 'POST',
          data: {selectedSeqlibs: selectedSeqlibs}
        })
            .done(function () {
              console.log(selectedSeqlibs);
              window.location = "{{ url("tracker/multiplex/") ~ step.id }}"
            });
      }
    });

    /*
     * If URL has #pi_user_id_ then open collapsed panel-body
     */
    if (location.hash) {
      var list_user_id = location.hash.replace('pi_', 'list_');
      $(list_user_id).addClass('in');
      //console.log(list_user_id);
    }
  });
</script>
