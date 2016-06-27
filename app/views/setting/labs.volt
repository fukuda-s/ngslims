<div class="row">
  <div class="col-md-12">
    <ol class="breadcrumb">
      <li>{{ link_to('setting', 'Setting') }}</li>
      <li class="active">Users</li>
    </ol>

    {{ content() }}
    {{ flashSession.output() }}

    <button type="button" class="btn btn-xs btn-primary pull-left"
            onclick="labEdit(-1, '', '', '', '', '', '', '', '', 'Y', '0')"
            style="margin: 10px 0; width: 261px ">
      <i class="fa fa-plus" aria-hidden="true"></i>&ensp;
      Create New Laboratory
    </button>
    <button type="button" class="btn btn-xs pull-right" style="margin: 0 0 10px 0; width: 261px "
            onclick="showInactive(this)">
      <div><i class="fa fa-ban" aria-hidden="true"></i>&ensp;Show In-active Labs</div>
      <div style="display: none"><i class="fa fa-ban" aria-hidden="true"></i>&ensp;Hide In-active Labs</div>
    </button>
    <div class="clearfix"></div>

    <table class="table table-condensed table-hover table-striped" id="lab-table" style="font-size: 70%">
      <thead>
      <tr>
        <th>ID</th>
        <th>Lab Name</th>
        <th>Department</th>
        <th>Zipcode</th>
        <th>Address 1</th>
        <th>Address 2</th>
        <th>Phone</th>
        <th>Fax</th>
        <th>Email</th>
        <th>Active</th>
        <th>Edit</th>
      </tr>
      </thead>
      <tbody>
      {% for lab in labs %}
        {% set active = lab.active %}
        <tr
            {% if active is 'N' %}
              class="danger inactive" style="display: none"
            {% endif %}
        >
          <td>{{ lab.id }}</td>
          <td>{{ lab.name }}</td>
          <td>{{ lab.department }}</td>
          <td>{{ lab.zipcode }}</td>
          <td>{{ lab.address1 }}</td>
          <td>{{ lab.address2 }}</td>
          <td>{{ lab.phone }}</td>
          <td>{{ lab.fax }}</td>
          <td>{{ lab.email }}</td>
          {% if active is 'Y' %}
            <td>{{ active }}</td>
          {% else %}
            <td class="text-danger">{{ active }}</td>
          {% endif %}
          {% set lab_user_count = lab.LabUsers|length %}
          <td class="text-center">
            <a href="javascript:void(0)" style="font-size: 9pt"
               onclick="labEdit('{{ lab.id }}', '{{ lab.name }}', '{{ lab.department }}', '{{ lab.zipcode }}', '{{ lab.address1 }}', '{{ lab.address2 }}', '{{ lab.phone }}', '{{ lab.fax }}', '{{ lab.email }}', '{{ lab.active }}', '{{ lab_user_count }}'); return false;">
              <span class="fa fa-pencil"></span>&ensp;
            </a>
            {{ link_to('setting/labUsers/' ~ lab.id, "<i class='fa fa-user-plus'></i>&ensp;") }}
            {% if lab_user_count == 0 %}
              <a href="javascript:void(0)" style="font-size: 9pt"
                 onclick="labRemove({{ lab.id }}); return false;"><span class="fa fa-trash"></span></a>
            {% else %}
              {% set trash_message = "Could not delete this Laboratory. This Lab. has " ~ lab_user_count ~ " members." %}
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
<div class="modal fade form-horizontal" id="modal-lab-edit" tabindex="-1" role="dialog"
     aria-labelledby="modal-lab-edit-title"
     aria-hidden="true">
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
        <h4 class="modal-title" id="modal-lab-edit-title">Edit</h4>
      </div>
      <div class="modal-body">
        <h5>Please press 'Save' button when finished edit.</h5>
        <h5 class="text-danger">CATION! Could not rollback after 'Save'.</h5>
        <br>
        {{ hidden_field('modal-lab_id') }}
        <div class="form-group form-group-sm">
          <label for="modal-name" class="col-sm-3 control-label" style="font-size: 9pt">Laboratory Name</label>
          <div class="col-sm-9">
            {{ text_field('modal-name', 'class': 'form-control') }}
          </div>
        </div>
        <div class="form-group form-group-sm">
          <label for="modal-department" class="col-sm-3 control-label" style="font-size: 9pt">Department</label>
          <div class="col-sm-9">
            {{ text_field('modal-department', 'class': 'form-control') }}
          </div>
        </div>
        <div class="form-group form-group-sm">
          <label for="modal-zipcode" class="col-sm-3 control-label" style="font-size: 9pt">Zipcode</label>
          <div class="col-sm-9">
            {{ text_field('modal-zipcode', 'class': 'form-control') }}
          </div>
        </div>
        <div class="form-group form-group-sm">
          <label for="modal-address1" class="col-sm-3 control-label" style="font-size: 9pt">Address 1</label>
          <div class="col-sm-9">
            {{ text_field('modal-address1', 'class': 'form-control') }}
          </div>
        </div>
        <div class="form-group form-group-sm">
          <label for="modal-address2" class="col-sm-3 control-label" style="font-size: 9pt">Address 2</label>
          <div class="col-sm-9">
            {{ text_field('modal-address2', 'class': 'form-control') }}
          </div>
        </div>
        <div class="form-group form-group-sm">
          <label for="modal-phone" class="col-sm-3 control-label" style="font-size: 9pt">Phone</label>
          <div class="col-sm-9">
            {{ text_field('modal-phone', 'class': 'form-control') }}
          </div>
        </div>
        <div class="form-group form-group-sm">
          <label for="modal-fax" class="col-sm-3 control-label" style="font-size: 9pt">Fax</label>
          <div class="col-sm-9">
            {{ text_field('modal-fax', 'class': 'form-control') }}
          </div>
        </div>
        <div class="form-group form-group-sm">
          <label for="modal-email" class="col-sm-3 control-label" style="font-size: 9pt">Email</label>
          <div class="col-sm-9">
            {{ email_field('modal-email', 'class': 'form-control') }}
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
          <button type="button" id="modal-lab-save" class="btn btn-primary pull-right disabled" onclick="labSave()">
            Save
          </button>
        </div>
      </div>
    </div>
  </div>
</div>

<script>
  /**
   * DataTables
   */
  $(document).ready(function () {
    $('#lab-table').DataTable({
      paging: false,
      order: []
    });

    $('#modal-lab-edit')
        .find('input, select')
        .change(function () {
          $('#modal-lab-save').removeClass('disabled');
        });

  });

  /**
   * Open modal window with filling values.
   */
  function labEdit(lab_id, name, department, zipcode, address1, address2, phone, fax, email, active, lab_user_count) {
    $('#modal-lab_id').val(lab_id);
    $('#modal-name').val(name);
    $('#modal-department').val(department);
    $('#modal-zipcode').val(zipcode);
    $('#modal-address1').val(address1);
    $('#modal-address2').val(address2);
    $('#modal-phone').val(phone);
    $('#modal-fax').val(fax);
    $('#modal-email').val(email);
    $('#modal-active').val(active);

    if(lab_user_count > 0) {
      $('#modal-active').attr('disabled', 'disabled');
    } else {
      $('#modal-active').removeAttr('disabled');
    }

    $('#modal-lab-save').addClass('disabled');

    $('#modal-lab-edit').modal('show');

  }

  /**
   * Save edit results on modal window.
   * @returns {boolean}
   */
  function labSave() {
    if (!$('#modal-name').val().length) {
      alert('Please input Laboratory name.');
      return false;
    }

    $('#modal-lab-edit').modal('hide');

    var lab_id = $('#modal-lab_id').val();
    var name = $('#modal-name').val();
    var department = $('#modal-department').val();
    var zipcode = $('#modal-zipcode').val();
    var address1 = $('#modal-address1').val();
    var address2 = $('#modal-address2').val();
    var phone = $('#modal-phone').val();
    var fax = $('#modal-fax').val();
    var email = $('#modal-email').val();
    var active = $('#modal-active').val();
    $.ajax({
      type: 'POST',
      url: '/ngsLIMS/setting/labs',
      data: {
        lab_id: lab_id,
        name: name,
        department: department,
        zipcode: zipcode,
        address1: address1,
        address2: address2,
        phone: phone,
        fax: fax,
        email: email,
        active: active
      }
    })
        .done(function (data) {
          //console.log(data);
          window.location.reload();  // @TODO It should not be re-loaded.
        });
  }

  /**
   * Delete lab record. (It will be soft-deleted (active=N).)
   * @param lab_id
   * @returns {boolean}
   */
  function labRemove(lab_id) {
    if (!lab_id) {
      alert('Error: Could not found lab_id value.');
      return false;
    }

    if (window.confirm("This Laboratory will be in-active.\n\nAre You Sure?")) {
      $.ajax({
        type: 'POST',
        url: '/ngsLIMS/setting/labs',
        data: {
          lab_id: lab_id,
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
</script>