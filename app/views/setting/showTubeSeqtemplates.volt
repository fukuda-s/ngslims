<div class="tube-group">
  <div class="tube tube-header" style="margin: 2px 0 2px 0 !important;">
    <div class="col-md-10">Seqtemplate Name</div>
    <div class="col-md-2 text-right"># of used</div>
    <div class="clearfix"></div>
  </div>
  {% for seqtemplate in seqtemplates %}
    {% if loop.first %}
      <div class="tube-list" style="max-height: 400px;overflow-y: scroll;">
    {% endif %}
    <div
        class="tube {% if seqtemplate.se.status == '' %}tube-active{% else %}tube-inactive{% endif %}"
        id="seqtemplate_id-{{ seqtemplate.st.id }}" style="margin: 2px 0 2px 0 !important;">
      <div class="col-md-10">
        {{ seqtemplate.st.name }}
      </div>
      <div class="col-md-2 text-right">
        <span class="badge">{{ seqtemplate.sl_count }}</span>
      </div>
    </div>
    {% if loop.last %}
      </div>
    {% endif %}
    {% elsefor %} No seqtemplates are recorded
  {% endfor %}
</div>
