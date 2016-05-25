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
<hr>
{% if view_type == 'PI' %}
  {% include 'tracker/experimentDetailsPI.volt' %}
{% elseif view_type == 'PJ' %}
  {% include 'tracker/experimentDetailsPJ.volt' %}
{% elseif view_type == 'CP' %}
  {% include 'tracker/experimentDetailsCP.volt' %}
{% else %}
  {% include 'tracker/experimentDetailsPI.volt' %}
{% endif %}

<script>
  $(document).ready(function () {
    /*
     * If URL has #pi_user_id_ then open collapsed panel-body
     */
    if (location.search) {
      var pi_user_id = $.getUrlVar('pi_user_id');
      var status = decodeURIComponent($.getUrlVar('status'));
      if(status === 'NULL'){
        status = '';
      }
      //console.log(pi_user_id + ":" + status);
      $('#list_user_id_' + pi_user_id + '[status=\'' + status + '\']')
          .addClass('in')
          .parents('.panel')
          .addClass('in');
    }

    $('[id^=inactives]')
        .first()
        .on('hidden.bs.collapse', function () {
          var buttonObj = $('button#show-inactive');
          var buttonStr = buttonObj.text().replace('Hide', 'Show');
          buttonObj.text(buttonStr);
        })
        .on('shown.bs.collapse', function () {
          var buttonObj = $('button#show-inactive');
          var buttonStr = buttonObj.text().replace('Show', 'Hide');
          buttonObj.text(buttonStr);
        });
  });
</script>
