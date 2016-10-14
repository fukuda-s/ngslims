{% for seqtemplate_index, seqtemplate in seqtemplates %}
  <div class="tube-responsive tube-dualmultiplex" id="seqtemplate_index_{{ seqtemplate_index }}">
    {% for indexB, oligobarcodeB in oligobarcodeBs %}
      {% if indexB == 0 %} {# @TODO loop.first couldn't use here, it is bug of phalcon? #}
        <ul class="tube-header-list">
          <li class="tube tube-sm tube-sm-header tube-sm-row-header sort-disabled">{{ seqtemplate_index }}
            <button type="button" id="toggole-barcode-button" class="btn btn-info btn-xs pull-left">
              <i class="fa fa-arrow-down" aria-hidden="true"></i>
            </button>
          </li>
          {% for indexA, oligobarcodeA in oligobarcodeAs %}
            {% if seqtemplate_count[oligobarcodeA.o.id] is not defined %}
              <li id="oligobarcodeA_id_{{ oligobarcodeA.o.id }}"
                  class="tube tube-sm tube-sm-header tube-sm-col-header sort-disabled tube-collapse">{{ oligobarcodeA.o.name }}
                <br>{{ oligobarcodeA.o.barcode_seq }}</li>
            {% else %}
              <li id="oligobarcodeA_id_{{ oligobarcodeA.o.id }}"
                  class="tube tube-sm tube-sm-header tube-sm-col-header sort-disabled">{{ oligobarcodeA.o.name }}
                <br>{{ oligobarcodeA.o.barcode_seq }}</li>
            {% endif %}
          {% endfor %}
        </ul>
      {% endif %}
      {% if seqtemplate_count[oligobarcodeB.o.id] is not defined %}
        {% set oligobarcodeB_tube_collapse = "tube-collapse" %}
      {% else %}
        {% set oligobarcodeB_tube_collapse = "" %}
      {% endif %}
      <ul class="tube-list-row {{ oligobarcodeB_tube_collapse }}" id="oligobarcodeB_id_{{ oligobarcodeB.o.id }}">
        <ul class="tube-list-col">
          <li class="tube tube-sm tube-sm-header tube-sm-row-header sort-disabled {{ oligobarcodeB_tube_collapse }}">{{ oligobarcodeB.o.name }}
            : {{ oligobarcodeB.o.barcode_seq }}</li>
        </ul>
        {% for indexA, oligobarcodeA in oligobarcodeAs %}
          <ul class="tube-list-col"
              id="{{ "oligobarcode_index_" ~ indexA ~ "_" ~ indexB ~ "_" ~ seqtemplate_index }}">
            {% if seqlibs_in_barcode[seqtemplate_index][oligobarcodeB.o.id][oligobarcodeA.o.id] is defined %}
              {% set seqlib = seqlibs_in_barcode[seqtemplate_index][oligobarcodeB.o.id][oligobarcodeA.o.id] %}
              {% if seqlib.se.status == 'Completed' and seqlib.sta_count === 0 %}
                <li class="tube tube-sm tube-active sort-disabled"
                    id="seqlib_id_{{ seqlib.sl.id }}">{{ seqlib.sl.name }}
                  <button type="button" class="tube-close pull-right">&times;</button>
                  <!--
                  <button type="button" class="tube-copy btn btn-default btn-xs pull-right"><i class="fa fa-copy"></i>
                  -->
                  </button>
                </li>
              {% else %}
                <li class="tube tube-sm tube-inactive sort-disabled"
                    id="seqlib_id_{{ seqlib.sl.id }}">{{ seqlib.sl.name }}
                  <button type="button" class="tube-close pull-right">&times;</button>
                  <!--
                  <button type="button" class="tube-copy btn btn-default btn-xs pull-right"><i class="fa fa-copy"></i>
                  -->
                  </button>
                </li>
              {% endif %}
            {% else %}
              {% if seqtemplate_count[oligobarcodeA.o.id] is not defined or seqtemplate_count[oligobarcodeB.o.id] is not defined %}
                <li class="tube tube-sm tube-empty tube-collapse"></li>
              {% else %}
                <li class="tube tube-sm tube-empty"></li>
              {% endif %}
            {% endif %}
          </ul>
        {% endfor %}
      </ul>
      {% if loop.last %}
      {% endif %}
      {% elsefor %} No records on oligobarcodeBs
    {% endfor %}
  </div>
{% endfor %}