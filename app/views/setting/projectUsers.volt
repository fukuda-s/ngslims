<div class="row">
  <div class="col-md-12">
    <ol class="breadcrumb">
      <li>{{ link_to('setting', 'Setting') }}</li>
      <li>{{ link_to('setting/projects', 'Projects') }}</li>
      <li>{{ project.name }}</li>
      <li class="active">Project Members</li>
    </ol>

    {{ content() }}
    {{ flashSession.output() }}
  </div>
</div>

{{ hidden_field('project_id', 'value': project.id) }}

<div class="row">
  <div class="col-md-5">
    <div class="panel panel-default">
      <div class="panel-heading">
        <h3 class="panel-title">All User List</h3>
      </div>
      <div class="panel-body">
        <div class="form-group">
          {{ text_field('user_candidate_filter', 'class': "form-control", 'placeholder': 'Search Users') }}
        </div>
        <div class="tube-group">
          <div class="tube-list" id="user_candidate_holder">
            {% for user in users_candidate %}
              <div class="tube tube-active" id="user_id-{{ user.id }}">
                {{ user.getFullname() }}
              </div>
              {% elsefor %} No Users are recorded.
            {% endfor %}
          </div>
        </div>
      </div>
    </div>
  </div>
  <div class="col-md-7">
    <div class="panel panel-default">
      <div class="panel-heading">
        <div class="row">
          <div class="col-sm-10">
            <h3 class="panel-title col-sm-10">Project Member List</h3>
          </div>
          <div class="col-sm-2">
            <button type="button" id="project_users_save" class="btn btn-primary pull-right" disabled="disabled">Save
            </button>
          </div>
        </div>
      </div>
      <div class="panel-body">
        <div class="form-group">
          {{ text_field('project_users_filter', 'class': "form-control", 'placeholder': 'Search Users') }}
        </div>
        <div class="tube-group">
          <div class="tube-list" id="project_users_holder">
            {% for user in project_users %}
              {% if user.user_id is not project.pi_user_id %}
                <div class="tube" id="user_id-{{ user.user_id }}">{{ user.Users.getFullname() }}
                  <a href="javascript:void(0)" class="tube-close pull-right" onclick="tubeCloseToggle(this)">
                    <i class="fa fa-times" aria-hidden="true"></i>
                    <i class="fa fa-repeat" aria-hidden="true" style="display: none"></i>
                  </a>
                </div>
              {% else %}
                {% set trash_message = "Could not delete this Member. This member PI of this project." %}
                <div class="tube tube-warning" id="user_id-{{ user.user_id }}">{{ user.Users.getFullname() }}
                  <a href="javascript:void(0)" data-toggle="tooltip" data-placement="bottom" title="{{ trash_message }}"
                     style="color: #b9c4c8; cursor: not-allowed;" class="tube-close pull-right" onclick="return false;">
                    <i class="fa fa-times" aria-hidden="true"></i>
                  </a>
                </div>
              {% endif %}
              {% elsefor %} No Project Members are recorded
            {% endfor %}
          </div>
        </div>
      </div>
    </div>
  </div>
</div>

<script>
  /**
   * Filter tube from 'queryStr' which placed in 'target'.
   * @param queryStr
   * @param target
   */
  function tubeFilter(queryStr, target) {
    $(target)
        .find('.tube')
        .filter(function () {
          var css_display = $(this).css('display');
          var tube_textStr = $(this).text().toString();
          //console.log(index + ":" + css_display != 'none' && ! queryStr.test(tube_textStr));
          return css_display != 'none' && !queryStr.test(tube_textStr);
        })
        .addClass('tube-hidden');

    $(target)
        .find('.tube-hidden')
        .filter(function () {
          var tube_textStr = $(this).text().toString();
          return queryStr.test(tube_textStr);
        })
        .removeClass('tube-hidden');
  }

  /**
   * Toggle button icon and tube class
   */
  function tubeCloseToggle(target) {
    //console.log('clicked');
    $(target)
        .parent('.tube')
        .toggleClass('tube-inactive');
    $(target)
        .find('i')
        .toggle();

    var project_users_holder = $('#project_users_holder');
    var project_users_save = $('#project_users_save');
    if (project_users_holder.find('div.tube-active:not(.tube-inactive)').length //For dragged users
        || project_users_holder.find('div.tube-inactive:not(.tube-active)').length) { //For original users
      project_users_save.prop('disabled', false);
    } else {
      project_users_save.prop('disabled', true);
    }
  }

  $(document).ready(function () {
    $('#user_candidate_holder').sortable({
      connectWith: "#project_users_holder",
      placeholder: "tube tube-placeholder",
      revert: true,
      pointer: "move",
      opacity: 0.5,
      helper: "clone",
      remove: function (event, ui) {
        // Append close button on sorted seqlib tube
        //console.log(ui.item.find('button').length);
        if (!ui.item.find('button').length) {
          ui.item
              .append('<button type="button" class="tube-close pull-right">' +
                  '<i class="fa fa-times" aria-hidden="true"></i>' +
                  '<i class="fa fa-repeat" aria-hidden="true" style="display: none"></i>' +
                  '</button>')
              .find('button.tube-close').click(tubeCloseToggle);
        }
      }

    });

    $('#project_users_holder').sortable({
      update: function (event, ui) {
        var item = ui.item.parent();
        var funcSort = function (a, b) {
          var compA = $(a).text().trim();
          var compB = $(b).text().trim();
          return (compA < compB) ? -1 : (compA > compB) ? 1 : 0;
        };
        var listItems = item.children('div').get();
        listItems.sort(funcSort);
        $.each(listItems, function (i, itm) {
          item.append(itm);
        });

        $('#project_users_save').prop('disabled', false);
      }
    });

    $('#user_candidate_filter').on('keyup', function (event) {
      var queryStr = new RegExp(event.target.value, 'i');
      //console.log(queryStr);
      tubeFilter(queryStr, '#user_candidate_holder');
    });
    $('#project_users_filter').on('keyup', function (event) {
      var queryStr = new RegExp(event.target.value, 'i');
      //console.log(queryStr);
      tubeFilter(queryStr, '#project_users_holder');
    });


    $('#project_users_save').click(function () {
      var project_users_holder = $('#project_users_holder');
      var new_users_id_array = project_users_holder
          .find('.tube-active:not(.tube-inactive)')
          .map(function () {
            return $(this).attr('id').replace('user_id-', '');
          }).get();
      var del_users_id_array = project_users_holder.find('.tube-inactive:not(.tube-active)')
          .map(function () {
            return $(this).attr('id').replace('user_id-', '');
          }).get();

      var project_id = $('#project_id').val();
      $.ajax({
        type: 'POST',
        url: '/ngsLIMS/setting/projectUsers/' + project_id,
        data: {
          new_users_id_array: new_users_id_array,
          del_users_id_array: del_users_id_array
        }
      })
          .done(function (data) {
            //console.log(data);
            window.location.reload();  // @TODO It should not be re-loaded.
          });

    });
  });

</script>
