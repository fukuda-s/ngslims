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
  <div class="col-md-7">
  </div>
  <div class="col-md-3">
    {{ numeric_field("seqlibs_per_seqtemplate", "placeholder": "# of seqlibs per seqtemplates", "class": "form-control") }}
  </div>
  <div class="col-md-2">
    <button id="mixup-seqlibs-button" type="button" class="btn btn-primary">Mixup Seqlibs &raquo;</button>
  </div>
</div>
<hr>
{% if view_type == 'PI' %}
  {% include 'tracker/multiplexCandidatesPI.volt' %}
{% elseif view_type == 'PJ' %}
  {% include 'tracker/multiplexCandidatesPJ.volt' %}
{% elseif view_type == 'CP' %}
  {% include 'tracker/multiplexCandidatesCP.volt' %}
{% else %}
  {% include 'tracker/multiplexCandidatesPI.volt' %}
{% endif %}


<script>
  function showTubeSeqlibs(step_id, project_id, cherry_picking_id) {
    var target_id = '#seqlib-tube-list-target-id-' + project_id + '-' + cherry_picking_id;
    $.ajax({
      url: '{{ url("trackerdetails/showTubeSeqlibs") }}',
      dataType: 'html',
      type: 'POST',
      data: {
        step_id: step_id, project_id: project_id, cherry_picking_id: cherry_picking_id
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
                  .addClass('ui-selected');
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
                  .removeClass('ui-selected');
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

    $(target_id).collapse('show');
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
        var seqlibs_per_seqtemplate = $('#seqlibs_per_seqtemplate').val();
        $.ajax({
          url: '{{ url("tracker/multiplexSetSession") }}',
          dataType: 'json',
          type: 'POST',
          data: {
            selectedSeqlibs: selectedSeqlibs,
            seqlibs_per_seqtemplate: seqlibs_per_seqtemplate
          }
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

    /**
     * Show '.inactives-<project/cherry_picking_id>' panels and toggle Show/Hide strings on button.
     */
    $('button#show-inactive-panel').click(function () {
      $(this).children('div').toggle();
      $('.panel[id^=inactives-]').toggle('fast');
    });
  });
</script>
