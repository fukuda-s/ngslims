{{ content() }}
{{ flashSession.output() }}
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

<div class="row">
  <div class="col-md-12">
    <div class="panel panel-success" id="flowcell-panel">
      <div class="panel-heading">
        <h3 class="panel-title">Flowcell : {{ flowcell_name }}</h3>
      </div>
      <table class="table table-bordered table-hover table-condensed table-responsive">
        <thead>
        <tr>
          <th>Lane #</th>
          <th>Seqtemplate Name</th>
          <th>Apply Conc.(pM)</th>
          <th>Is Control</th>
        </tr>
        </thead>
        <tbody>
        {% for lane_number in lane_index %}
          <tr>
            {% if seqlanes[lane_number] is defined %}
              {% set seqlane = seqlanes[lane_number] %}
              <td>{{ lane_number }}</td>
              <td class="success">{{ seqlane['seqtemplate_name'] }}</td>
              {% if seqlanes_add[lane_number] is defined %}
                {% set seqlane_add = seqlanes_add[lane_number] %}
                <td class="success">{{ seqlane_add['apply_conc'] }}</td>
                <td class="success">{{ seqlane_add['is_control'] }}</td>
              {% else %}
                <td class="success"></td>
                <td class="success"></td>
              {% endif %}
            {% else %}
              <td>{{ lane_number }}</td>
              <td class="warning">NULL</td>
              <td class="warning"></td>
              <td class="warning"></td>
            {% endif %}
          </tr>
        {% endfor %}
        </tbody>
      </table>
    <div class="panel-footer clearfix">
      <button id="flowcell-save-button" type="button" class="btn btn-success pull-right">Save Flowcell
        Setup &raquo;</button>
    </div>
    </div>
  </div>
</div>
<script>
  $(document).ready(function () {
    /*
     * Build function for #flowcell-setup-button
     */
    $("#flowcell-save-button").click(function () {
      $.ajax({
        url: '{{ url("tracker/flowcellSetupSave/") ~ step.id }}',
        dataType: 'json',
        type: 'POST',
        data: {}
      })
          .done(function () {
            //$('#flowcell-save-button').prop('disabled', true);
            //console.log('done');
            window.location = "{{ url("tracker/flowcellSetupCandidates/") ~ step.id }}"
          })
          .fail(function () {
            //console.log('fail');
            window.location = "{{ url("tracker/flowcellSetupConfirm/") ~ step.id }}"
          });
    });
  });
</script>
