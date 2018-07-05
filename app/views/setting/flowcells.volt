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

<!--suppress ALL -->
<div class="row">
  <div class="col-md-12">
    <ol class="breadcrumb">
      <li>{{ link_to('setting', 'Setting') }}</li>
      <li class="active">Flowcells</li>
    </ol>

    {{ content() }}
    {{ flashSession.output() }}

    <!--
    <button type="button" class="btn btn-xs btn-primary pull-left"
            onclick="flowcellEdit(-1, '', '', '', '', '', '', '', '', '', '', 0)"
            style="margin: 10px 0; width: 261px ">
      <i class="fa fa-plus" aria-hidden="true"></i>&ensp;
      Create New Flowcell
    </button>
    <button type="button" class="btn btn-xs pull-right" style="margin: 0 0 10px 0; width: 261px "
            onclick="showInactive(this)">
      <div><i class="fa fa-ban" aria-hidden="true"></i>&ensp;Show In-active Flowcells</div>
      <div style="display: none"><i class="fa fa-ban" aria-hidden="true"></i>&ensp;Hide In-active Flowcells
      </div>
    </button>
    -->
    <div class="clearfix"></div>

    <table class="table table-condensed table-hover table-striped" id="flowcell-table" style="font-size: 70%">
      <thead>
      <tr>
        <th>ID</th>
        <th>Flowcell Name</th>
        <th>Sequence Run Mode Type</th>
        <th>Sequence Run Read Type</th>
        <th>Sequence Run Cycle Type</th>
        <th>Run Number</th>
        <th>Instrument Name</th>
        <th>Side</th>
        <th>Directory</th>
        <th>Run Started Date</th>
        <th>Run Finished Date</th>
        <th>Created At</th>
        <th>Notes</th>
        <th>Edit</th>
      </tr>
      </thead>
      <tbody>
      {% for flowcell in flowcells %}
        <tr>
          <td>{{ flowcell.id }}</td>
          <td>{{ flowcell.name }}</td>
          <td>{{ flowcell.SeqRunmodeTypes.name }}</td>
          {% if flowcell.SeqRunTypeSchemes is empty %}
            <td></td>
            <td></td>
          {% else %}
            <td>{{ flowcell.SeqRunTypeSchemes.SeqRunreadTypes.name }}</td>
            <td>{{ flowcell.SeqRunTypeSchemes.SeqRuncycleTypes.name }}</td>
          {% endif %}
          <td>{{ flowcell.run_number }}</td>
          {% if flowcell.Instruments is empty %}
            <td></td>
          {% else %}
            <td>{{ flowcell.Instruments.name }}</td>
          {% endif %}
          <td>{{ flowcell.side }}</td>
          <td>{{ flowcell.dirname }}</td>
          {% if flowcell.run_started_date is empty %}
            {% set run_started_date = '' %}
          {% else %}
            {% set run_started_date = date('Y-m-d', strtotime(flowcell.run_started_date)) %}
          {% endif %}
          <td>{{ run_started_date }}</td>
          {% if flowcell.run_finished_date is empty %}
            {% set run_finished_date = '' %}
          {% else %}
            {% set run_finished_date = date('Y-m-d', strtotime(flowcell.run_finished_date)) %}
          {% endif %}
          <td>{{ run_finished_date }}</td>
          <td>{{ flowcell.created_at }}</td>
          <td>{{ flowcell.notes }}</td>
          {% set flowcell_seqlane_count = flowcell.Seqlanes|length %}
          <td class="text-center">
            <a href="javascript:void(0)" style="font-size: 9pt"
               onclick="flowcellEdit('{{ flowcell.id }}', '{{ flowcell.name }}', '{{ flowcell.seq_run_type_scheme_id }}', '{{ flowcell.run_number }}', '{{ flowcell.instrument_id }}', '{{ flowcell.side }}', '{{ flowcell.dirname }}', '{{ run_started_date }}', '{{ run_finished_date }}', '{{ flowcell.notes }}', '{{ flowcell_seqlane_count }}'); return false;">
              <span class="fa fa-pencil"></span>&ensp;
            </a>
            {{ link_to('setting/flowcellSeqlanes/' ~ flowcell.id, "<i class='fa fa-user-plus'></i>&ensp;") }}
            {% if flowcell_seqlane_count == 0 %}
              <a href="javascript:void(0)" style="font-size: 9pt"
                 onclick="flowcellRemove({{ flowcell.id }}); return false;"><span class="fa fa-trash"></span></a>
            {% else %}
              {% set trash_message = "Could not delete this Flowcell. This Flowcell already has " ~ flowcell_seqlane_count ~ " seqlanes." %}
              <a href="javascript:void(0)" data-toggle="tooltip" data-placement="bottom" title="{{ trash_message }}"
                 style="font-size: 9pt; color: #b9c4c8; cursor: not-allowed;" onclick="return false;">
                <span class="fa fa-trash"></span></a>
            {% endif %}
          </td>
        </tr>
      {% endfor %}
      </tbody>
    </table>
  </div>
</div>

<!-- Modal Confirm Copy-->
<div class="modal fade form-horizontal" id="modal-flowcell-edit" tabindex="-1" role="dialog"
     aria-labelledby="modal-flowcell-edit-title"
     aria-hidden="true">
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
        <h4 class="modal-title" id="modal-flowcell-edit-title">Edit</h4>
      </div>
      <div class="modal-body">
        <h5>Please press 'Save' button when finished edit.</h5>
        <h5 class="text-danger">CATION! Could not rollback after 'Save'.</h5>
        <br>
        {{ hidden_field('modal-flowcell_id') }}
        <div class="form-group form-group-sm">
          <label for="modal-name" class="col-sm-3 control-label" style="font-size: 9pt">Flowcell Name</label>
          <div class="col-sm-9">
            {{ text_field('modal-name', 'class': 'form-control') }}
          </div>
        </div>
        <div class="form-group form-group-sm">
          <label for="modal-instrument_id" class="col-sm-3 control-label" style="font-size: 9pt">Instrument Name</label>
          <div class="col-sm-9">
            {{ select('modal-instrument_id', instruments, 'using': ['id', 'instrument_name'], 'class': 'form-control') }}
          </div>
        </div>
        <div class="form-group form-group-sm">
          <label for="modal-seq_run_type_scheme_id" class="col-sm-3 control-label" style="font-size: 9pt">Sequence Run
            Mode Type</label>
          <div class="col-sm-9">
            {{ select_static('modal-seq_run_type_scheme_id', [], 'useEmpty': true, 'emptyText': 'Please Select Instrument...', 'emptyValue': '@', 'value': '@', 'disabled': 'disabled', 'class': 'form-control') }}
          </div>
        </div>
        <div class="form-group form-group-sm">
          <label for="modal-run_number" class="col-sm-3 control-label" style="font-size: 9pt">Run Number</label>
          <div class="col-sm-9">
            {{ numeric_field('modal-run_number', 'class': 'form-control') }}
          </div>
        </div>
        <div class="form-group form-group-sm">
          <label for="modal-side" class="col-sm-3 control-label" style="font-size: 9pt">Side</label>
          <div class="col-sm-9">
            {{ select_static('modal-side', [], 'useEmpty': true, 'emptyText': 'Please Select Instrument...', 'emptyValue': '@', 'value': '@', 'disabled': 'disabled', 'class': 'form-control') }}
          </div>
        </div>
        <div class="form-group form-group-sm">
          <label for="modal-dirname" class="col-sm-3 control-label" style="font-size: 9pt">Directory</label>
          <div class="col-sm-9">
            {{ text_field('modal-dirname', 'class': 'form-control') }}
          </div>
        </div>
        <div class="form-group form-group-sm">
          <label for="modal-run_started_date" class="col-sm-3 control-label" style="font-size: 9pt">Run Started
            Date</label>
          <div class="col-sm-9">
            {{ date_field('modal-run_started_date', 'class': 'form-control') }}
          </div>
        </div>
        <div class="form-group form-group-sm">
          <label for="modal-run_finished_date" class="col-sm-3 control-label" style="font-size: 9pt">Run Finished
            Date</label>
          <div class="col-sm-9">
            {{ date_field('modal-run_finished_date', 'class': 'form-control') }}
          </div>
        </div>
        <div class="form-group form-group-sm">
          <label for="modal-notes" class="col-sm-3 control-label" style="font-size: 9pt">Notes</label>
          <div class="col-sm-9">
            {{ text_field('modal-notes', 'class': 'form-control') }}
          </div>
        </div>
        <div class="modal-footer">
          <button type="button" class="btn btn-default" data-dismiss="modal">Cancel</button>
          <button type="button" id="modal-flowcell-save" class="btn btn-primary pull-right disabled"
                  onclick="flowcellSave()">
            Save
          </button>
        </div>
      </div>
    </div>
  </div>
</div>

<script>

  /**
   * Generate seq_run_type_scheme_id select on modal.
   */
  function createSeqRunTypeSchemesSelect(seq_run_type_scheme_id, instrument_id) {
    var modal_seq_run_type_scheme_id = $('#modal-seq_run_type_scheme_id');
    $.ajax({
      type: 'POST',
      url: '/ngsLIMS/setting/createSeqRunTypeSchemesSelect',
      data: {
        seq_run_type_scheme_id: seq_run_type_scheme_id,
        instrument_id: instrument_id
      }
    })
        .done(function (data) {
          //console.log(data);
          modal_seq_run_type_scheme_id
              .replaceWith(data)
        });
  }

  /**
   * Generate seq_run_type_scheme_id select on modal.
   */
  function createFlowcellSideSelect(side, instrument_id) {
    var modal_side = $('#modal-side');
    $.ajax({
      type: 'POST',
      url: '/ngsLIMS/setting/createFlowcellSideSelect',
      data: {
        side: side,
        instrument_id: instrument_id
      }
    })
        .done(function (data) {
          //console.log(data);
          modal_side
              .replaceWith(data)
        });
  }

  /**
   * Open modal window with filling values.
   */
  function flowcellEdit(flowcell_id, name, seq_run_type_scheme_id, run_number, instrument_id, side, dirname, run_started_date, run_finished_date, notes, flowcell_seqlane_count) {

    createSeqRunTypeSchemesSelect(seq_run_type_scheme_id, instrument_id)
    createFlowcellSideSelect(side, instrument_id);

    $('#modal-flowcell_id').val(flowcell_id);
    $('#modal-name').val(name);
    $('#modal-seq_run_type_scheme_id').val(seq_run_type_scheme_id);
    $('#modal-run_number').val(run_number);
    $('#modal-instrument_id').val(instrument_id);
    $('#modal-side').val(side);
    $('#modal-dirname').val(dirname);
    $('#modal-run_started_date').val(run_started_date);
    $('#modal-run_finished_date').val(run_finished_date);
    $('#modal-notes').val(notes);

    if (flowcell_seqlane_count > 0) {
      $('#modal-name').prop('disabled', true);
    } else {
      $('#modal-name').prop('disabled', false);
    }


    $('#modal-flowcell-save')
        .prop('disabled', true)
        .addClass('disabled');

    $('#modal-flowcell-edit').modal('show');

  }

  /**
   * Save edit results on modal window.
   * @returns {boolean}
   */
  function flowcellSave() {
    if (!$('#modal-name').val().length) {
      alert('Please input Flowcell name.');
      return false;
    }

    $('#modal-lab-edit').modal('hide');

    var flowcell_id = $('#modal-flowcell_id').val();
    var name = $('#modal-name').val();
    var seq_run_type_scheme_id = $('#modal-seq_run_type_scheme_id').val();
    var run_number = $('#modal-run_number').val();
    var instrument_id = $('#modal-instrument_id').val();
    var side = $('#modal-side').val();
    var dirname = $('#modal-dirname').val();
    var run_started_date = $('#modal-run_started_date').val();
    var run_finished_date = $('#modal-run_finished_date').val();
    var notes = $('#modal-notes').val();
    $.ajax({
      type: 'POST',
      url: '/ngsLIMS/setting/flowcells',
      data: {
        flowcell_id: flowcell_id,
        name: name,
        seq_run_type_scheme_id: seq_run_type_scheme_id,
        run_number: run_number,
        instrument_id: instrument_id,
        side: side,
        dirname: dirname,
        run_started_date: run_started_date,
        run_finished_date: run_finished_date,
        notes: notes
      }
    })
        .done(function (data) {
          console.log(data);
          window.location.reload();  // @TODO It should not be re-loaded.
        });
  }

  /**
   * Delete flowcell record. (It will be soft-deleted (active=N).)
   * @param flowcell_id
   * @returns {boolean}
   */
  function flowcellRemove(flowcell_id) {
    if (!flowcell_id) {
      alert('Error: Could not found flowcell_id value.');
      return false;
    }

    if (window.confirm("This Flowcell will be in-active.\n\nAre You Sure?")) {
      $.ajax({
        type: 'POST',
        url: '/ngsLIMS/setting/flowcells',
        data: {
          flowcell_id: flowcell_id,
          active: 'N'
        }
      })
          .done(function () {
            window.location.reload(); // @TODO It should not be re-loaded.
          });
    }


  }

  /**
   * Show active=N rows function on button.
   */
  function showInactive(target) {
    $('.inactive').toggle();
    $(target).children('div').toggle();
  }

  /**
   * DataTables
   */
  $(document).ready(function () {
    $('#flowcell-table').DataTable({
      order: []
    });

    $('#modal-flowcell-edit')
        .find('input, select')
        .change(function () {
          $('#modal-flowcell-save')
              .prop('disabled', false)
              .removeClass('disabled');
        });

    $('#modal-instrument_id').change(function () {
      var seq_run_type_scheme_id = 0;
      var instrument_id = $('#modal-instrument_id').val();
      createSeqRunTypeSchemesSelect(seq_run_type_scheme_id, instrument_id);
      var side = 0;
      createFlowcellSideSelect(side, instrument_id);
    });

  });
</script>