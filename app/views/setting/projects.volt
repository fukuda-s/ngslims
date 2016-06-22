<!--suppress ALL -->
<div class="row">
  <div class="col-md-12">
    <ol class="breadcrumb">
      <li>{{ link_to('setting', 'Setting') }}</li>
      <li class="active">Projects</li>
    </ol>

    {{ content() }}
    {{ flashSession.output() }}

    <button type="button" class="btn btn-xs btn-primary pull-left"
            onclick="projectEdit(-1, '', '', '{{ my_user.getFullname() }}', '', '', '', 'Y', '0')"
            style="margin: 10px 0; width: 261px ">
      <i class="fa fa-plus" aria-hidden="true"></i>&ensp;
      Create New Project
    </button>
    <button type="button" class="btn btn-xs pull-right" style="margin: 0 0 10px 0; width: 261px "
            onclick="showInactive(this)">
      <div><i class="fa fa-ban" aria-hidden="true"></i>&ensp;Show In-active Projects</div>
      <div style="display: none"><i class="fa fa-ban" aria-hidden="true"></i>&ensp;Hide In-active Projects</div>
    </button>
    <div class="clearfix"></div>

    <table class="table table-condensed table-hover table-striped" id="project-table" style="font-size: 70%">
      <thead>
      <tr>
        <th>ID</th>
        <th>Lab Name</th>
        <th>Project Name</th>
        <!--<th>Project Code</th>-->
        <th>Created User Name</th>
        <th>Project PI Name</th>
        <th>Project Type</th>
        <th>Created At</th>
        <th>Description</th>
        <th>Active</th>
        <th>Edit</th>
      </tr>
      </thead>
      <tbody>
      {% for project in projects %}
        {% set active = project.active %}
        <tr
            {% if active is 'N' %}
              class="danger inactive" style="display: none"
            {% endif %}
        >
          <td>{{ project.id }}</td>
          <td>{{ project.Labs.name }}</td>
          <td>{{ link_to('trackerdetails/showTableSamples/' ~ project.id, project.name) }}</td>
          {% if project.Users is empty %}
            <td>Undefined</td>
          {% else %}
            <td>{{ project.Users.getFullname() }}</td>
          {% endif %}
          {% if project.PIs is empty %}
            <td>Undefined</td>
          {% else %}
            <td>{{ link_to('summary/projectPi/#pi_user_id_' ~ project.PIs.id, project.PIs.getFullname()) }}</td>
          {% endif %}
          <td>{{ project.ProjectTypes.name }}</td>
          <td>{{ project.created_at }}</td>
          <td>{{ project.description }}</td>
          {% if active is 'Y' %}
            <td>{{ active }}</td>
          {% else %}
            <td class="text-danger">{{ active }}</td>
          {% endif %}
          {% set project_sample_count = project.Samples|length %}
          <td class="text-center">
            <a href="javascript:void(0)" style="font-size: 9pt"
               onclick="projectEdit('{{ project.id }}', '{{ project.lab_id }}', '{{ project.name }}', '{{ project.Users.getFullname() }}', '{{ project.pi_user_id }}', '{{ project.project_type_id }}', '{{ project.description }}', '{{ project.active }}', '{{ project_sample_count }}'); return false;">
              <span class="fa fa-pencil"></span>&ensp;
            </a>
            {{ link_to('setting/projectUsers/' ~ project.id, "<i class='fa fa-user-plus'></i>&ensp;") }}
            {% if project_sample_count == 0 %}
              <a href="javascript:void(0)" style="font-size: 9pt"
                 onclick="projectRemove({{ project.id }}); return false;"><span class="fa fa-trash"></span></a>
            {% else %}
              {% set trash_message = "Could not delete this Project. This Project already has " ~ project_sample_count ~ " samples." %}
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
<div class="modal fade form-horizontal" id="modal-project-edit" tabindex="-1" role="dialog"
     aria-labelledby="modal-project-edit-title"
     aria-hidden="true">
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
        <h4 class="modal-title" id="modal-project-edit-title">Edit</h4>
      </div>
      <div class="modal-body">
        <h5>Please press 'Save' button when finished edit.</h5>
        <h5 class="text-danger">CATION! Could not rollback after 'Save'.</h5>
        <br>
        {{ hidden_field('modal-project_id') }}
        <div class="form-group form-group-sm">
          <label for="modal-department" class="col-sm-3 control-label" style="font-size: 9pt">Laboratory Name</label>
          <div class="col-sm-9">
            {{ select('modal-lab_id', labs, 'using': ['id', 'name'], 'class': 'form-control') }}
          </div>
        </div>
        <div class="form-group form-group-sm">
          <label for="modal-name" class="col-sm-3 control-label" style="font-size: 9pt">Project Name</label>
          <div class="col-sm-9">
            {{ text_field('modal-name', 'class': 'form-control') }}
          </div>
        </div>
        <div class="form-group form-group-sm">
          <label for="modal-user_name" class="col-sm-3 control-label" style="font-size: 9pt">Created User Name</label>
          <div class="col-sm-9">
            {{ text_field('modal-user_name', 'class': 'form-control', 'disabled': 'disabled') }}
          </div>
        </div>
        <div class="form-group form-group-sm">
          <label for="modal-pi_user_id" class="col-sm-3 control-label" style="font-size: 9pt">Project PI Name</label>
          <div class="col-sm-9">
            {{ select_static('modal-pi_user_id', [], 'useEmpty': true, 'emptyText': 'Please Select Laboratory Name...', 'emptyValue': '@', 'value': '@', 'disabled': 'disabled', 'class': 'form-control') }}
          </div>
        </div>
        <div class="form-group form-group-sm">
          <label for="modal-project_type_id" class="col-sm-3 control-label" style="font-size: 9pt">Project Type</label>
          <div class="col-sm-9">
            {{ select('modal-project_type_id', project_types, 'using': ['id', 'name'], 'class': 'form-control') }}
          </div>
        </div>
        <div class="form-group form-group-sm">
          <label for="modal-description" class="col-sm-3 control-label" style="font-size: 9pt">Description</label>
          <div class="col-sm-9">
            {{ text_field('modal-description', 'class': 'form-control') }}
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
          <button type="button" id="modal-project-save" class="btn btn-primary pull-right disabled"
                  onclick="projectSave()">
            Save
          </button>
        </div>
      </div>
    </div>
  </div>
</div>

<script>

  /**
   * Generate pi_user_id select on modal.
   */
  function createPiUsersSelect(lab_id, pi_user_id) {
    var modal_pi_user_id = $('#modal-pi_user_id');
    $.ajax({
      type: 'POST',
      url: '/ngsLIMS/setting/createPiUsersSelect',
      data: {
        lab_id: lab_id,
        pi_user_id: pi_user_id
      }
    })
        .done(function (data) {
          //console.log(data);
          modal_pi_user_id
              .replaceWith(data)
        });
  }
  /**
   * Open modal window with filling values.
   */
  function projectEdit(project_id, lab_id, name, user_name, pi_user_id, project_type_id, description, active, project_sample_count) {
    //console.log(project_sample_count);

    createPiUsersSelect(lab_id, pi_user_id);

    $('#modal-lab_id').change(function(){
      var changed_lab_id = $(this).val();
      createPiUsersSelect(changed_lab_id, 0);
    });

    $('#modal-project_id').val(project_id);
    $('#modal-lab_id').val(lab_id);
    $('#modal-name').val(name);
    $('#modal-user_name').val(user_name);
    //modal_pi_user_id.val(pi_user_id);
    $('#modal-project_type_id').val(project_type_id);
    $('#modal-description').val(description);
    $('#modal-active').val(active);

    if(project_sample_count > 0) {
      $('#modal-active').attr('disabled', 'disabled');
    } else {
      $('#modal-active').removeAttr('disabled');
    }


    $('#modal-project-save').addClass('disabled');

    $('#modal-project-edit').modal('show');

  }

  /**
   * Save edit results on modal window.
   * @returns {boolean}
   */
  function projectSave() {
    if (!$('#modal-name').val().length) {
      alert('Please input Project name.');
      return false;
    }

    $('#modal-lab-edit').modal('hide');

    var project_id = $('#modal-project_id').val();
    var lab_id = $('#modal-lab_id').val();
    var name = $('#modal-name').val();
    var pi_user_id = $('#modal-pi_user_id').val();
    var project_type_id = $('#modal-project_type_id').val();
    var description = $('#modal-description').val();
    var active = $('#modal-active').val();
    $.ajax({
      type: 'POST',
      url: '/ngsLIMS/setting/projects',
      data: {
        project_id: project_id,
        lab_id: lab_id,
        name: name,
        pi_user_id: pi_user_id,
        project_type_id: project_type_id,
        description: description,
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
   * @param project_id
   * @returns {boolean}
   */
  function projectRemove(project_id) {
    if (!project_id) {
      alert('Error: Could not found project_id value.');
      return false;
    }

    if (window.confirm("This Project will be in-active.\n\nAre You Sure?")) {
      $.ajax({
        type: 'POST',
        url: '/ngsLIMS/setting/projects',
        data: {
          project_id: project_id,
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
    $('#project-table').DataTable({
      paging: false,
      order: []
    });

    $('#modal-project-edit')
        .find('input, select')
        .change(function () {
          $('#modal-project-save').removeClass('disabled');
        });

  });
</script>