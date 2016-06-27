<div class="row">
  <div class="col-md-12">
    <ol class="breadcrumb">
      <li>{{ link_to('setting', 'Setting') }}</li>
      <li class="active">Labs</li>
    </ol>

    {{ content() }}
    {{ flashSession.output() }}

    <button type="button" class="btn btn-xs btn-primary pull-left"
            onclick="userEdit(-1, '', '', '', '', 'Y', '0')"
            style="margin: 10px 0; width: 261px ">
      <i class="fa fa-plus" aria-hidden="true"></i>&ensp;
      Create New User Account
    </button>
    <button type="button" class="btn btn-xs pull-right" style="margin: 0 0 10px 0; width: 261px "
            onclick="showInactive(this)">
      <div><i class="fa fa-ban" aria-hidden="true"></i>&ensp;Show In-active Users</div>
      <div style="display: none"><i class="fa fa-ban" aria-hidden="true"></i>&ensp;Hide In-active Users</div>
    </button>
    <div class="clearfix"></div>

    <table class="table table-condensed table-hover table-striped" id="user-table" style="font-size: 70%">
      <thead>
      <tr>
        <th>ID</th>
        <th>Lab Name</th>
        <th>Username</th>
        <th>Firstname</th>
        <th>Lastname</th>
        <th>Email</th>
        <th>Created At</th>
        <th>Active</th>
        <th>Edit</th>
      </tr>
      </thead>
      <tbody>
      {% for user in users %}
        {% set active = user.u.active %}
        <tr
            {% if active is 'N' %}
              class="danger inactive" style="display: none"
            {% endif %}
        >
          <td>{{ user.u.id }}</td>
          <td>{{ user.lab_names }}</td>
          <td>{{ user.u.username }}</td>
          <td>{{ user.u.firstname }}</td>
          <td>{{ user.u.lastname }}</td>
          <td>{{ user.u.email }}</td>
          <td>{{ user.u.created_at }}</td>
          {% if active is 'Y' %}
            <td>{{ active }}</td>
          {% else %}
            <td class="text-danger">{{ active }}</td>
          {% endif %}
          <td class="text-center">
            <a href="javascript:void(0)" style="font-size: 9pt"
               onclick="userEdit('{{ user.u.id }}', '{{ user.u.username }}', '{{ user.u.firstname }}', '{{ user.u.lastname }}', '{{ user.u.email }}', '{{ user.u.active }}', '{{ user.project_count }}'); return false;">
              <span class="fa fa-pencil"></span>&ensp;
            </a>
            {% if user.project_count == 0 %}
              <a href="javascript:void(0)" style="font-size: 9pt"
                 onclick="userRemove({{ user.u.id }}); return false;"><span class="fa fa-trash"></span></a>
            {% else %}
              {% set trash_message = "Could not delete this user. This user has " ~ user.project_count ~ " projects." %}
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
<div class="modal fade form-horizontal" id="modal-user-edit" tabindex="-1" role="dialog"
     aria-labelledby="modal-user-edit-title"
     aria-hidden="true">
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
        <h4 class="modal-title" id="modal-user-edit-title">Edit</h4>
      </div>
      <div class="modal-body">
        <h5>Please press 'Save' button when finished edit.</h5>
        <h5 class="text-danger">CATION! Could not rollback after 'Save'.</h5>
        <br>
        {{ hidden_field('modal-user_id') }}
        <div class="form-group form-group-sm">
          <label for="modal-lab_id" class="col-sm-3 control-label" style="font-size: 9pt">Lab name</label>
          <div id="modal-lab_id-checkbox-field" class="col-sm-9 checkbox">

          </div>
        </div>
        <div class="form-group form-group-sm">
          <label for="modal-username" class="col-sm-3 control-label" style="font-size: 9pt">Account</label>
          <div class="col-sm-9">
            {{ text_field('modal-username', 'class': 'form-control') }}
          </div>
        </div>
        <div class="form-group form-group-sm">
          <label for="modal-lastname" class="col-sm-3 control-label" style="font-size: 9pt">Lastname</label>
          <div class="col-sm-9">
            {{ text_field('modal-lastname', 'class': 'form-control') }}
          </div>
        </div>
        <div class="form-group form-group-sm">
          <label for="modal-firstname" class="col-sm-3 control-label" style="font-size: 9pt">Firstname</label>
          <div class="col-sm-9">
            {{ text_field('modal-firstname', 'class': 'form-control') }}
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
        <hr>
        <div class="form-group">
          <div class="col-sm-10">
            <div class="checkbox">
              <label class="checkbox">
                {{ check_field("modal-password_reset", "data-toggle": "checkbox", "value": "on") }}
                Overwrite password with random phrase.
              </label>
            </div>
          </div>
        </div>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-default" data-dismiss="modal">Cancel</button>
        <button type="button" id="modal-user-save" class="btn btn-primary pull-right disabled" onclick="userSave()">
          Save
        </button>
      </div>
    </div>
  </div>
</div>

<script>
  /*
   * DataTables
   */
  $(document).ready(function () {
    $('#user-table').DataTable({
      paging: false,
      order: []
    });

    $('#modal-user-edit')
        .find('input, select')
        .change(function () {
          $('#modal-user-save').removeClass('disabled');
        });

  });

  /**
   * Open modal window with filling values.
   * @param user_id
   * @param username
   * @param firstname
   * @param lastname
   * @param email
   * @param active
   */
  function userEdit(user_id, username, firstname, lastname, email, active, project_count) {
    $('#modal-user_id').val(user_id);
    $('#modal-username').val(username);
    $('#modal-firstname').val(firstname);
    $('#modal-lastname').val(lastname);
    $('#modal-email').val(email);
    $('#modal-active').val(active);

    //新規ユーザー設定時は「パスワードをアカウント名でリセットする」をチェック済み＆disableする。
    if (user_id == -1) {
      $('#modal-password_reset')
          .attr('checked', 'checked')
          .attr('disabled', 'disabled')
          .parents('label.checkbox')
          .addClass('checked')
          .addClass('disabled');
    } else {
      $('#modal-password_reset')
          .removeAttr('checked')
          .removeAttr('disabled')
          .parents('label.checkbox')
          .removeClass('checked')
          .removeClass('disabled');
    }

    if (project_count > 0) {
      $('#modal-active').attr('disabled', 'disabled');
    } else {
      $('#modal-active').removeAttr('disabled');
    }

    $('#modal-user-save').addClass('disabled');

    $.ajax({
      type: 'POST',
      url: '/ngsLIMS/setting/createLabsCheckField',
      data: {
        user_id: user_id
      }
    })
        .done(function (data) {
          $('#modal-lab_id-checkbox-field').html(data)
        });


    $('#modal-user-edit').modal('show');
  }

  /**
   * Save edit results on modal window.
   * @returns {boolean}
   */
  function userSave() {
    if (!$('#modal-username').val().length) {
      alert('Please input username.');
      return false;
    }
    if (!$('#modal-lastname').val().length) {
      alert('Please input firstname.');
      return false;
    }
    if (!$('#modal-firstname').val().length) {
      alert('Please input lastname.');
      return false;
    }
    $('#modal-user-edit').modal('hide');

    var user_id = $('#modal-user_id').val();
    var lab_id_array = $('[id^=checkbox-lab_id-]:checked').map(function () {
      return $(this).val();
    }).get();
    if (!lab_id_array.length) {
      alert('Please check at least one laboratory.');
      return false;
    }
    var username = $('#modal-username').val();
    var firstname = $('#modal-firstname').val();
    var lastname = $('#modal-lastname').val();
    var email = $('#modal-email').val();
    var active = $('#modal-active').val();
    var password_reset = $('#modal-password_reset').filter(':checked').val();
    $.ajax({
      type: 'POST',
      url: '/ngsLIMS/setting/users',
      data: {
        user_id: user_id,
        lab_id_array: lab_id_array,
        username: username,
        firstname: firstname,
        lastname: lastname,
        email: email,
        active: active,
        password_reset: password_reset
      }
    })
        .done(function (data) {
          //console.log(data);
          window.location.reload();  // @TODO It should not be re-loaded.
        });
  }

  /**
   * Delete user account. (It will be soft-deleted (active=N).)
   * @param user_id
   * @returns {boolean}
   */
  function userRemove(user_id) {
    if (!user_id) {
      alert('Error: Could not found user_id value.');
      return false;
    }

    if (window.confirm("This user will be in-active.\n\nAre You Sure?")) {
      $.ajax({
        type: 'POST',
        url: '/ngsLIMS/setting/users',
        data: {
          user_id: user_id,
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