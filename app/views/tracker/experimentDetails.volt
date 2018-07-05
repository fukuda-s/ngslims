<!--
  ~ (The MIT License)
  ~
  ~ Copyright (c) 2014-2018 Genome Science Division, RCAST, Univ.Tokyo. <fukuda-s@genome.rcast.u-tokyo.ac.jp>
  ~
  ~ Permission is hereby granted, free of charge, to any person obtaining
  ~ a copy of this software and associated documentation files (the
  ~ 'Software'), to deal in the Software without restriction, including
  ~ without limitation the rights to use, copy, modify, merge, publish,
  ~ distribute, sublicense, and/or sell copies of the Software, and to
  ~ permit persons to whom the Software is furnished to do so, subject to
  ~ the following conditions:
  ~
  ~ The above copyright notice and this permission notice shall be
  ~ included in all copies or substantial portions of the Software.
  ~
  ~ THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
  ~ EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
  ~ MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
  ~ IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
  ~ CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
  ~ TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
  ~ SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
  -->

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
