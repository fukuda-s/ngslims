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
    {{ partial('partials/trackerdetails-header') }}
    <div
        align="right">{{ link_to("trackerdetails/editSamples/SHOW/0/" ~ project.id ~ "?pre_action=" ~ previousAction, "Edit Sample Info >>", "class": "btn btn-primary") }}</div>
    <hr>
    <div class="row">
      <div class="col-sm-6">
        <div class="panel panel-success">
          <div class="panel-heading">
            <h4 class="panel-title">Progress</h4>
          </div>
          <div class="panel-body" id="project_panel_body">
            <div id="project_progress"></div>
          </div>
        </div>
      </div>
    </div>
    <table class="table table-bordered table-hover table-condensed" id="sampleInfo_table" style="font-size: 9pt">
      <thead>
      <tr>
        <th>Sample Name</th>
        <th>Sample Type</th>
        <th>Cell Type</th>
        <th>Tissue/Organ</th>
        <th>Multiplex Lib Name</th>
        <th>Lib Name</th>
        <th>Protocol Name</th>
        <th>Index A</th>
        <th>Index Seq A</th>
        <th>Index B</th>
        <th>Index Seq B</th>
        <th>Flowcell</th>
        <th>Lane #</th>
        <th>QC Date</th>
        <th>Lib Date</th>
        <th>Run Started Date</th>
        <th>Run Finished Date</th>
        <th>Total</th>
        <th>PF</th>
        <th>PF(%)</th>
      </tr>
      </thead>
      <tbody>
      {% for data in datas %}
        {% if data.sample_status == 'On Hold' or data.seqlib_status == 'On Hold' %}
          {% continue %}
        {% else %}
          <tr id="sample_id_{{ data.sample_id }}">
        {% endif %}
        <td>{{ data.sample_name }}</td>
        <td>{{ data.sample_type }}</td>
        <td>{{ data.cell_type }}</td>
        <td>{{ data.tissue }}</td>
        <td>{{ data.seqtemplate_name }}</td>
        <td>{{ data.seqlib_name }}</td>
        <td>{{ data.protocol_name }}</td>
        <td>{{ data.oligobarcodeA_name }}</td>
        <td>{{ data.oligobarcodeA_seq }}</td>
        <td>{{ data.oligobarcodeB_name }}</td>
        <td>{{ data.oligobarcodeB_seq }}</td>
        <td>{{ link_to('trackerdetails/showTableSeqlanes/' ~ data.flowcell_name, data.flowcell_name ) }}</td>
        <td>{{ data.seqlane_num }}</td>
        {% if data.qual_date is defined %}
          <td>{{ date('Y-m-d', strtotime(data.qual_date)) }}</td>
        {% else %}
          <td></td>
        {% endif %}
        {% if data.seqlib_date is defined %}
          <td>{{ date('Y-m-d', strtotime(data.seqlib_date)) }}</td>
        {% else %}
          <td></td>
        {% endif %}
        {% if data.run_started_date is defined %}
          <td>{{ date('Y-m-d', strtotime(data.run_started_date)) }}</td>
        {% else %}
          <td></td>
        {% endif %}
        {% if data.run_finished_date is defined %}
          <td>{{ date('Y-m-d', strtotime(data.run_finished_date)) }}</td>
        {% else %}
          <td></td>
        {% endif %}
        {% if data.sdr is defined %}
          {% set reads_total = (data.sdr.reads_total is empty) ? '' : number_format(data.sdr.reads_total) %}
          <td>{{ reads_total }}</td>
          {% set reads_passedfilter = (data.sdr.reads_passedfilter is empty) ? '' : number_format(data.sdr.reads_passedfilter) %}
          <td>{{ reads_passedfilter }}</td>
          {% set reads_passedfilter_percent = (data.sdr.reads_total > 0) ? round(data.sdr.reads_passedfilter / data.sdr.reads_total * 100, 2) ~ '%' : '' %}
          <td>{{ reads_passedfilter_percent }}</td>
        {% else %}
          <td></td>
          <td></td>
          <td></td>
        {% endif %}
        </tr>
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
    $.ajax({
          url: '{{ url("summary/projectNameProgress") }}',
          dataType: 'html',
          type: 'POST',
          data: {
            project_id: {{ project.id }}
          }
        })
        .done(function (data) {
          $('#project_progress').replaceWith(data);
        });

    $('#sampleInfo_table').DataTable({
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