<div class="tube-responsive">
  {% for index, oligobarcodeA in oligobarcodeAs %}
    {% if index == 0 %} {# @TODO loop.first couldn't use here, it is bug of phalcon. #}
      <ul class="tube-header-list" id="seqtemplate-matrix-header">
        <li class="tube tube-sm-header tube-sm-row-header">
          <button type="button" id="toggole-barcode-button" class="btn btn-info btn-xs pull-left">
            <i class="fa fa-arrow-down" aria-hidden="true"></i>
          </button>
          OligoBarcode
        </li>
        {% for seqtemplate_index in 0..(seqtemplate_count - 1) %}
          <li id="seqtemplate_index_{{ seqtemplate_index }}"
              class="tube tube-sm-header">{{ seqtemplate_index + 1 }}</li>
          {% elsefor %} No records on seqtemplates
        {% endfor %}
        <li class="" style="display: inline-block;">
          <button type="button" id="add-seqtemplate-button" class="btn btn-primary btn-xs"><i
                class="glyphicon glyphicon-plus" style="min-height: 20px; padding: 2px 2px"></i></button>
        </li>
      </ul>
      <div id="seqtemplate-matrix-body">
      <ul class="tube-list" id="oligobarcodeA_id_null">
        <li class="tube tube-sm tube-sm-header sort-disabled tube-sm-row-header">No Barcode</li>
        {% for seqtemplate_index in 0..(seqtemplate_count - 1) %}
          <li class="tube tube-sm tube-empty"></li>
        {% endfor %}
      </ul>
    {% endif %}

    {% set oligobarcode_set = 0 %}
    <ul class="tube-list" id="oligobarcodeA_id_{{ oligobarcodeA.o.id }}">
      {% if oligobarcode_set is 0 %}
        {% if seqlibs_in_barcode[oligobarcodeA.o.id] is defined %}
          <li class="tube tube-sm tube-sm-header sort-disabled tube-sm-row-header">
        {% else %}
          <li class="tube tube-sm tube-sm-header sort-disabled tube-sm-row-header tube-collapse">
        {% endif %}
        {{ oligobarcodeA.o.name }} : {{ oligobarcodeA.o.barcode_seq }}
        </li>
      {% endif %}
      {% for seqtemplate_index in 0..(seqtemplate_count - 1) %}
        {% if seqlibs_in_barcode[oligobarcodeA.o.id][seqtemplate_index] is defined %}
          {% set seqlib = seqlibs_in_barcode[oligobarcodeA.o.id][seqtemplate_index] %}
          {% if seqlib.se.status == 'Completed' and seqlib.sta_count === 0 %}
            {% set tube_class = "tube-active" %}
          {% else %}
            {% set tube_class = "tube-inactive" %}
          {% endif %}
          <li class="tube tube-sm {{ tube_class }}"
              id="seqlib_id_{{ seqlib.sl.id }}">
            {{ seqlib.sl.name }}
            <button type="button" class="tube-close pull-right">&times;</button>
            <button type="button" class="tube-copy btn btn-default btn-xs pull-right"><i class="fa fa-copy"></i>
            </button>
          </li>
        {% elseif seqlibs_in_barcode[oligobarcodeA.o.id] is defined %}
          <li class="tube tube-sm tube-empty"></li>
        {% else %}
          <li class="tube tube-sm tube-empty tube-collapse"></li>
        {% endif %}
      {% endfor %}


    </ul>
    {% if loop.last %}
      </div>
    {% endif %}
    {% elsefor %} No records on oligobarcodeAs
  {% endfor %}
</div>