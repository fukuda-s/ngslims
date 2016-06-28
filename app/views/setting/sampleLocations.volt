<!--suppress ALL -->
<div class="row">
  <div class="col-md-12">
    <ol class="breadcrumb">
      <li>{{ link_to('setting', 'Setting') }}</li>
      <li class="active">Sample Locations</li>
    </ol>

    {{ content() }}
    {{ flashSession.output() }}

    <button type="button" class="btn btn-xs btn-primary pull-left"
            onclick="sampleLocationEdit(-1, '', 'Y', 0)"
            style="margin: 10px 0; width: 261px ">
      <i class="fa fa-plus" aria-hidden="true"></i>&ensp;
      Create New Sample Location
    </button>
    <button type="button" class="btn btn-xs pull-right" style="margin: 0 0 10px 0; width: 261px "
            onclick="showInactive(this)">
      <div><i class="fa fa-ban" aria-hidden="true"></i>&ensp;Show In-active Sample Location</div>
      <div style="display: none"><i class="fa fa-ban" aria-hidden="true"></i>&ensp;Hide In-active Sample Location</div>
    </button>
    <div class="clearfix"></div>

    <table class="table table-condensed table-hover table-striped" id="sample_location-table" style="font-size: 70%">
      <thead>
      <tr>
        <th>ID</th>
        <th>Sample Location Name</th>
        <th>Active</th>
        <th>Edit</th>
      </tr>
      </thead>
      <tbody>
      {% for sample_location in sample_locations %}
        {% set active = sample_location.active %}
        <tr
            {% if active is 'N' %}
              class="danger inactive" style="display: none"
            {% endif %}
        >
          <td>{{ sample_location.id }}</td>
          <td>{{ sample_location.name }}</td>
          {% if active is 'Y' %}
            <td>{{ active }}</td>
          {% else %}
            <td class="text-danger">{{ active }}</td>
          {% endif %}
          {% set sample_location_sample_count = sample_location.Samples|length %}
          <td class="text-center">
            <a href="javascript:void(0)" style="font-size: 9pt"
               onclick="sampleLocationEdit('{{ sample_location.id }}', '{{ sample_location.name }}', '{{ sample_location.active }}', '{{ sample_location_sample_count }}'); return false;">
              <span class="fa fa-pencil"></span>&ensp;
            </a>
            {% if sample_location_sample_count == 0 %}
              <a href="javascript:void(0)" style="font-size: 9pt"
                 onclick="sampleLocationRemove({{ sample_location.id }}); return false;"><span class="fa fa-trash"></span></a>
            {% else %}
              {% set trash_message = "Could not delete this Sample Location. This Sample Location is already used by " ~ sample_location_sample_count ~ " samples." %}
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
<div class="modal fade form-horizontal" id="modal-sample_location-edit" tabindex="-1" role="dialog"
     aria-labelledby="modal-sample_location-edit-title"
     aria-hidden="true">
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
        <h4 class="modal-title" id="modal-sample_location-edit-title">Edit</h4>
      </div>
      <div class="modal-body">
        <h5>Please press 'Save' button when finished edit.</h5>
        <h5 class="text-danger">CATION! Could not rollback after 'Save'.</h5>
        <br>
        {{ hidden_field('modal-sample_location_id') }}
        <div class="form-group form-group-sm">
          <label for="modal-name" class="col-sm-3 control-label" style="font-size: 9pt">Sample Location Name</label>
          <div class="col-sm-9">
            {{ text_field('modal-name', 'class': 'form-control') }}
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
          <button type="button" id="modal-sample_location-save" class="btn btn-primary pull-right disabled"
                  onclick="sampleLocationSave()">
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
  function sampleLocationEdit(sample_location_id, name, active, sample_location_sample_count) {

    $('#modal-sample_location_id').val(sample_location_id);
    $('#modal-name').val(name);
    $('#modal-active').val(active);

    // @TODO should be consider details condition of details
    if (sample_location_sample_count > 0 ) {
      $('#modal-active').attr('disabled', 'disabled');
    } else {
      $('#modal-active').removeAttr('disabled');
    }

    $('#modal-sample_location-save').addClass('disabled');

    $('#modal-sample_location-edit').modal('show');

  }

  /**
   * Save edit results on modal window.
   * @returns {boolean}
   */
  function sampleLocationSave() {
    if (!$('#modal-name').val().length) {
      alert('Please input Sample Location name.');
      return false;
    }

    $('#modal-sample_location-edit').modal('hide');

    var sample_location_id = $('#modal-sample_location_id').val();
    var name = $('#modal-name').val();
    var active = $('#modal-active').val();
    $.ajax({
      type: 'POST',
      url: '/ngsLIMS/setting/sampleLocations',
      data: {
        sample_location_id: sample_location_id,
        name: name,
        active: active
      }
    })
        .done(function (data) {
          //console.log(data);
          window.location.reload();  // @TODO It should not be re-loaded.
        });
  }

  /**
   * Delete sample_location record. (It will be soft-deleted (active=N).)
   * @param sample_location_id
   * @returns {boolean}
   */
  function sampleLocationRemove(sample_location_id) {
    if (!sample_location_id) {
      alert('Error: Could not found sample_location_id value.');
      return false;
    }

    if (window.confirm("This Sample Location will be in-active.\n\nAre You Sure?")) {
      $.ajax({
        type: 'POST',
        url: '/ngsLIMS/setting/sampleLocations',
        data: {
          sample_location_id: sample_location_id,
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
    $('#sample_location-table').DataTable({
      paging: false,
      order: []
    });

    $('#modal-sample_location-edit')
        .find('input, select')
        .change(function () {
          $('#modal-sample_location-save').removeClass('disabled');
        });

  });
</script>