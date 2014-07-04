<div class="tube-group">
  <div class="tube tube-header">
    <div class="row">
      <div class="col-md-4">Lane #</div>
      <div class="col-md-4">Seqtemplate Name</div>
      <div class="col-md-4"></div>
    </div>
  </div>
  {% for seqlane_index in seqlane_indexes %}
  {% set seqlane = seqlanes[seqlane_index] %}
  {% if loop.first %}
  <div class="tube-list" id="seqlane-holder">
  {% endif %}
  {% if seqlane is empty %}
    <div class="tube tube-empty">
  {% elseif seqlane.sl.is_control == 'Y' %}
    <div class="tube tube-empty" id="seqlane-tube-seqlane-id-{{ seqlane.sl.id }}">
  {% else %}
    <div class="tube tube-active" id="seqlane-tube-seqlane-id-{{ seqlane.sl.id }}"
         onclick="showPopoverTableSeqlibs(this, {{ seqlane.st.id }}, '{{ seqlane.st.name }}', {{ seqlane.sl.id }})">
  {% endif %}
      <div class="tube-heading">
        <div class="row">
          <div class="col-md-4">
            {{ seqlane_index + 1 }}
          </div>
          <div class="col-md-8">
            {% if seqlane is empty %}
              n/a
            {% elseif seqlane.sl.is_control == 'Y' %}
              {{ seqlane.ct.name }}
            {% else %}
              {{ seqlane.st.name }}
            {% endif %}
          </div>
        </div>
     </div>
    </div>
  {% if loop.last %}
  </div>
  {% endif %}
  {% elsefor %} No seqtemplates are recorded
  {% endfor %}
</div>