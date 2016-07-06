<!--suppress ALL -->
<div class="row">
  <div class="col-md-12">
    <ol class="breadcrumb">
      <li>{{ link_to('setting', 'Setting') }}</li>
      <li class="active">Instruments</li>
    </ol>

    {{ content() }}
    {{ flashSession.output() }}

    <button type="button" class="btn btn-xs btn-primary pull-left"
            onclick="instrumentsEdit(-1, '', '', '', '', 'Y', 0)"
            style="margin: 10px 0; width: 261px ">
      <i class="fa fa-plus" aria-hidden="true"></i>&ensp;
      Create New Instrument
    </button>
    <button type="button" class="btn btn-xs pull-right" style="margin: 0 0 10px 0; width: 261px "
            onclick="showInactive(this)">
      <div><i class="fa fa-ban" aria-hidden="true"></i>&ensp;Show In-active Instrument</div>
      <div style="display: none"><i class="fa fa-ban" aria-hidden="true"></i>&ensp;Hide In-active Instrument</div>
    </button>
    <div class="clearfix"></div>

    <table class="table table-condensed table-hover table-striped" id="instrument-table" style="font-size: 70%">
      <thead>
      <tr>
        <th>ID</th>
        <th>Instrument Name</th>
        <th>Instrument Number</th>
        <th>Nickname</th>
        <th>Instrument Type Name</th>
        <th>Active</th>
        <th>Edit</th>
      </tr>
      </thead>
      <tbody>
      {% for instrument in instruments %}
        {% set active = instrument.active %}
        <tr
            {% if active is 'N' %}
              class="danger inactive" style="display: none"
            {% endif %}
        >
          <td>{{ instrument.id }}</td>
          <td>{{ instrument.name }}</td>
          <td>{{ instrument.instrument_number }}</td>
          <td>{{ instrument.nickname }}</td>
          <td>{{ instrument.InstrumentTypes.name }}</td>
          {% if active is 'Y' %}
            <td>{{ active }}</td>
          {% else %}
            <td class="text-danger">{{ active }}</td>
          {% endif %}
          {% set instrument_flowcell_count = instrument.Flowcells|length %}
          <td class="text-center">
            <a href="javascript:void(0)" style="font-size: 9pt"
               onclick="instrumentsEdit('{{ instrument.id }}', '{{ instrument.name }}', '{{ instrument.instrument_number }}', '{{ instrument.nickname }}', '{{ instrument.instrument_type_id }}', '{{ instrument.active }}', '{{ instrument_flowcell_count }}'); return false;">
              <span class="fa fa-pencil"></span>&ensp;
            </a>
            {% if instrument_flowcell_count == 0 %}
              <a href="javascript:void(0)" style="font-size: 9pt"
                 onclick="instrumentsRemove({{ instrument.id }}); return false;"><span class="fa fa-trash"></span></a>
            {% else %}
              {% set trash_message = "Could not delete this Instrument. This Instrument is already used by " ~ instrument_flowcell_count ~ " flowcells." %}
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
<div class="modal fade form-horizontal" id="modal-instrument-edit" tabindex="-1" role="dialog"
     aria-labelledby="modal-instrument-edit-title"
     aria-hidden="true">
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
        <h4 class="modal-title" id="modal-instrument-edit-title">Edit</h4>
      </div>
      <div class="modal-body">
        <h5>Please press 'Save' button when finished edit.</h5>
        <h5 class="text-danger">CATION! Could not rollback after 'Save'.</h5>
        <br>
        {{ hidden_field('modal-instrument_id', 'class': 'form-control') }}
        <div class="form-group form-group-sm">
          <label for="modal-name" class="col-sm-3 control-label" style="font-size: 9pt">Instrument Name</label>
          <div class="col-sm-9">
            {{ text_field('modal-name', 'class': 'form-control') }}
          </div>
        </div>
        <div class="form-group form-group-sm">
          <label for="modal-instrument_number" class="col-sm-3 control-label" style="font-size: 9pt">Instrument Number</label>
          <div class="col-sm-9">
            {{ text_field('modal-instrument_number', 'class': 'form-control') }}
          </div>
        </div>
        <div class="form-group form-group-sm">
          <label for="modal-nickname" class="col-sm-3 control-label" style="font-size: 9pt">Nickname</label>
          <div class="col-sm-9">
            {{ text_field('modal-nickname', 'class': 'form-control') }}
          </div>
        </div>
        <div class="form-group form-group-sm">
          <label for="modal-instrument_type_id" class="col-sm-3 control-label" style="font-size: 9pt">Instrument Type Name</label>
          <div class="col-sm-9">
            {{ select('modal-instrument_type_id', instrument_types, 'using': ['id', 'name'], 'class': 'form-control') }}
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
          <button type="button" id="modal-instrument-save" class="btn btn-primary pull-right disabled"
                  onclick="instrumentsSave()">
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
  function instrumentsEdit(instrument_id, name, instrument_number, nickname, instrument_type_id, active, instrument_flowcell_count) {

    $('#modal-instrument_id').val(instrument_id);
    $('#modal-name').val(name);
    $('#modal-instrument_number').val(instrument_number);
    $('#modal-nickname').val(nickname);
    $('#modal-instrument_type_id').val(instrument_type_id);
    $('#modal-active').val(active);


    // @TODO should be consider details condition of details
    if (instrument_flowcell_count > 0) {
      $('#modal-name').prop('disabled', true);
      $('#modal-active').prop('disabled', true);
    } else {
      $('#modal-name').prop('disabled', false);
      $('#modal-active').prop('disabled', false);
    }

    $('#modal-instrument-save').addClass('disabled');

    $('#modal-instrument-edit').modal('show');

  }

  /**
   * Save edit results on modal window.
   * @returns {boolean}
   */
  function instrumentsSave() {
    if (!$('#modal-name').val().length) {
      alert('Please input Instrument name.');
      return false;
    }

    $('#modal-instrument-edit').modal('hide');

    var instrument_id = $('#modal-instrument_id').val();
    var name = $('#modal-name').val();
    var instrument_number = $('#modal-instrument_number').val();
    var nickname = $('#modal-nickname').val();
    var instrument_type_id = $('#modal-instrument_type_id').val();
    var active = $('#modal-active').val();
    $.ajax({
      type: 'POST',
      url: '/ngsLIMS/setting/instruments',
      data: {
        instrument_id: instrument_id,
        name: name,
        instrument_number: instrument_number,
        nickname: nickname,
        instrument_type_id: instrument_type_id,
        active: active
      }
    })
        .done(function (data) {
          console.log(data);
          window.location.reload();  // @TODO It should not be re-loaded.
        });
  }

  /**
   * Delete instrument record. (It will be soft-deleted (active=N).)
   * @param instrument_id
   * @returns {boolean}
   */
  function instrumentsRemove(instrument_id) {
    if (!instrument_id) {
      alert('Error: Could not found instrument_id value.');
      return false;
    }

    if (window.confirm("This Instrument will be in-active.\n\nAre You Sure?")) {
      $.ajax({
        type: 'POST',
        url: '/ngsLIMS/setting/instruments',
        data: {
          instrument_id: instrument_id,
          active: 'N'
        }
      })
          .done(function (data) {
            console.log(data);
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
          $('#modal-instrument-save').removeClass('disabled');
        });

  });
</script>