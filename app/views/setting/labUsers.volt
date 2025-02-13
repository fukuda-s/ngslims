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

<div class="row">
  <div class="col-md-12">
    <ol class="breadcrumb">
      <li>{{ link_to('setting', 'Setting') }}</li>
      <li>{{ link_to('setting/labs', 'Labs') }}</li>
      <li>{{ lab.name }}</li>
      <li class="active">Laboratory Members</li>
    </ol>

    {{ content() }}
    {{ flashSession.output() }}
  </div>
</div>

{{ hidden_field('lab_id', 'value': lab.id) }}

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
            <h3 class="panel-title col-sm-10">Lab. Member List</h3>
          </div>
          <div class="col-sm-2">
            <button type="button" id="lab_users_save" class="btn btn-primary pull-right" disabled="disabled">Save
            </button>
          </div>
        </div>
      </div>
      <div class="panel-body">
        <div class="form-group">
          {{ text_field('lab_users_filter', 'class': "form-control", 'placeholder': 'Search Users') }}
        </div>
        <div class="tube-group">
          <div class="tube-list" id="lab_users_holder">
            {% for user in lab.getLabUsersUsers(["active = 'Y'", 'order': 'lastname ASC, firstname ASC']) %}
              {% set user_lab_count = user.LabUsers|length %}
              <div class="tube" id="user_id-{{ user.id }}">{{ user.getFullname() }}
                {% if user_lab_count > 1 %}
                  <a href="javascript:void(0)" class="tube-close pull-right" onclick="tubeCloseToggle(this)">
                    <i class="fa fa-times" aria-hidden="true"></i>
                    <i class="fa fa-repeat" aria-hidden="true" style="display: none"></i>
                  </a>
                {% else %}
                  {% set trash_message = "Could not delete this Member. This member belongs to only this laboratory." %}
                  <a href="javascript:void(0)" data-toggle="tooltip" data-placement="bottom" title="{{ trash_message }}"
                     style="color: #b9c4c8; cursor: not-allowed;" class="tube-close pull-right disabled"
                     onclick="return false;">
                    <i class="fa fa-times" aria-hidden="true"></i>
                  </a>
                {% endif %}
              </div>
              {% elsefor %} No Lab. Members are recorded
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
    $(target)
        .parent('.tube')
        .toggleClass('tube-inactive');
    $(target)
        .find('i')
        .toggle();

    var lab_users_holder = $('#lab_users_holder');
    var lab_users_save = $('#lab_users_save');
    if (lab_users_holder.find('div.tube-active:not(.tube-inactive)').length //For dragged users
        || lab_users_holder.find('div.tube-inactive:not(.tube-active)').length) { //For original users
      lab_users_save.prop('disabled', false);
    } else {
      lab_users_save.prop('disabled', true);
    }
  }

  $(document).ready(function () {
    $('#user_candidate_holder').sortable({
      connectWith: "#lab_users_holder",
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

    $('#lab_users_holder').sortable({
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

        $('#lab_users_save').prop('disabled', false);
      }
    });

    $('#user_candidate_filter').on('keyup', function (event) {
      var queryStr = new RegExp(event.target.value, 'i');
      //console.log(queryStr);
      tubeFilter(queryStr, '#user_candidate_holder');
    });
    $('#lab_users_filter').on('keyup', function (event) {
      var queryStr = new RegExp(event.target.value, 'i');
      //console.log(queryStr);
      tubeFilter(queryStr, '#lab_users_holder');
    });


    $('#lab_users_save').click(function () {
      var lab_users_holder = $('#lab_users_holder');
      var new_users_id_array = lab_users_holder
          .find('.tube-active:not(.tube-inactive)')
          .map(function () {
            return $(this).attr('id').replace('user_id-', '');
          }).get();
      var del_users_id_array = lab_users_holder.find('.tube-inactive:not(.tube-active)')
          .map(function () {
            return $(this).attr('id').replace('user_id-', '');
          }).get();

      var lab_id = $('#lab_id').val();
      $.ajax({
        type: 'POST',
        url: '/ngsLIMS/setting/labUsers/' + lab_id,
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
