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
  <li>
    {{ link_to('tracker/flowcellSetupCandidates/' ~ step.id, step.name) }}
  </li>
  <li class="active">
    Confirm
  </li>
</ol>
{{ content() }}
{{ flashSession.output() }}
<div class="row">
  <div class="col-md-12">
    <div class="panel panel-info" id="flowcell-panel">
      <div class="panel-heading">
        <h3 class="panel-title">Flowcell : {{ flowcell_name }}</h3>
      </div>
      <table class="table table-bordered table-hover table-condensed table-responsive">
        <thead class="row">
        <tr>
          <th class="col-sm-1">Lane #</th>
          <th class="col-sm-8">Seqtemplate Name</th>
          <th class="col-sm-2">Apply Conc.(pM)</th>
          <th class="col-sm-1">Control Lane</th>
        </tr>
        </thead>
        <tbody id="flowcell-tbody">
        {% for lane_number in lane_index %}
          {% if seqlanes[lane_number] is defined %}
            {% set seqlane = seqlanes[lane_number] %}
            <tr class="success">
              <td>{{ seqlane["seqlane_number"] }}</td>
              <td>{{ seqlane["seqtemplate_name"] }}</td>
              <td class="form-inline">
                {{ text_field('apply_conc-' ~ seqlane["seqlane_number"], 'class': 'form-control input-sm') }}
                {% if not loop.last %}
                  <button type="button" id="copy-fill-apply_conc-{{ seqlane["seqlane_number"] }}"
                          class="btn btn-default btn-xs"><i
                        class="glyphicon glyphicon-arrow-down"></i></button>
                {% endif %}
              </td>
              {% if seqlane['is_control'] is 'Y' %}
                <td>{{ check_field('is_control-' ~ seqlane["seqlane_number"], 'class': 'checkbox', 'checked': 'checked', 'disabled': 'disabled') }}</td>
              {% else %}
                <td>{{ check_field('is_control-' ~ seqlane["seqlane_number"], 'class': 'checkbox') }}</td>
              {% endif %}
            </tr>
          {% else %}
            <tr class="warning">
              <td>{{ lane_number }}</td>
              <td>NULL</td>
              <td>NULL</td>
              <td>NULL</td>
            </tr>
          {% endif %}
        {% endfor %}
        </tbody>
      </table>
      <div class="panel-footer clearfix">
        <button id="flowcell-confirm-button" type="button" class="btn btn-success pull-right">Confirm Flowcell
          Setup &raquo;</button>
      </div>
    </div>
  </div>
</div>
<script>
  $(document).ready(function () {
    $("#flowcell-confirm-button").click(function () {
      var seqlanes_add = {};
      $('#flowcell-tbody').children('tr.success').each(function () {
        var lane_number = $(this).index() + 1;
        var apply_conc = $(this).find('input[id^=apply_conc-]').val();
        var is_control = 'N';
        if ($(this).find('input[id^=is_control-]').prop('checked')) {
          is_control = 'Y';
        }
        seqlanes_add[lane_number] = {lane_number: lane_number, apply_conc: apply_conc, is_control: is_control};
      });

      $.ajax({
        url: '{{ url("tracker/flowcellSetupSetSession/") }}',
        dataType: 'text',
        type: 'POST',
        data: {
          seqlanes_add: seqlanes_add
        }
      })
          .done(function () {
            window.location = "{{ url("tracker/flowcellSetupConfirm/") ~ step.id }}"
          });
      console.log(seqlanes_add);
    });

    $('button[id^=copy-fill-apply_conc-]').click(function () {
      var apply_conc = $(this).prev('input[id^=apply_conc-]').val();
      if (apply_conc) {
        $(this)
            .parents('tr.success')
            .nextAll('tr.success')
            .each(function () {
              $(this).find('input[id^=apply_conc-]').val(apply_conc);
              //console.log($(this).find('input[id^=apply_conc-]'));
            });
      }
    });
  });
</script>
