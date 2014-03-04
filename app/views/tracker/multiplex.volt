{{ content() }}
{% for seqlib in seqlibs %}
  {% if loop.first %}
    <div class="row">
    <div class="col-md-12">
    <ul class="tube-list">
  {% endif %}
  {% if seqlib.se.status == 'Completed' %}
    <li class="tube tube-sm tube-active" id="seqlib-id-{{ seqlib.sl.id }}">{{ seqlib.sl.name }}</li>
  {% else %}
    <li class="tube tube-sm tube-inactive" id="seqlib-id-{{ seqlib.sl.id }}">{{ seqlib.sl.name }}</li>
  {% endif %}
  {% if loop.last %}
    </ul>
    </div>
    </div>
  {% endif %}
{% endfor %}
