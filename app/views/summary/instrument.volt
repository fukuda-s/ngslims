{{ content() }}

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
    <ol class="breadcrumb">
      <li>{{ link_to("tracker", "Tracker") }}</li>
      <li class="active">Instrument Overview</li>
    </ol>

    <ul class="nav nav-tabs">
      {% for instrument in instruments %}
        {% set instrument_name = instrument.name ~ ' (' ~ instrument.instrument_number ~ ' : ' ~ instrument.nickname ~ ')' %}
        {% if instrument.id is instrument_id %}
          <li role="presentation" class="active">{{ link_to('summary/instrument/' ~ instrument.id, instrument_name) }}</li>
        {% else %}
          <li role="presentation">{{ link_to('summary/instrument/' ~ instrument.id, instrument_name) }}</li>
        {% endif %}
        {% elsefor %}
        <h5>Error: Could not find any instruments</h5>
      {% endfor %}
    </ul>
    <table class="table table-bordered table-hover table-condensed" id="instrument_table" style="font-size: 80%">
      <thead>
      <tr>
        <th>Flowcell</th>
        <th>Run Started Date</th>
        <th>Run Finished Date</th>
        <th>Run Number</th>
        <th>Side</th>
        <th>Run Mode Type</th>
        <th>Run Read Type</th>
        <th>Run Cycle Type</th>
        <th>Data Directory</th>
        <th>Notes</th>
      </tr>
      </thead>
      <tbody>
      {% for flowcell in flowcells %}
        {% set run_started_date = (flowcell.fc.run_started_date is empty) ? '' : date('Y-m-d', strtotime(flowcell.fc.run_started_date)) %}
        {% set run_finished_date = (flowcell.fc.run_finished_date is empty) ? '' : date('Y-m-d', strtotime(flowcell.fc.run_finished_date)) %}
      <tr>
        <td>{{ link_to('trackerdetails/showTableSeqlanes/' ~ flowcell.fc.name ~ '?referer=summary/instrument/' ~ instrument.id, flowcell.fc.name ) }}</td>
        <td>{{ run_started_date }}</td>
        <td>{{ run_finished_date }}</td>
        <td>{{ flowcell.fc.run_number }}</td>
        <td>{{ flowcell.fc.side }}</td>
        <td>{{ flowcell.srmt.name }}</td>
        <td>{{ flowcell.srrt.name }}</td>
        <td>{{ flowcell.srct.name }}</td>
        <td>{{ flowcell.fc.dirname }}</td>
        <td>{{ flowcell.fc.notes }}</td>
      </tr>
        {% elsefor %}
        <h5>Error: Could not find any flowcells</h5>
      {% endfor %}
      </tbody>

    </table>
  </div>
</div>
<script>
  /*
   * DataTables
   */
  $(document).ready(function () {
    $('#instrument_table').DataTable({
      scrollX: true,
      responsive: true,
      paging: true,
      order: [],
      dom: 'Bfrtip',
      buttons: [
        'pageLength',
        {
          extend: "excelHtml5",
          text: "<i class='fa fa-file-excel-o'></i>&ensp;<strong>Excel</strong>"
        },
        {
          extend: 'copyHtml5',
          text: "<i class='fa fa-clipboard'></i>&ensp;<strong>Copy To Clipboard</strong>"
        }
      ]
    });
  });
</script>