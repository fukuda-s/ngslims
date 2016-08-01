<div class="tube-group">
  <div class="tube tube-header" style="margin: 2px 0 2px 0 !important;">
    <div class="col-md-9">Seqtemplate Name</div>
    <div class="col-md-2"></div>
    <div class="col-md-1 text-right"># used</div>
    <div class="clearfix"></div>
  </div>
  <div class="tube-list" style="max-height: 400px;overflow-y: scroll;">
    {% for seqtemplate in seqtemplates %}
      <div
          class="tube {% if seqtemplate.se.status == '' %}tube-active{% else %}tube-inactive{% endif %}"
          id="seqtemplate_id-{{ seqtemplate.st.id }}" style="margin: 2px 0 2px 0 !important;">
        <div class="col-md-9">
          {{ seqtemplate.st.name }}
        </div>
        <div class="col-md-2">
          {{ text_field('apply_conc_seqtemplate_id-' ~ seqtemplate.st.id, 'class': 'form-control input-xs', 'style': 'display: none;' ) }}
        </div>
        <div class="col-md-1 text-right">
          <span class="badge">{{ seqtemplate.sl_count }}</span>
        </div>
      </div>
      {% elsefor %} No seqtemplates are recorded
    {% endfor %}
    {% for control in controls %}
      <div class="tube tube-placeholder" id="control_id-{{ control.id }}" style="margin: 2px 0 2px 0 !important;">
        <div class="col-md-9">
          {{ control.name ~ ' (Control Lane)' }}
        </div>
        <div class="col-md-2">
          {{ text_field('apply_conc_control_id-' ~ seqtemplate.st.id, 'class': 'form-control input-xs', 'style': 'display: none;' ) }}
        </div>
        <div class="col-md-1 text-right">
          <span class="badge"></span>
        </div>
      </div>
    {% endfor %}
  </div>
</div>
