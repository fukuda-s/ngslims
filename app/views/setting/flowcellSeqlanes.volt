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
  <div class="col-sm-12">
    <ol class="breadcrumb">
      <li>{{ link_to('setting', 'Setting') }}</li>
      <li>{{ link_to('setting/flowcells', 'Flowcells') }}</li>
      <li>{{ flowcell.name }}</li>
      <li class="active">Flowcell Seqlane (Seqtemplate)</li>
    </ol>

    {{ content() }}
    {{ flashSession.output() }}
  </div>
</div>


<div class="row">
  <div class="col-sm-6">
    <div class="panel panel-default">
      <div class="panel-heading">
        <h3 class="panel-title">Candidate Seqtemplates List</h3>
      </div>
      <div class="panel-body">
        <form id="pick_form" method="post">
          <div class="form-group">
            {{ text_field('pick_query', 'class': "form-control", 'placeholder': 'Search Seqlanes (Seqtemplates)') }}
            {{ hidden_field('flowcell_id', 'value': flowcell.id) }}
          </div>
        </form>
        <div class="tube-group" id="seqtemplate_candidate_holder">
        </div>
      </div>
    </div>
  </div>
  <div class="col-sm-6">
    <div class="panel panel-default">
      <div class="panel-heading">
        <div class="row">
          <div class="col-sm-10">
            <h3 class="panel-title col-sm-10">Flowcell Seqlane (Seqtemplate) List</h3>
          </div>
          <div class="col-sm-2">
            <button type="button" id="flowcell_seqlanes_save" class="btn btn-primary pull-right"
                    disabled="disabled">Save
            </button>
          </div>
        </div>
      </div>
      <div class="panel-body">
        <ol class="tube-group" id="flowcell_seqlanes_holder"
            style="font-family: Consolas, 'Courier New', Courier, Monaco, monospace;">
          <div class="tube tube-header" style="margin: 2px 0 2px 0 !important;">
            <div class="col-md-1">#</div>
            <div class="col-md-8">Seqtemplate Name</div>
            <div class="col-md-2">Conc. (pM)</div>
            <div class="col-md-1"></div>
            <div class="clearfix"></div>
          </div>
          {% set lane_per_flowcell = flowcell.SeqRunmodeTypes.lane_per_flowcell %}
          {% set lane_index_arr = 1..lane_per_flowcell %}
          {% set seqlane_index = 0 %}
          {% for lane_index in lane_index_arr %}
            <div class="clearfix"></div>
            {% if flowcell_seqlanes[seqlane_index] is not defined %}
              <li class="tube tube-placeholder"
                  style="margin: 2px 0 2px 0 !important;"></li>
            {% else %}
              {% set flowcell_seqlane = flowcell_seqlanes[seqlane_index] %}
              {% if lane_index == flowcell_seqlane.number %}
                <li class="tube tube-active"
                    {% if flowcell_seqlane.Seqtemplates is not empty %}
                      id="seqtemplate_id-{{ flowcell_seqlane.Seqtemplates.id }}"
                    {% elseif flowcell_seqlane.Controls is not empty %}
                      id="control_id-{{ flowcell_seqlane.Controls.id }}"
                    {% endif %}
                    seqlane_id="{{ flowcell_seqlane.id }}"
                    style="margin: 2px 0 2px 0 !important;">
                  <div class="col-md-1 badge">
                    {{ flowcell_seqlane.number }}
                  </div>
                  <div class="col-md-8">
                    {% if flowcell_seqlane.Seqtemplates is not empty %}
                      {{ flowcell_seqlane.Seqtemplates.name }}
                    {% elseif flowcell_seqlane.Controls is not empty %}
                      {{ flowcell_seqlane.Controls.name ~ ' (Control Lane)' }}
                    {% endif %}
                  </div>
                  <div class="col-md-2">
                    {{ text_field('apply_conc-' ~ flowcell_seqlane.id, 'class': 'form-control input-xs', 'value': flowcell_seqlane.apply_conc ) }}
                  </div>
                  <div class="col-md-1">
                    <a href="javascript:void(0)" class="tube-close pull-right" onclick="tubeCloseToggle(this)">
                      <i class="fa fa-times" aria-hidden="true"></i>
                      <i class="fa fa-repeat" aria-hidden="true" style="display: none"></i>
                    </a>
                  </div>
                </li>
                {% set seqlane_index = seqlane_index + 1 %}
              {% else %}
                <li class="tube tube-placeholder"
                    style="margin: 2px 0 2px 0 !important;"></li>
              {% endif %}
            {% endif %}
            {% elsefor %} No Seqlanes are recorded
          {% endfor %}
        </ol>
      </div>
    </div>
  </div>
</div>

<script>
  /**
   * Toggle button icon and tube class
   */
  function tubeCloseToggle(target) {
    $(target)
        .parents('.tube')
        .toggleClass('tube-active')
        .toggleClass('tube-inactive');
    $(target)
        .find('i')
        .toggle();

    var flowcell_seqlanes_holder = $('#flowcell_seqlanes_holder');
    var flowcell_seqlanes_save = $('#flowcell_seqlanes_save');
    if (flowcell_seqlanes_holder.find('li.tube-inactive:not(.tube-active)').length
        || flowcell_seqlanes_holder.find('[id^=seqtemplate_id-]').length
        || flowcell_seqlanes_holder.find('[id^=control_id-]').length
    ) { //For dragged flowcells
      flowcell_seqlanes_save.prop('disabled', false);
    } else {
      flowcell_seqlanes_save.prop('disabled', true);
    }
  }

  /**
   * Search and display seqlanes which searched from #pick_query
   */
  function showTubeSeqtemplatesWithSearch(event) {
    // Cancel HTML submit
    event.preventDefault();

    // 操作対象のフォーム要素を取得
    var $form = $(event.target);

    // 送信ボタンを取得
    // （後で使う: 二重送信を防止する。）
    var $button = $form.find('button');

    // 送信
    $.ajax({
      url: '/ngsLIMS/setting/showTubeSeqtemplates',
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

          var seqtemplate_candidate_holder = $('#seqtemplate_candidate_holder');
          //$('#pick_search_result_samples').html(data);
          seqtemplate_candidate_holder
              .html(data);

          /*
           * Set draggable for seqtemplate panels
           */
          $('#seqtemplate_candidate_holder')
              .find('.tube[id^=seqtemplate_id-],.tube[id^=control_id-]')
              .draggable({
                zIndex: 10000,
                addClasses: false,
                cursor: 'move',
                helper: "clone"
              });

          $('[id^=apply_conc_]').change(function () {
            $('#flowcell_seqlanes_save').prop('disabled', false);
          });

        })
        /*
         * 通信失敗時の処理
         */
        .fail(function (xhr, textStatus, error) {
        });
  }

  $(document).ready(function () {

    $('#flowcell_seqlanes_holder li').each(function () {
      $(this).droppable({
        addClasses: false,
        hoverClass: "tube tube-placeholder",
        accept: ":not(.ui-sortable-helper)",
        tolerance: "pointer",
        drop: function (event, ui) {
          var id_attr = ui.draggable.context.getAttribute("id");
          var name_attr = ui.draggable.context.innerHTML;
          if (id_attr.match(/^seqtemplate_id/)) {
            $(this)
                .addClass("tube tube-active")
                .attr("id", id_attr)
                .html(name_attr)
                .find('[id^=apply_conc_seqtemplate_id-]')
                .show();
          } else if (id_attr.match(/^control_id/)) {
            $(this)
                .addClass("tube tube-warning")
                .attr("id", id_attr)
                .html(name_attr)
                .find('[id^=apply_conc_control_id-]')
                .show();
          }
          $('#flowcell_seqlanes_save').prop('disabled', false);
        },
        out: function (event, ui) {
          $(this).addClass('tube');
        }
      });
    });

    $('#flowcell_seqlanes_holder').sortable({
      items: '> li',
      update: function (event, ui) {
        /*
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
         */
        $('#flowcell_seqlanes_save').prop('disabled', false);
      }
    });

    $('[id^=apply_conc]').change(function () {
      $('#flowcell_seqlanes_save').prop('disabled', false);
    });

    $('#flowcell_seqlanes_save').click(function () {
      var seqlane_array = [];
      $('#flowcell_seqlanes_holder')
          .find('li.tube')
          .each(function (index) {
            var id_str = $(this).attr('id');
            var seqlane_id = $(this).attr('seqlane_id');
            var apply_conc = $(this).find('[id^=apply_conc]').val();
            if ($(this).filter(".tube-active").length) {
              seqlane_array[index] = {
                'id_str': id_str,
                'seqlane_id': seqlane_id,
                'apply_conc': apply_conc,
                'is_active': 'Y'
              };
            } else if ($(this).filter(".tube-inactive").length) {
              seqlane_array[index] = {
                'id_str': id_str,
                'seqlane_id': seqlane_id,
                'apply_conc': apply_conc,
                'is_active': 'N'
              };
            }
          });

      var seqlane_array_json = JSON.stringify(seqlane_array);
      var flowcell_id = $('#flowcell_id').val();
      $.ajax({
        type: 'POST',
        url: '/ngsLIMS/setting/flowcellSeqlanes/' + flowcell_id,
        data: {
          seqlane_array_json: seqlane_array_json
        }
      })
          .done(function (data) {
            console.log(data);
            window.location.reload();  // @TODO It should not be re-loaded.
          });

    });

    $('#pick_form').submit(function (event) {
      showTubeSeqtemplatesWithSearch(event)
    });
  });
</script>
