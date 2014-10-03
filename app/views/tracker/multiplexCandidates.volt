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
<div class="row">
  <div class="col-md-10">
  </div>
  <div class="col-md-2">
    <button id="mixup-seqlibs-button" type="button" class="btn btn-primary">Mixup Seqlibs &raquo;</button>
  </div>
</div>
<hr>
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
              .find('button#show-inactive-tube').click(function (e) {
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
          /*
           * put function to "Select all" button.
           */
          $(target_id)
              .find('button#select-all').click(function (e) {

                if ($(e.target).hasClass('active') == false) {
                  $(target_id)
                      .find('.tube.ui-selectee')
                      .filter(function () {
                        var css_display = $(this).css('display');
                        return css_display != 'none';
                      })
                      .addClass('ui-selected')
                  $(e.target)
                      .addClass('active')
                      .text('Un-select all');
                } else {
                  $(target_id)
                      .find('.tube.ui-selectee')
                      .filter(function () {
                        var css_display = $(this).css('display');
                        return css_display != 'none';
                      })
                      .removeClass('ui-selected')
                  $(e.target)
                      .removeClass('active')
                      .text('Select all');
                }

              });

          /*
           * Put function to 'Search' form on tube list header.
           */
          $('#tube-filter').on('keyup', function (event) {
            var queryStr = new RegExp(event.target.value);
            console.log(queryStr);
            $(event.target)
                .parents('.tube-group')
                .children('.tube-list')
                .find('.tube.ui-selectee')
                .filter(function (index) {
                  var css_display = $(this).css('display');
                  var tube_textStr = $(this).text().toString();
                  //console.log(index + ":" + css_display != 'none' && ! queryStr.test(tube_textStr));
                  return css_display != 'none' && !queryStr.test(tube_textStr);
                })
                .addClass('tube-hidden');

            $(event.target)
                .parents('.tube-group')
                .children('.tube-list')
                .find('.tube-hidden')
                .filter(function (index) {
                  var tube_textStr = $(this).text().toString();
                  return queryStr.test(tube_textStr);
                })
                .removeClass('tube-hidden');
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
              window.location = "{{ url("tracker/multiplexSetup/") ~ step.id }}"
            });
      }
    });

    /*
     * If URL has #pi_user_id_ then open collapsed panel-body
     */
    if (location.search) {
      var pi_user_id = $.getUrlVar('pi_user_id');
      //console.log(pi_user_id);
      $('#list_user_id_' + pi_user_id)
          .addClass('in')
          .parents('.panel')
          .addClass('in');
    }

    /*
     * @TODO Bug: if click panel own, then following event fired.
     */
    $('.panel[id^=inactives-]')
        .last()
        .on('hidden.bs.collapse', function (e) {
          e.stopPropagation();
          var buttonObj = $('button#show-inactive-panel')
          var buttonStr = buttonObj.text().replace('Hide', 'Show');
          buttonObj.text(buttonStr);
        })
        .on('shown.bs.collapse', function (e) {
          e.stopPropagation();
          var buttonObj = $('button#show-inactive-panel')
          var buttonStr = buttonObj.text().replace('Show', 'Hide');
          buttonObj.text(buttonStr);
        });
  });
</script>
