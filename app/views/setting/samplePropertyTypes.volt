<!--suppress ALL -->
<div class="row">
  <div class="col-md-12">
    <ol class="breadcrumb">
      <li>{{ link_to('setting', 'Setting') }}</li>
      <li class="active">Sample Property Types</li>
    </ol>

    {{ content() }}
    {{ flashSession.output() }}

    <button type="button" class="btn btn-xs btn-primary pull-left"
            onclick="samplePropertyTypeEdit(-1, '', '', '', 'Y', 0)"
            style="margin: 10px 0; width: 261px ">
      <i class="fa fa-plus" aria-hidden="true"></i>&ensp;
      Create New Sample Property Type
    </button>
    <button type="button" class="btn btn-xs pull-right" style="margin: 0 0 10px 0; width: 261px "
            onclick="showInactive(this)">
      <div><i class="fa fa-ban" aria-hidden="true"></i>&ensp;Show In-active Sample Property Type</div>
      <div style="display: none"><i class="fa fa-ban" aria-hidden="true"></i>&ensp;Hide In-active Sample Property Type</div>
    </button>
    <div class="clearfix"></div>

    <table class="table table-condensed table-hover table-striped" id="sample_property_type-table" style="font-size: 70%">
      <thead>
      <tr>
        <th>ID</th>
        <th>Sample Property Name</th>
        <th>MGED Ontology (MO) Term Name</th>
        <th>MO unique_identifier</th>
        <th>Active</th>
        <th>Edit</th>
      </tr>
      </thead>
      <tbody>
      {% for sample_property_type in sample_property_types %}
        {% set active = sample_property_type.active %}
        <tr
            {% if active is 'N' %}
              class="danger inactive" style="display: none"
            {% endif %}
        >
          <td>{{ sample_property_type.id }}</td>
          <td>{{ sample_property_type.name }}</td>
          <td>{{ sample_property_type.mo_term_name }}</td>
          <td>{{ sample_property_type.mo_id }}</td>
          {% if active is 'Y' %}
            <td>{{ active }}</td>
          {% else %}
            <td class="text-danger">{{ active }}</td>
          {% endif %}
          {% set sample_property_type_sample_property_entry_count = sample_property_type.SamplePropertyEntries|length %}
          <td class="text-center">
            <a href="javascript:void(0)" style="font-size: 9pt"
               onclick="samplePropertyTypeEdit('{{ sample_property_type.id }}', '{{ sample_property_type.name }}', '{{ sample_property_type.mo_term_name }}', '{{ sample_property_type.mo_id }}', '{{ sample_property_type.active }}', '{{ sample_property_type_sample_property_entry_count }}'); return false;">
              <span class="fa fa-pencil"></span>&ensp;
            </a>
            {% if sample_property_type_sample_property_entry_count == 0 %}
              <a href="javascript:void(0)" style="font-size: 9pt"
                 onclick="samplePropertyTypeRemove({{ sample_property_type.id }}); return false;"><span class="fa fa-trash"></span></a>
            {% else %}
              {% set trash_message = "Could not delete this Sample Property Type. This Sample Property Type is already used by " ~ sample_property_type_sample_property_entry_count ~ " samples." %}
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
<div class="modal fade form-horizontal" id="modal-sample_property_type-edit" tabindex="-1" role="dialog"
     aria-labelledby="modal-sample_property_type-edit-title"
     aria-hidden="true">
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
        <h4 class="modal-title" id="modal-sample_property_type-edit-title">Edit</h4>
      </div>
      <div class="modal-body">
        <h5>Please press 'Save' button when finished edit.</h5>
        <h5 class="text-danger">CATION! Could not rollback after 'Save'.</h5>
        <br>
        {{ hidden_field('modal-sample_property_type_id') }}
        <div class="form-group form-group-sm">
          <label for="modal-name" class="col-sm-3 control-label" style="font-size: 9pt">Sample Property Type Name</label>
          <div class="col-sm-9">
            {{ text_field('modal-name', 'class': 'form-control') }}
          </div>
        </div>
        <div class="form-group form-group-sm">
          <label for="modal-mo_term_name" class="col-sm-3 control-label" style="font-size: 9pt">MGED Ontology (MO) Term Name</label>
          <div class="col-sm-9">
            {{ text_field('modal-mo_term_name', 'class': 'form-control') }}
          </div>
        </div>
        <div class="form-group form-group-sm">
          <label for="modal-mo_id" class="col-sm-3 control-label" style="font-size: 9pt">MO unique_identifier
            Code</label>
          <div class="col-sm-9">
            {{ text_field('modal-mo_id', 'class': 'form-control') }}
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
          <button type="button" id="modal-sample_property_type-save" class="btn btn-primary pull-right disabled"
                  onclick="samplePropertyTypeSave()">
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
  function samplePropertyTypeEdit(sample_property_type_id, name, mo_term_name, mo_id, active, sample_property_type_sample_property_entry_count) {

    $('#modal-sample_property_type_id').val(sample_property_type_id);
    $('#modal-name').val(name);
    $('#modal-mo_term_name').val(mo_term_name);
    $('#modal-mo_id').val(mo_id);
    $('#modal-active').val(active);

    // @TODO should be consider details condition of details
    if (sample_property_type_sample_property_entry_count > 0 ) {
      $('#modal-active').attr('disabled', 'disabled');
    } else {
      $('#modal-active').removeAttr('disabled');
    }

    $('#modal-sample_property_type-save').addClass('disabled');

    $('#modal-sample_property_type-edit').modal('show');

  }

  /**
   * Save edit results on modal window.
   * @returns {boolean}
   */
  function samplePropertyTypeSave() {
    if (!$('#modal-name').val().length) {
      alert('Please input Sample Property Type name.');
      return false;
    }

    $('#modal-sample_property_type-edit').modal('hide');

    var sample_property_type_id = $('#modal-sample_property_type_id').val();
    var name = $('#modal-name').val();
    var mo_term_name = $('#modal-mo_term_name').val();
    var mo_id = $('#modal-mo_id').val();
    var active = $('#modal-active').val();
    $.ajax({
      type: 'POST',
      url: '/ngsLIMS/setting/samplePropertyTypes',
      data: {
        sample_property_type_id: sample_property_type_id,
        name: name,
        mo_term_name: mo_term_name,
        mo_id: mo_id,
        active: active
      }
    })
        .done(function (data) {
          //console.log(data);
          window.location.reload();  // @TODO It should not be re-loaded.
        });
  }

  /**
   * Delete project record. (It will be soft-deleted (active=N).)
   * @param sample_property_type_id
   * @returns {boolean}
   */
  function samplePropertyTypeRemove(sample_property_type_id) {
    if (!sample_property_type_id) {
      alert('Error: Could not found sample_property_type_id value.');
      return false;
    }

    if (window.confirm("This Sample Property Type will be in-active.\n\nAre You Sure?")) {
      $.ajax({
        type: 'POST',
        url: '/ngsLIMS/setting/samplePropertyTypes',
        data: {
          sample_property_type_id: sample_property_type_id,
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
    $('#sample_property_type-table').DataTable({
      paging: false,
      order: []
    });

    $('#modal-sample_property_type-edit')
        .find('input, select')
        .change(function () {
          $('#modal-sample_property_type-save').removeClass('disabled');
        });

  });
</script>