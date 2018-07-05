{{ content() }}

{% if flowcell is defined %}
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
        {% if type is 'OVERALL' %}
          <li>{{ link_to(referer, "Overall") }}</li>
        {% else %}
          <li>{{ link_to(referer, "Instrument Overview") }}</li>
        {% endif %}
        <li class="active">{{ flowcell_name }}</li>
      </ol>
      {% set run_started_date = (flowcell.fc.run_started_date is empty) ? '' : date('Y-m-d', strtotime(flowcell.fc.run_started_date)) %}
      {% set run_finished_date = (flowcell.fc.run_finished_date is empty) ? '' : date('Y-m-d', strtotime(flowcell.fc.run_finished_date)) %}
      <div class="row">
        <div class="col-md-5">
          <div class="panel panel-default">
            <div class="panel-heading">
              <div class="panel-title">{{ flowcell.fc.name }}
                <a href="{{ url('trackerdetails/showTableSeqlanes/' ~ flowcell_name ~ '?sample_sheet_type=' ~ flowcell.it.platform_code) }}">
                  <i class="fa fa-file-text-o"></i>
                </a>
              </div>
            </div>
            <table class="table table-bordered table-hover table-condensed" style="font-size: 80%">
              <tbody>
              <tr>
                <th>Run Number</th>
                <td>{{ flowcell.fc.run_number }}</td>
              </tr>
              <tr>
                <th>Side</th>
                <td>{{ flowcell.fc.side }}</td>
              </tr>
              <tr>
                <th>Run Mode Type</th>
                <td>{{ flowcell.srmt.name }}</td>
              </tr>
              <tr>
                <th>Run Read Type</th>
                <td>{{ flowcell.srrt.name }}</td>
              </tr>
              <tr>
                <th>Run Cycle Type</th>
                <td>{{ flowcell.srct.name }}</td>
              </tr>
              <tr>
                <th>Run Started Date</th>
                <td>{{ flowcell.fc.run_started_date }}</td>
              </tr>
              <tr>
                <th>Run Finished Date</th>
                <td>{{ flowcell.fc.run_finished_date }}</td>
              </tr>
              <tr>
                <th>Data Directory</th>
                <td>{{ flowcell.fc.dirname }}</td>
              </tr>
              <tr>
                <th>Notes</th>
                <td>{{ flowcell.fc.notes }}</td>
              </tr>
              <tbody>
            </table>
          </div>
        </div>
        <div class="col-md-7">
          <div class="panel panel-default">
            <div class="panel-heading">Lane Info</div>
            <table class="table table-bordered table-hover table-condensed" style="font-size: 80%">
              <thead>
              <tr>
                <th>Lane Number</th>
                <th>Seq. Template Name</th>
                <th>Apply Conc. (pM)</th>
              </tr>
              </thead>
              <tbody>
              {% for seqtemplate in seqtemplates %}
                <tr>
                  <td>{{ seqtemplate.slane.number }}</td>
                  <td>{{ seqtemplate.st.name }}</td>
                  <td>{{ seqtemplate.slane.apply_conc }}</td>
                </tr>
                {% elsefor %}
                <h5>Error: Could not find any seqtemplates</h5>
              {% endfor %}
              </tr>
              </tbody>
            </table>
          </div>
        </div>
      </div>
      <table class="table table-bordered table-hover table-condensed" id="seqlaneInfo_table" style="font-size: 9pt">
        <thead>
        <tr>
          <th>Project Name</th>
          <th>Run ID</th>
          <th>Run Date</th>
          <th>Machine</th>
          <th>FCID</th>
          <th>Lane #</th>
          <th>Instrument Type</th>
          <th>Run Mode Type</th>
          <th>Run Read Type</th>
          <th>Run Cycle Type</th>
          <th>Seqlib Name</th>
          <th>Organism</th>
          <th>Index Seq</th>
          <th>Description</th>
          <th>Control</th>
          <th>Exp. Type</th>
          <th>PI Name</th>
          <th>Protocol</th>
          <th>Multiplex Lib. Name</th>
          <th>Index1</th>
          <th>Index2</th>
          <th>Lane #</th>
          <th>Seqlib Name</th>
          <th>Total</th>
          <th>PF</th>
          <th>PF(%)</th>
        </tr>
        </thead>
        <tbody>
        {% for d in seqlanes %}
          <tr id="seqlib_id_{{ d.slib.id }}">
            {% if d.slib.Projects %}
              <td>{{ link_to('trackerdetails/showTableSamples/' ~ d.p.id, d.slib.Projects.name) }}</td>
            {% else %}
              <td></td>
            {% endif %}
            <td>{{ d.fc.run_number }}</td>
            <td>{{ date('Y-m-d', strtotime(d.fc.run_started_date)) }}</td>
            <td>{{ d.fc.Instruments.instrument_number ~ d.fc.side }}</td>
            <td>{{ d.fc.name }}</td>
            <td>{{ d.slane.number }}</td>
            <td>{{ d.it.name }}</td>
            <td>{{ d.srmt.name }}</td>
            <td>{{ d.srrt.name }}</td>
            <td>{{ d.srct.name }}</td>
            <td>{{ d.slib.name }}</td>
            {% if d.s.Organisms %}
              <td>{{ d.s.Organisms.name }}</td>
            {% else %}
              <td></td>
            {% endif %}
            {% if d.slib.oligobarcodeA_id is empty %}
              <td></td>
              <td></td>
            {% elseif d.slib.oligobarcodeB_id is empty %}
              <td>{{ d.oa.barcode_seq }}</td>
              <td>{{ d.st.name ~ d.oa.name }}</td>
            {% else %}
              <td>{{ d.oa.barcode_seq ~ '-' ~ d.ob.barcode_seq }}</td>
              <td>{{ d.st.name ~ d.oa.name ~ d.ob.name }}</td>
            {% endif %}
            <td>{{ d.slane.is_control }}</td>
            {% if d.slib.protocol_id is empty %}
              <td></td>
            {% else %}
              <td>{{ d.slib.Protocols.Steps.short_name }}</td>
            {% endif %}
            {% if d.p.pi_user_id is 0 %}
              <td>(Undefined)</td>
            {% else %}
              <td>{{ d.p.PIs.getFullName() }}</td>
            {% endif %}
            {% if d.slib.protocol_id is empty %}
              <td></td>
            {% else %}
              <td>{{ d.slib.Protocols.name }}</td>
            {% endif %}
            <td>{{ d.st.name }}</td>
            {% if d.slib.oligobarcodeA_id is empty %}
              <td></td>
            {% else %}
              <td>{{ d.oa.name }}</td>
            {% endif %}
            {% if d.slib.oligobarcodeB_id is empty %}
              <td></td>
            {% else %}
              <td>{{ d.ob.name }}</td>
            {% endif %}
            <td>{{ d.slane.number }}</td>
            {% if d.slane.control_id is empty %}
              <td>{{ d.slib.name }}</td>
            {% else %}
              <td>{{ d.ct.name }}</td>
            {% endif %}
            {% if d.sdr is defined %}
              {% set reads_total = (d.sdr.reads_total is empty) ? '' : number_format(d.sdr.reads_total) %}
              <td>{{ reads_total }}</td>
              {% set reads_passedfilter = (d.sdr.reads_passedfilter is empty) ? '' : number_format(d.sdr.reads_passedfilter) %}
              <td>{{ reads_passedfilter }}</td>
              {% set reads_passedfilter_percent = (d.sdr.reads_total > 0) ? round(d.sdr.reads_passedfilter / d.sdr.reads_total * 100, 2) ~ '%' : '' %}
              <td>{{ reads_passedfilter_percent }}</td>
            {% else %}
              <td></td>
              <td></td>
              <td></td>
            {% endif %}
          </tr>
          {% elsefor %}
          <h5>Could not find any seqlanes</h5>
        {% endfor %}
        {% set seqDemultiplexResults = d.fc.getSeqDemultiplexResults("is_undetermined = 'Y'") %}
        {% for seqDemultiplexResult in seqDemultiplexResults %}
          <tr>
            <td></td>
            <td>{{ d.fc.run_number }}</td>
            <td>{{ date('Y-m-d', strtotime(d.fc.run_started_date)) }}</td>
            <td>{{ d.fc.Instruments.instrument_number ~ d.fc.side }}</td>
            <td>{{ d.fc.name }}</td>
            <td>{{ seqDemultiplexResult.SeqLanes.number }}</td>
            <td></td>
            <td></td>
            <td></td>
            <td></td>
            <td></td>
            <td></td>
            <td></td>
            <td></td>
            <td></td>
            <td></td>
            <td></td>
            <td></td>
            <td></td>
            <td></td>
            <td></td>
            <td>{{ seqDemultiplexResult.SeqLanes.number }}</td>
            <td>Undet</td>
            <td>{{ number_format(seqDemultiplexResult.reads_total) }}</td>
            <td>{{ number_format(seqDemultiplexResult.reads_passedfilter) }}</td>
            {% set reads_passedfilter_percent = (seqDemultiplexResult.reads_total > 0) ? round(seqDemultiplexResult.reads_passedfilter / seqDemultiplexResult.reads_total * 100, 2) ~ '%' : '' %}
            <td>{{ reads_passedfilter_percent }}</td>
          </tr>
        {% endfor %}
        </tbody>
      </table>
    </div>
  </div>
{% endif %}
<script>
    /*
     * DataTables
     */
    $(document).ready(function () {
        $('#seqlaneInfo_table').DataTable({
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