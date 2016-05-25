{{ flashSession.output() }}
{{ content() }}

<div class="panel panel-default">
  <div class="panel-heading">
    <div class="panel-title">
      <h5>Create New Cherry Picking List</h5>
    </div>
  </div>
  <div class="panel-body">
    <div class="row">
      <div class="col-sm-3">
        <form id="pick_form" method="post">
          <div class="form-group">
            <label for="pick_query">Search Seqlibs</label>
            {{ text_field('pick_query', 'size': "30", 'class': "form-control") }}
          </div>
        </form>
      </div>
    </div>
  </div>
  <!--<div id="pick_search_result_samples">-->
  <div id="pick_search_result_seqlibs">
  </div>
  <div class="panel-footer">
    <div class="row">
      <div class="col-md-10">
      </div>
      <div class="col-md-2">
        {{ form('cherrypicking/confirm', 'id': 'pick_result') }}
        <button id="cherrypick-seqlibs-button" type="submit" class="btn btn-primary">Pick Seqlibs &raquo;</button>
        {{ hidden_field('cherrypick-seqlibs') }}
        {{ hidden_field('pick_query_hidden') }}
        {{ hidden_field('tube-filter_hidden') }}
        {{ endform() }}
      </div>
    </div>
  </div>
</div>

<hr>

<div class="panel panel-default">
  <div class="panel-heading">
    <div class="panel-title">
      <h5>My Cherry Picking Lists</h5>
    </div>
  </div>
  <div class="panel-body">
    <div class="panel-group">
      {% for cherry_picking in cherry_pickings %}
        {% if loop.first %}
          <div class="panel panel-default">
            <div class="panel-heading">
              <div class="row">
                <div class="col-md-4">Cherry Picking Name</div>
                <div class="col-md-1">
                  <small>#seqlib</small>
                </div>
                <div class="col-md-5">Seqlib Names</div>
                <div class="col-md-2">
                  <button type="button" class="btn btn-default btn-xs" id="show-inactive-panel" data-toggle="collapse"
                          data-target="[id^=inactives]">
                    Show Inactive
                  </button>
                </div>
              </div>
            </div>
          </div>
        {% endif %}

        <div {% if cherry_picking.cp.active is 'Y' %} class="panel panel-info" id="cherry_picking_id_{{ cherry_picking.cp.id }}"
        {% else %} class="panel panel-default collapse" id="inactives-{{ cherry_picking.cp.id }}" {% endif %}>
          <div class="panel-heading" id="OwnerList">
            <h4 class="panel-title">
              <div class="row">
                <div class="col-md-4">
                  <div
                      class="">{{ link_to('trackerdetails/editSeqlibs/PICK/0/' ~ cherry_picking.cp.id, cherry_picking.cp.name ~ ' -- ' ~ cherry_picking.cp.created_at) }}</div>
                </div>
                <div class="col-md-1">
                  <span class="badge">{{ cherry_picking.sample_count }}</span>
                </div>
                <div class="col-md-7">
                  <div class="">{{ "%.60s..."|format(cherry_picking.seqlib_names) }}</div>
                </div>
              </div>
            </h4>
          </div>
        </div>
        {% elsefor %} No cherry_pickings are recorded
      {% endfor %}
    </div>
  </div>
</div>

<script>
  function showTubeSeqlibsWithSearch(event) {
    // Cancel HTML submit
    event.preventDefault();

    // 操作対象のフォーム要素を取得
    var $form = $(event.target);

    // 送信ボタンを取得
    // （後で使う: 二重送信を防止する。）
    var $button = $form.find('button');

    // 送信
    $.ajax({
      //url: 'showTubeSamples',
      url: 'showTubeSeqlibs',
      type: $form.attr('method'),
      data: $form.serialize(),
      dataType: 'html',
      timeout: 10000,  // 単位はミリ秒
      // 送信前
      beforeSend: function (xhr, settings) {
        // ボタンを無効化し、二重送信を防止
        $button.attr('disabled', true);
      }
    })

    // 応答後
        .always(function (xhr, textStatus) {
          // ボタンを有効化し、再送信を許可
          $button.attr('disabled', false);
        })

        // 通信成功時の処理
        .done(function (data) {
          // 入力値を初期化
          //$form[0].reset();

          $pick_search_result_seqlibs = $('#pick_search_result_seqlibs');
          //$('#pick_search_result_samples').html(data);
          $pick_search_result_seqlibs.html(data);

          /*
           * Add selectable function to seqlib tubes.
           */
          $pick_search_result_seqlibs
              .find("#sample-holder")
              .selectable();

          /*
           * put function to "Show inactive" button.
           */
          $pick_search_result_seqlibs
              .find('button#show-inactive-tube').click(function (e) {
            // @TODO 'Show/Hide Inactive' button should be hidden if .tube-inactive(s) are not exist.
            if ($(e.target).hasClass('active') == false) {
              $pick_search_result_seqlibs
                  .find('.tube-inactive')
                  .show('slow');
              $(e.target)
                  .addClass('active')
                  .text('Hide Inactive');
            } else {
              $pick_search_result_seqlibs
                  .find('.tube-inactive')
                  .hide('slow');
              $(e.target)
                  .removeClass('active')
                  .text('Show Inactive');
            }

          });
          /*
           * put function to "Select all" button.
           */
          $pick_search_result_seqlibs
              .find('button#select-all').click(function (e) {

            if ($(e.target).hasClass('active') == false) {
              $pick_search_result_seqlibs
                  .find('.tube.ui-selectee')
                  .filter(function () {
                    var css_display = $(this).css('display');
                    return css_display != 'none';
                  })
                  .addClass('ui-selected');
              $(e.target)
                  .addClass('active')
                  .text('Un-select all');
            } else {
              $pick_search_result_seqlibs
                  .find('.tube.ui-selectee')
                  .filter(function () {
                    var css_display = $(this).css('display');
                    return css_display != 'none';
                  })
                  .removeClass('ui-selected');
              $(e.target)
                  .removeClass('active')
                  .text('Select all');
            }

          });

          /*
           * Put function to 'Search' form on tube list header.
           */
          function tubeFilter(queryStr) {
            $('.tube.ui-selectee')
                .filter(function () {
                  var css_display = $(this).css('display');
                  var tube_textStr = $(this).text().toString();
                  //console.log(index + ":" + css_display != 'none' && ! queryStr.test(tube_textStr));
                  return css_display != 'none' && !queryStr.test(tube_textStr);
                })
                .addClass('tube-hidden');

            $('.tube-hidden')
                .filter(function () {
                  var tube_textStr = $(this).text().toString();
                  return queryStr.test(tube_textStr);
                })
                .removeClass('tube-hidden');
          }

          $('#tube-filter').on('keyup', function (event) {
            var queryStr = new RegExp(event.target.value);
            //console.log(queryStr);
            tubeFilter(queryStr);
          });

          if (location.search) {
            var query = $.getUrlVar('q_f');
            if (query) {
              $('#tube-filter').val(query);
              var queryStr = new RegExp(query);
              //console.log(queryStr);
              tubeFilter(queryStr);
            }
          }


          function getPickedSeqlibs() {
            var seqlibs = [];
            $('#pick_search_result_seqlibs')
                .find('.tube.ui-selected')
                .each(function () {
                  var seqlib_id = this.id.replace("seqlib-id-", "");
                  seqlibs.push(seqlib_id);
                });

            //console.log(seqlibs);
            $('#cherrypick-seqlibs').val(seqlibs);
            $('#pick_query_hidden').val($('#pick_query').val());
            $('#tube-filter_hidden').val($('#tube-filter').val());
            if (seqlibs.length > 0) {
              return true;
            } else {
              return false;
            }
          }

          $('#pick_result').submit(function () {
            return getPickedSeqlibs();
          });
        })

        /*
         * 通信失敗時の処理
         */
        .fail(function (xhr, textStatus, error) {
        });
  }


  $(document).ready(function () {
    $('#pick_form').submit(function (event) {
      showTubeSeqlibsWithSearch(event)
    });

    /*
     * If URL has #pi_user_id_ then open collapsed panel-body
     */
    if (location.search) {
      var query = $.getUrlVar('q');
      if (query) {
        $('#pick_query').val(query);
        $('#pick_form').submit(); //showTubeSeqLibsWithSearch()が実行される
      }
    }


  });
</script>
