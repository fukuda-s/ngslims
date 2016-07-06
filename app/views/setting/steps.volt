<!--suppress ALL -->
<div class="row">
  <div class="col-md-12">
    <ol class="breadcrumb">
      <li>{{ link_to('setting', 'Setting') }}</li>
      <li class="active">Steps</li>
    </ol>

    {{ content() }}
    {{ flashSession.output() }}

    <button type="button" class="btn btn-xs btn-primary pull-left"
            onclick="stepEdit(-1, '', '', '', '', '', '', '', 'Y', 0, 0)"
            style="margin: 10px 0; width: 261px ">
      <i class="fa fa-plus" aria-hidden="true"></i>&ensp;
      Create New Step
    </button>
    <button type="button" class="btn btn-xs pull-right" style="margin: 0 0 10px 0; width: 261px "
            onclick="showInactive(this)">
      <div><i class="fa fa-ban" aria-hidden="true"></i>&ensp;Show In-active Steps</div>
      <div style="display: none"><i class="fa fa-ban" aria-hidden="true"></i>&ensp;Hide In-active Steps</div>
    </button>
    <div class="clearfix"></div>

    <table class="table table-condensed table-hover table-striped" id="step-table" style="font-size: 70%">
      <thead>
      <tr>
        <th>ID</th>
        <th>Step Name</th>
        <th>Step Short Name</th>
        <th>Step Phase Code</th>
        <th>Sequence RunMode Type</th>
        <th>Platform</th>
        <th>Nucleotide Type</th>
        <th>Sort Order</th>
        <th>Active</th>
        <th>Edit</th>
      </tr>
      </thead>
      <tbody>
      {% for step in steps %}
        {% set active = step.active %}
        <tr
            {% if active is 'N' %}
              class="danger inactive" style="display: none"
            {% endif %}
        >
          <td>{{ step.id }}</td>
          <td>{{ step.name }}</td>
          <td>{{ step.short_name }}</td>
          <td>{{ step.step_phase_code ~ ' (' ~ step.StepPhases.description ~ ')' }}</td>
          {% if step.seq_runmode_type_id is not null %}
            <td>{{ step.SeqRunmodeTypes.name }}</td>
          {% else %}
            <td>---</td>
          {% endif %}
          <td>{{ step.platform_code ~ ' (' ~ step.Platforms.description ~ ')' }}</td>
          {% if step.nucleotide_type is not null %}
            <td>{{ step.nucleotide_type }}</td>
          {% else %}
            <td>---</td>
          {% endif %}
          <td>{{ step.sort_order }}</td>
          {% if active is 'Y' %}
            <td>{{ active }}</td>
          {% else %}
            <td class="text-danger">{{ active }}</td>
          {% endif %}
          {% set step_stepentry_count = step.StepEntries|length %}
          {% set step_protocol_count = step.Protocols|length %}
          <td class="text-center">
            <a href="javascript:void(0)" style="font-size: 9pt"
               onclick="stepEdit('{{ step.id }}', '{{ step.name }}', '{{ step.short_name }}', '{{ step.step_phase_code }}', '{{ step.seq_runmode_type_id }}', '{{ step.platform_code }}', '{{ step.nucleotide_type }}', '{{ step.sort_order }}', '{{ step.active }}', '{{ step_stepentry_count }}', '{{ step_protocol_count }}'); return false;">
              <span class="fa fa-pencil"></span>&ensp;
            </a>
            {% if step_stepentry_count == 0 and step_protocol_count == 0 %}
              <a href="javascript:void(0)" style="font-size: 9pt"
                 onclick="stepRemove({{ step.id }}); return false;"><span class="fa fa-trash"></span></a>
            {% else %}
              {% set trash_message = "Could not delete this Step. This Step is already used by " ~ step_stepentry_count ~ " sample/seqlibs or used by " ~ step_protocol_count ~ " protocols." %}
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
<div class="modal fade form-horizontal" id="modal-step-edit" tabindex="-1" role="dialog"
     aria-labelledby="modal-step-edit-title"
     aria-hidden="true">
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
        <h4 class="modal-title" id="modal-step-edit-title">Edit</h4>
      </div>
      <div class="modal-body">
        <h5>Please press 'Save' button when finished edit.</h5>
        <h5 class="text-danger">CATION! Could not rollback after 'Save'.</h5>
        <br>
        {{ hidden_field('modal-step_id') }}
        <div class="form-group form-group-sm">
          <label for="modal-name" class="col-sm-3 control-label" style="font-size: 9pt">Step Name</label>
          <div class="col-sm-9">
            {{ text_field('modal-name', 'class': 'form-control') }}
          </div>
        </div>
        <div class="form-group form-group-sm">
          <label for="modal-short_name" class="col-sm-3 control-label" style="font-size: 9pt">Step Short Name</label>
          <div class="col-sm-9">
            {{ text_field('modal-short_name', 'class': 'form-control') }}
          </div>
        </div>
        <div class="form-group form-group-sm">
          <label for="modal-step_phase_code" class="col-sm-3 control-label" style="font-size: 9pt">Step Phase
            Code</label>
          <div class="col-sm-9">
            {{ select('modal-step_phase_code', step_phases, 'using': ['step_phase_code', 'description'], 'class': 'form-control') }}
          </div>
        </div>
        <div class="form-group form-group-sm">
          <label for="modal-seq_runmode_type_id" class="col-sm-3 control-label" style="font-size: 9pt">Sequence Run
            Mode</label>
          <div class="col-sm-9">
            {{ select('modal-seq_runmode_type_id', seq_runmode_types, 'using': ['id', 'name'], 'class': 'form-control') }}
          </div>
        </div>
        <div class="form-group form-group-sm">
          <label for="modal-platform_code" class="col-sm-3 control-label" style="font-size: 9pt">Platform Code</label>
          <div class="col-sm-9">
            {{ select('modal-platform_code', platforms, 'using': ['platform_code', 'description'], 'class': 'form-control') }}
          </div>
        </div>
        <div class="form-group form-group-sm">
          <label for="modal-nucleotide_type" class="col-sm-3 control-label" style="font-size: 9pt">Nucleotide
            Type</label>
          <div class="col-sm-9">
            {{ select_static('modal-nucleotide_type', ['DNA':'DNA', 'RNA':'RNA'], 'class': 'form-control') }}
          </div>
        </div>
        <div class="form-group form-group-sm">
          <label for="modal-active" class="col-sm-3 control-label" style="font-size: 9pt">Sort Order</label>
          <div class="col-sm-2">
            {{ numeric_field('modal-sort_order', 'class': 'form-control') }}
          </div>
        </div>
        <div class="form-group form-group-sm">
          <label for="modal-active" class="col-sm-3 control-label" style="font-size: 9pt">Active/In-active</label>
          <div class="col-sm-2">
            {{ select_static('modal-active', ['Y':'Y', 'N':'N'], 'class': 'form-control') }}
          </div>
        </div>
        <div class="modal-footer">
          <button type="button" class="btn btn-default" data-dismiss="modal">Cancel</button>
          <button type="button" id="modal-step-save" class="btn btn-primary pull-right disabled"
                  onclick="stepSave()">
            Save
          </button>
        </div>
      </div>
    </div>
  </div>
</div>

<script>
  /**
   * Open modal window with filling values.
   */
  function stepEdit(step_id, name, short_name, step_phase_code, seq_runmode_type_id, platform_code, nucleotide_type, sort_order, active, step_stepentry_count, step_protocol_count) {

    $('#modal-step_id').val(step_id);
    $('#modal-name').val(name);
    $('#modal-short_name').val(short_name);
    $('#modal-step_phase_code').val(step_phase_code);
    $('#modal-seq_runmode_type_id').val(seq_runmode_type_id);
    $('#modal-platform_code').val(platform_code);
    $('#modal-nucleotide_type').val(nucleotide_type);
    $('#modal-sort_order').val(sort_order);
    $('#modal-active').val(active);

    if (step_phase_code != "FLOWCELL") {
      $('#modal-seq_runmode_type_id').prop('disabled', true);
    } else {
      $('#modal-seq_runmode_type_id').prop('disabled', false);
    }

    if (step_phase_code != "QC" && step_phase_code != "PREP") {
      $('#modal-nucleotide_type').prop('disabled', true);
    } else {
      $('#modal-nucleotide_type').prop('disabled', false);
    }

    $('#modal-step_phase_code').change(function () {
      var step_phase_code_changed = $(this).val();
      //console.log(step_phase_code_changed);
      if (step_phase_code_changed != "FLOWCELL") {
        $('#modal-seq_runmode_type_id').prop('disabled', true);
      } else {
        $('#modal-seq_runmode_type_id').prop('disabled', false);
      }
      if (step_phase_code_changed != "QC" && step_phase_code_changed != "PREP") {
        $('#modal-nucleotide_type').prop('disabled', true);
      } else {
        $('#modal-nucleotide_type').prop('disabled', false);
      }
    });

    // @TODO should be consider details condition of details
    if (step_stepentry_count > 0 || step_protocol_count > 0) {
      $('#modal-step_phase_code').prop('disabled', true);
      $('#modal-seq_runmode_type_id').prop('disabled', true);
      $('#modal-platform_code').prop('disabled', true);
      $('#modal-nucleotide_type').prop('disabled', true);
      $('#modal-active').prop('disabled', true);
    } else {
      $('#modal-step_phase_code').prop('disabled', false);
      $('#modal-seq_runmode_type_id').prop('disabled', false);
      $('#modal-platform_code').prop('disabled', false);
      $('#modal-nucleotide_type').prop('disabled', false);
      $('#modal-active').prop('disabled', false);
    }

    $('#modal-step-save')
        .prop('disabled', true)
        .addClass('disabled');

    $('#modal-step-edit').modal('show');

  }

  /**
   * Save edit results on modal window.
   * @returns {boolean}
   */
  function stepSave() {
    if (!$('#modal-name').val().length) {
      alert('Please input Step name.');
      return false;
    }
    if (!$('#modal-platform_code').val().length) {
      alert('Please input Platform Code.');
      return false;
    }

    $('#modal-step-edit').modal('hide');

    var step_id = $('#modal-step_id').val();
    var name = $('#modal-name').val();
    var short_name = $('#modal-short_name').val();
    var step_phase_code = $('#modal-step_phase_code').val();
    var seq_runmode_type_id = $('#modal-seq_runmode_type_id').val();
    var platform_code = $('#modal-platform_code').val();
    var nucleotide_type = $('#modal-nucleotide_type').val();
    var sort_order = $('#modal-sort_order').val();
    var active = $('#modal-active').val();
    $.ajax({
      type: 'POST',
      url: '/ngsLIMS/setting/steps',
      data: {
        step_id: step_id,
        name: name,
        short_name: short_name,
        step_phase_code: step_phase_code,
        seq_runmode_type_id: seq_runmode_type_id,
        platform_code: platform_code,
        nucleotide_type: nucleotide_type,
        sort_order: sort_order,
        active: active
      }
    })
        .done(function (data) {
          //console.log(data);
          window.location.reload();  // @TODO It should not be re-loaded.
        });
  }

  /**
   * Delete step record. (It will be soft-deleted (active=N).)
   * @param step_id
   * @returns {boolean}
   */
  function stepRemove(step_id) {
    if (!step_id) {
      alert('Error: Could not found step_id value.');
      return false;
    }

    if (window.confirm("This Step will be in-active.\n\nAre You Sure?")) {
      $.ajax({
        type: 'POST',
        url: '/ngsLIMS/setting/steps',
        data: {
          step_id: step_id,
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
    $('#step-table').DataTable({
      paging: false,
      order: []
    });

    $('#modal-step-edit')
        .find('input, select')
        .change(function () {
          $('#modal-step-save')
              .prop('disabled', false)
              .removeClass('disabled');
        });

  });
</script>