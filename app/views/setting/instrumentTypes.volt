<!--suppress ALL -->
<div class="row">
  <div class="col-md-12">
    <ol class="breadcrumb">
      <li>{{ link_to('setting', 'Setting') }}</li>
      <li class="active">Instrument Types</li>
    </ol>

    {{ content() }}
    {{ flashSession.output() }}

    <button type="button" class="btn btn-xs btn-primary pull-left"
            onclick="instrumentTypesEdit(-1, '', '', '', '', '', 'Y', 0)"
            style="margin: 10px 0; width: 261px ">
      <i class="fa fa-plus" aria-hidden="true"></i>&ensp;
      Create New Instrument Type
    </button>
    <button type="button" class="btn btn-xs pull-right" style="margin: 0 0 10px 0; width: 261px "
            onclick="showInactive(this)">
      <div><i class="fa fa-ban" aria-hidden="true"></i>&ensp;Show In-active Instrument Type</div>
      <div style="display: none"><i class="fa fa-ban" aria-hidden="true"></i>&ensp;Hide In-active Instrument Type</div>
    </button>
    <div class="clearfix"></div>

    <table class="table table-condensed table-hover table-striped" id="instrument-table" style="font-size: 70%">
      <thead>
      <tr>
        <th>ID</th>
        <th>Instrument Type Name</th>
        <th>Platform Description</th>
        <th>Sort Order</th>
        <th>Num. of Slots per Run</th>
        <th>Slots Names (JSON array)</th>
        <th>Active</th>
        <th>Edit</th>
        <th>Link to Run Type Setting</th>
      </tr>
      </thead>
      <tbody>
      {% for instrument_type in instrument_types %}
        {% set active = instrument_type.active %}
        <tr
            {% if active is 'N' %}
              class="danger inactive" style="display: none"
            {% endif %}
        >
          <td>{{ instrument_type.id }}</td>
          <td>{{ instrument_type.name }}</td>
          <td>{{ instrument_type.Platforms.description }}</td>
          <td>{{ instrument_type.sort_order }}</td>
          <td>{{ instrument_type.slots_per_run }}</td>
          <td>{{ instrument_type.slots_array_json }}</td>
          {% if active is 'Y' %}
            <td>{{ active }}</td>
          {% else %}
            <td class="text-danger">{{ active }}</td>
          {% endif %}
          {% set instrument_type_instrument_count = instrument_type.Instruments|length %}
          <td class="text-center">
            <a href="javascript:void(0)" style="font-size: 9pt"
               onclick="instrumentTypesEdit('{{ instrument_type.id }}', '{{ instrument_type.name }}', '{{ instrument_type.platform_code }}', '{{ instrument_type.sort_order }}', '{{ instrument_type.slots_per_run }}', '{{ instrument_type.slots_array_json|e }}', '{{ instrument_type.active }}', '{{ instrument_type_instrument_count }}'); return false;">
              <span class="fa fa-pencil"></span>&ensp;
            </a>
            {{ link_to('setting/stepInstrumentTypeSchemes/' ~ instrument_type.id, "<i class='fa fa-user-plus'></i>&ensp;") }}
            {% if instrument_type_instrument_count == 0 %}
              <a href="javascript:void(0)" style="font-size: 9pt"
                 onclick="instrumentTypesRemove({{ instrument_type.id }}); return false;"><span class="fa fa-trash"></span></a>
            {% else %}
              {% set trash_message = "Could not delete this Instrument Type. This Instrument Type is already used by " ~ instrument_type_instrument_count ~ " instruments." %}
              <a href="javascript:void(0)" data-toggle="tooltip" data-placement="bottom" title="{{ trash_message }}"
                 style="font-size: 9pt; color: #b9c4c8; cursor: not-allowed;" onclick="return false;">
                <span class="fa fa-trash"></span></a>
            {% endif %}
          </td>
          <td class="text-center">
            {{ link_to('setting/seqRunTypeSchemes/' ~ instrument_type.id, "Seq. Run Type Scheme Setting") }}
          </td>
        </tr>
      {% endfor %}
      </tbody>
    </table>
  </div>
</div>

<!-- Modal Confirm Copy-->
<div class="modal fade form-horizontal" id="modal-instrument_type-edit" tabindex="-1" role="dialog"
     aria-labelledby="modal-instrument_type-edit-title"
     aria-hidden="true">
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
        <h4 class="modal-title" id="modal-instrument_type-edit-title">Edit</h4>
      </div>
      <div class="modal-body">
        <h5>Please press 'Save' button when finished edit.</h5>
        <h5 class="text-danger">CATION! Could not rollback after 'Save'.</h5>
        <br>
        {{ hidden_field('modal-instrument_type_id', 'class': 'form-control') }}
        <div class="form-group form-group-sm">
          <label for="modal-name" class="col-sm-3 control-label" style="font-size: 9pt">Instrument Type Name</label>
          <div class="col-sm-9">
            {{ text_field('modal-name', 'class': 'form-control') }}
          </div>
        </div>
        <div class="form-group form-group-sm">
          <label for="modal-platform_code" class="col-sm-3 control-label" style="font-size: 9pt">Platform Description</label>
          <div class="col-sm-9">
            {{ select('modal-platform_code', platforms, 'using': ['platform_code', 'description'], 'class': 'form-control') }}
          </div>
        </div>
        <div class="form-group form-group-sm">
          <label for="modal-sort_order" class="col-sm-3 control-label" style="font-size: 9pt">Sort Order</label>
          <div class="col-sm-9">
            {{ numeric_field('modal-sort_order', 'class': 'form-control') }}
          </div>
        </div>
        <div class="form-group form-group-sm">
          <label for="modal-slots_per_run" class="col-sm-3 control-label" style="font-size: 9pt">Num. of Slots per Run</label>
          <div class="col-sm-9">
            {{ numeric_field('modal-slots_per_run', 'class': 'form-control') }}
          </div>
        </div>
        <div class="form-group form-group-sm">
          <label for="modal-slots_array_json" class="col-sm-3 control-label" style="font-size: 9pt">Slots Names (JSON array)</label>
          <div class="col-sm-9">
            {{ text_field('modal-slots_array_json', 'class': 'form-control') }}
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
          <button type="button" id="modal-instrument_type-save" class="btn btn-primary pull-right disabled"
                  onclick="instrumentTypesSave()">
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
  function instrumentTypesEdit(instrument_type_id, name, platform_code, sort_order, slots_per_run, slots_array_json, active, instrument_type_instrument_count) {

    $('#modal-instrument_type_id').val(instrument_type_id);
    $('#modal-name').val(name);
    $('#modal-platform_code').val(platform_code);
    $('#modal-sort_order').val(sort_order);
    $('#modal-slots_per_run').val(slots_per_run);
    $('#modal-slots_array_json').val(slots_array_json);
    $('#modal-active').val(active);


    // @TODO should be consider details condition of details
    if (instrument_type_instrument_count > 0) {
      $('#modal-platform_code').prop('disabled', true);
      $('#modal-slots_per_run').prop('disabled', true);
      $('#modal-slots_array_json').prop('disabled', true);
      $('#modal-active').prop('disabled', true);
    } else {
      $('#modal-platform_code').prop('disabled', false);
      $('#modal-slots_per_run').prop('disabled', false);
      $('#modal-slots_array_json').prop('disabled', false);
      $('#modal-active').prop('disabled', false);
    }

    $('#modal-instrument_type-save')
        .prop('disabled', true)
        .addClass('disabled');

    $('#modal-instrument_type-edit').modal('show');

  }

  /**
   * Save edit results on modal window.
   * @returns {boolean}
   */
  function instrumentTypesSave() {
    if (!$('#modal-name').val().length) {
      alert('Please input Instrument Type name.');
      return false;
    }

    $('#modal-instrument_type-edit').modal('hide');

    var instrument_type_id = $('#modal-instrument_type_id').val();
    var name = $('#modal-name').val();
    var platform_code = $('#modal-platform_code').val();
    var sort_order = $('#modal-sort_order').val();
    var slots_per_run = $('#modal-slots_per_run').val();
    var slots_array_json = $('#modal-slots_array_json').val();
    var active = $('#modal-active').val();
    $.ajax({
      type: 'POST',
      url: '/ngsLIMS/setting/instrumentTypes',
      data: {
        instrument_type_id: instrument_type_id,
        name: name,
        platform_code: platform_code,
        sort_order: sort_order,
        slots_per_run: slots_per_run,
        slots_array_json: slots_array_json,
        active: active
      }
    })
        .done(function (data) {
          //console.log(data);
          window.location.reload();  // @TODO It should not be re-loaded.
        });
  }

  /**
   * Delete instrument record. (It will be soft-deleted (active=N).)
   * @param instrument_type_id
   * @returns {boolean}
   */
  function instrumentTypesRemove(instrument_type_id) {
    if (!instrument_type_id) {
      alert('Error: Could not found instrument_type_id value.');
      return false;
    }

    if (window.confirm("This Instrument Type will be in-active.\n\nAre You Sure?")) {
      $.ajax({
        type: 'POST',
        url: '/ngsLIMS/setting/instrumentTypes',
        data: {
          instrument_type_id: instrument_type_id,
          active: 'N'
        }
      })
          .done(function (data) {
            //console.log(data);
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
    $('#instrument-table').DataTable({
      paging: false,
      order: []
    });

    $('#modal-instrument-edit')
        .find('input, select')
        .change(function () {
          $('#modal-instrument-save')
              .prop('disabled', false)
              .removeClass('disabled');
        });

  });
</script>